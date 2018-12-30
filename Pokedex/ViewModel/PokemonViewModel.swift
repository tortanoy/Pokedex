//
//  PokedexViewModel.swift
//  Pokedex
//
//  Created by Stephen Dowless on 12/28/18.
//  Copyright © 2018 Stephan Dowless. All rights reserved.
//

import Foundation
import UIKit

struct PokemonViewModel {
    
    var name: String!
    var image: UIImage!
    var originalPokemonLabel: String?
    var baseExperienceLabel: String?
    var pokemon: Pokemon!
    var id: Int!
    var weight: Int!
    var height: Int!
    var type: String!
    var description: String!
    
    init(pokemon: Pokemon) {
        self.name = pokemon.name
        self.pokemon = pokemon
        self.id = pokemon.id
        self.weight = pokemon.weight
        self.height = pokemon.height
        self.type = pokemon.type
        
        if let image = pokemon.image {
            self.image = image
        }
        
        if let baseExperience = pokemon.baseExperience {
            if baseExperience <= 100 {
                baseExperienceLabel = "Strenght: Low"
            } else if baseExperience <= 150 {
                baseExperienceLabel = "Strength: Medium"
            } else {
                baseExperienceLabel = "Strength: High"
            }
        }
        
        if pokemon.id < 151 {
            originalPokemonLabel = "\(pokemon.name.capitalized) is an original Pokemon"
        } else {
            originalPokemonLabel = "\(pokemon.name.capitalized) is not an original Pokemon"
        }
    }
    
    func presentInfoView(inController controller: PokedexController) {
        controller.configureSearchBar(shouldShow: false)
        
        guard let view = controller.view else { return }
        let infoView = controller.infoView
        let effectView = controller.visualEffectView
        
        Service.shared.fetchPokemonData(forPokemon: pokemon) {
            view.addSubview(infoView)
            infoView.pokemonViewModel = PokemonViewModel(pokemon: self.pokemon)
            infoView.delegate = controller
            infoView.translatesAutoresizingMaskIntoConstraints = false
            infoView.centerXAnchor.constraint(equalTo: controller.view.centerXAnchor).isActive = true
            infoView.centerYAnchor.constraint(equalTo: controller.view.centerYAnchor, constant: -44).isActive = true
            infoView.heightAnchor.constraint(equalToConstant: 500).isActive = true
            infoView.widthAnchor.constraint(equalToConstant: controller.view.frame.width - 64).isActive = true
            
            infoView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            infoView.alpha = 0
            
            UIView.animate(withDuration: 0.5) {
                effectView.alpha = 1
                infoView.alpha = 1
                infoView.transform = CGAffineTransform.identity
            }
        }
    }
}
