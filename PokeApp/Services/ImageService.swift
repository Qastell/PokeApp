//
//  ImageService.swift
//  PokeApp
//
//  Created by Кирилл Романенко on 02.04.2021.
//

import UIKit

class ImageService: NetworkService {
    static let shared = ImageService()
    private override init() {}
    
    func downloadImage(url: URL, completion: @escaping (UIImage) -> Void) {
        DispatchQueue.global(qos: .utility).async {
            self.urlSession.dataTask(with: url) { data, response, error in
                guard let data = data, let image = UIImage(data: data) else { return }
                DispatchQueue.main.async {
                    completion(image)
                }
            }.resume()
        }
    }
}
