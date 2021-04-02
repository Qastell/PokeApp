//
//  PokeController.swift
//  PokeApp
//
//  Created by Кирилл Романенко on 02.04.2021.
//

import UIKit

class PokeController: ViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    private let localNotificationsService = LocalNotificationService()
    
    private let randomNumber = Int.random(in: 0..<151)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addObserver()
        fetchPokemon(id: randomNumber)
    }
    
    private func addObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(backgroundFetchPokemon),
                                               name: .newPokemonFetched,
                                               object: nil)
    }
    
    @objc
    private func backgroundFetchPokemon(sender: Notification) {
        let info = sender.userInfo
        guard let pokemon = info?["pokemon"] as? Pokemon else { return }
        
        updateWithPokemon(pokemon)
    }
    
    private func fetchPokemon(id: Int) {
        PokeService.shared.pokemon(id: id) { [weak self] pokemon in
            self?.updateWithPokemon(pokemon)
        }
    }
    
    private func updateWithPokemon(_ pokemon: Pokemon) {
        if let name = pokemon.species?.name {
            label.text = name
        }
        
        if let url = pokemon.sprites?.frontDefault {
            ImageService.shared.downloadImage(url: url) { [weak self] image in
                self?.imageView.image = image
                if let imageURL = image.url {
                    self?.localNotificationsService.scheduleNotification(pokemon: pokemon, urlImage: imageURL)
                }
            }
        }
    }
    
}
