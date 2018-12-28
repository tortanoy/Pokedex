//
//  InfoView.swift
//  Pokedex
//
//  Created by Stephen Dowless on 12/28/18.
//  Copyright © 2018 Stephan Dowless. All rights reserved.
//

import UIKit

private let reuseIdentifier = "PokemonStatCell"

class InfoView: UIView {
    
    // MARK: - Properties
    
    var pokemon: Pokemon? {
        didSet {
            guard let pokemon = self.pokemon else { return }
            guard let baseExperience = pokemon.baseExperience else { return }
            nameLabel.text = pokemon.name.capitalized
            imageView.image = pokemon.image
            self.tableView.reloadData()        
            
            if pokemon.id < 151 {
                originalPokemonLabel.text = "Original Pokemon: Yes"
            } else {
                originalPokemonLabel.text = "Original Pokemon: No"
            }
            
            if baseExperience <= 100 {
                baseExperienceLabel.text = "Strength: Low"
            } else if baseExperience <= 150 {
                baseExperienceLabel.text = "Strength: Medium"
            } else {
                baseExperienceLabel.text = "Strength: High"
            }
        }
    }
    
    var delegate: PokedexCellDelegate?
    var tableView: UITableView!
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    lazy var nameContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .mainPink()
        view.addSubview(nameLabel)
        view.layer.cornerRadius = 5
        nameLabel.center(inView: view)
        return view
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    let originalPokemonLabel: UILabel = {
        let label = UILabel()
        label.textColor = .mainPink()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .center
        return label
    }()
    
    let baseExperienceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .mainPink()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .center
        return label
    }()
    
    let infoButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .mainPink()
        button.setTitle("View More Info", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(handleViewMoreInfo), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5
        return button
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureViewComponents()
    }
    
    // MARK: - Selectors
    
    @objc func handleViewMoreInfo() {
        guard let pokemon = self.pokemon else { return }
        delegate?.viewMoreInfo(forPokemon: pokemon)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helper Functions
    
    func configureViewComponents() {
        backgroundColor = .white
        
        self.layer.masksToBounds = true
        
        addSubview(nameContainerView)
        nameContainerView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        
        addSubview(imageView)
        imageView.anchor(top: nameContainerView.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 24, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 100, height: 60)
        imageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        configureTableView()
        
        addSubview(originalPokemonLabel)
        originalPokemonLabel.anchor(top: tableView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 20, paddingLeft: 16, paddingBottom: 0, paddingRight: 16, width: 0, height: 0)
        
        addSubview(baseExperienceLabel)
        baseExperienceLabel.anchor(top: originalPokemonLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 4, paddingLeft: 16, paddingBottom: 0, paddingRight: 16, width: 0, height: 0)
        
        addSubview(infoButton)
        infoButton.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 12, paddingBottom: 12, paddingRight: 12, width: 0, height: 50)
    }
}

extension InfoView: UITableViewDelegate, UITableViewDataSource {
    
    func configureTableView() {
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 50
        tableView.separatorColor = .mainPink()
        tableView.isScrollEnabled = false
        
        tableView.register(PokemonStatCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        addSubview(tableView)
        tableView.anchor(top: imageView.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 16, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 200, height: 200)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PokemonStats.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! PokemonStatCell
        cell.pokemon = self.pokemon
        cell.titleLabel.text = PokemonStats(rawValue: indexPath.row)?.description
        cell.configureCell(withIndex: indexPath.row)
        return cell
    }
}
