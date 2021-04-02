//
//  NetworkService.swift
//  PokeApp
//
//  Created by Кирилл Романенко on 02.04.2021.
//

import UIKit

class NetworkService {
    static let urlSession = URLSession(configuration: .default)
    
    private let host = "https://pokeapi.co"
    private let api = "/api/v2/"
    private var baseUrl: String { host + api }
    
    func request<T: Codable>(type: RequestType, completion: @escaping (Result<T, Error>) -> Void)  {
        guard let url = URL(string: baseUrl + type.path) else { return }
        DispatchQueue.global(qos: .utility).async {
            NetworkService.urlSession.dataTask(with: url) { data, response, error in
                print("url: \(url)\nresponse: \(String(describing: response))")
                
                if let error = error {
                    print("url: \(url)\nresponse: \(String(describing: error))")
                    completion(.failure(error))
                    return
                }
                
                guard let data = data else { return }
                DispatchQueue.main.async {
                    do {
                        let value = try JSONDecoder().decode(T.self, from: data)
                        print(value)
                        completion(.success(value))
                    } catch let jsonError {
                        completion(.failure(jsonError))
                    }
                }
            }.resume()
        }
    }
}
