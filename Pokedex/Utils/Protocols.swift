//
//  Protocols.swift
//  Pokedex
//
//  Created by Stephen Dowless on 12/28/18.
//  Copyright © 2018 Stephan Dowless. All rights reserved.
//

import Foundation

protocol PokedexCellDelegate {
    func presentInfoView(withPokemon pokemon: Pokemon)
    func viewMoreInfo(forPokemon pokemon: Pokemon)
}
