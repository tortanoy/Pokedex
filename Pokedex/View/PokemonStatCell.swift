//
//  PokemonStatCell.swift
//  Pokedex
//
//  Created by Stephen Dowless on 12/27/18.
//  Copyright © 2018 Stephan Dowless. All rights reserved.
//

import UIKit

class PokemonStatCell: UITableViewCell {
    
    // MARK: - Properties
    
    var pokemonViewModel: PokemonViewModel!
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .mainPink()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    var statLabel: UILabel = {
        let label = UILabel()
        label.textColor = .mainPink()
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "Test"
        return label
    }()
    
    // MARK - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        addSubview(titleLabel)
        titleLabel.anchor(top: nil, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 10).isActive = true
        
        addSubview(statLabel)
        statLabel.anchor(top: nil, left: titleLabel.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 4, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        statLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 10).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    func configureCell(withIndex index: Int) {
        
        guard let pokemonStat = PokemonStats(rawValue: index) else { return }
        guard let id = pokemonViewModel.id else { return }
        guard let height = pokemonViewModel.height else { return }
        guard let weight = pokemonViewModel.weight else { return }
        
        switch pokemonStat {
        case .PokemonType: statLabel.text = pokemonViewModel.type.capitalized
        case .PokedexId: statLabel.text = "\(id)"
        case .Height: statLabel.text = "\(height)"
        case .Weight: statLabel.text = "\(weight)"
        }
    }
}
