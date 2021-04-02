//
//  PokeService.swift
//  PokeApp
//
//  Created by Кирилл Романенко on 01.04.2021.
//

import UIKit

class PokeService: NetworkService {
    static let shared = PokeService()
    private override init() {}
    
    func pokemon(id: Int, completion: @escaping (Pokemon) -> Void) {
        request(type: .pokemon(id: id)) { (result: Result<Pokemon, Error>) in
            switch result {
            case .success(let pokemon):
                completion(pokemon)
            case .failure(let error):
                if let topViewController = UIApplication.topViewController as? AlertRoutable {
                    topViewController.showAlert(title: "Error", message: error.localizedDescription)
                }
            }
        }
    }
}
