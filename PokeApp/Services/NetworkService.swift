//
//  NetworkService.swift
//  PokeApp
//
//  Created by Кирилл Романенко on 02.04.2021.
//

import UIKit

class NetworkService {
    let urlSession = URLSession.shared
    
    private let host = "https://pokeapi.co"
    private let api = "/api/v2/"
    private var baseUrl: String { host + api }
    
    func request<T: Codable>(type: RequestType,
                             method: MethodType = .get,
                             parameters: [String : Any]? = nil,
                             completion: @escaping (Result<T, Error>) -> Void)  {
        guard let url = URL(string: baseUrl + type.path) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        if let parameters = parameters {
            guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else { return }
            request.httpBody = httpBody
        }
        
        DispatchQueue.global(qos: .utility).async {
            self.urlSession.dataTask(with: request) { data, response, error in
                print("url: \(url)\nresponse: \(String(describing: response))")
                
                if let error = error {
                    print("url: \(url)\nerror: \(String(describing: error))")
                    completion(.failure(error))
                    return
                }
                
                guard let data = data else { return }
                
                DispatchQueue.main.async {
                    do {
                        let value = try JSONDecoder().decode(T.self, from: data)
                        print("url: \(url)\nvalue: \(String(describing: value))")
                        completion(.success(value))
                        
                    } catch let jsonError {
                        print("url: \(url)\njsonError: \(String(describing: jsonError))")
                        completion(.failure(jsonError))
                    }
                }
            }.resume()
        }
    }
}

extension NetworkService {
    enum MethodType: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
    }
}
