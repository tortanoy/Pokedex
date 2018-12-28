//
//  PokedexCell.swift
//  Pokedex
//
//  Created by Stephen Dowless on 12/26/18.
//  Copyright © 2018 Stephan Dowless. All rights reserved.
//

import UIKit

class PokedexCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    var delegate: PokedexCellDelegate?
    
//    var pokemon: Pokemon? {
//        didSet {
//            guard let pokemon = pokemon else { return }
//            nameLabel.text = pokemon.name.capitalized
//            imageView.image = pokemon.image
//        }
//    }
    
    var pokemonViewModel: PokemonViewModel? {
        didSet {
            guard let pokemonViewModel = pokemonViewModel else { return }
            nameLabel.text = pokemonViewModel.name.capitalized
            imageView.image = pokemonViewModel.image
        }
    }
    
    lazy var nameContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .mainPink()
        view.addSubview(nameLabel)
        nameLabel.center(inView: view)
        return view
    }()
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = UIColor.groupTableViewBackground
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.clipsToBounds = true
        self.layer.cornerRadius = 10
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        self.addGestureRecognizer(longPressGesture)
        
        addSubview(imageView)
        imageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: self.frame.height - 32)
        
        
        addSubview(nameContainerView)
        nameContainerView.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 32)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    
    @objc func handleLongPress(sender: UILongPressGestureRecognizer) {
        guard let pokemonViewModel = self.pokemonViewModel else { return }
        if sender.state == .began {
            delegate?.presentInfoView(withPokemonViewModel: pokemonViewModel)
        }
    }
}
