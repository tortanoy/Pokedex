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
            if baseExperience < 100 {
                baseExperienceLabel = "Strenght: Low"
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
}
