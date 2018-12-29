//
//  PokemonViewModel.swift
//  Pokedex
//
//  Created by Stephen Dowless on 12/29/18.
//  Copyright © 2018 Stephan Dowless. All rights reserved.
//

import UIKit

struct PokemonViewModel {
    
    var name: String!
    var image: UIImage!
    
    var originalPokemonText: String!
    var baseExperienceText: String!
    var pokemon: Pokemon!
    
    init(pokemon: Pokemon) {
        
        self.name = pokemon.name
        self.pokemon = pokemon
        guard let image = pokemon.image else { return }
        self.image = image
        guard let baseExperience = pokemon.baseExperience else { return }
        
        if pokemon.id < 151 {
            originalPokemonText = "Original Pokemon: Yes"
        } else {
            originalPokemonText = "Original Pokemon: No"
        }
        
        if baseExperience <= 100 {
            baseExperienceText = "Strength: Low"
        } else if baseExperience <= 150 {
            baseExperienceText = "Strength: Medium"
        } else {
            baseExperienceText = "Strength: High"
        }
        
    }
}
