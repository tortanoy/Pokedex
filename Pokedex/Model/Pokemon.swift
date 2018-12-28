//
//  Pokemon.swift
//  Pokedex
//
//  Created by Stephen Dowless on 12/26/18.
//  Copyright © 2018 Stephan Dowless. All rights reserved.
//

import Foundation
import UIKit

enum PokemonStats: Int, CaseIterable {
    
    case PokemonType
    case PokedexId
    case Height
    case Weight
    
    var description: String {
        switch self {
        case .PokemonType: return "Type: "
        case .PokedexId: return "Pokedex ID: "
        case .Height: return "Height: "
        case .Weight: return "Weight: "
        }
    }
}

class Pokemon {
    
    var name: String!
    var imageUrl: String!
    var image: UIImage?
    var infoUrl: String?
    var id: Int!
    
    var weight: Int?
    var height: Int?
    var defense: String?
    var description: String?
    var type: String?
    var statDictionary: [String: String]?
    var showFullInfo = false
    
    init(id: Int, name: String, image: UIImage) {
        self.id = id
        self.image = image 
        self.name = name
        self.infoUrl = BASE_URL + "\(id)/"
    }
    
    func configurePokemonData(withDescription description: String, dictionary: [String: AnyObject]) {
        self.description = description
        
        if let weight = dictionary["weight"] as? Int {
            self.weight = weight
        }
        
        if let height = dictionary["height"] as? Int {
            self.height = height
        }
        
        if let types = dictionary["types"] as? [Dictionary<String, AnyObject>], types.count > 0 {
            guard let typeDictionary = types[0]["type"] else { return }
            guard let type = typeDictionary["name"] as? String else { return }
            self.type = type
        }
    }
}
