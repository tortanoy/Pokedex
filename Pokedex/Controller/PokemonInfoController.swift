//
//  PokemonInfoController.swift
//  Pokedex
//
//  Created by Stephen Dowless on 12/26/18.
//  Copyright © 2018 Stephan Dowless. All rights reserved.
//

import UIKit

private let reuseIdentifier = "PokemonStatCell"

class PokemonInfoController: UIViewController {
    
    // MARK: - Properties
    
    var pokemonViewModel: PokemonViewModel?
    var tableView: UITableView!
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    let infoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewComponents()
        fetchPokemonData()
    }
    
    // MARK: - Selectors
    
    // MARK: - Helper Functions
    
    func configureViewComponents() {
        view.backgroundColor = .white
        navigationController?.navigationBar.tintColor = .white
        
        view.addSubview(imageView)
        imageView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 44, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 100, height: 100)
        
        view.addSubview(infoLabel)
        infoLabel.anchor(top: nil, left: imageView.rightAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 44, paddingLeft: 16, paddingBottom: 0, paddingRight: 4, width: 0, height: 0)
        infoLabel.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
    }
    
    // MARK: - API
    
    func fetchPokemonData() {
        guard let pokemonViewModel = self.pokemonViewModel else { return }
        navigationItem.title = pokemonViewModel.name.capitalized
        imageView.image = pokemonViewModel.image
        guard let pokemon = pokemonViewModel.pokemon else { return }
        
        Service.shared.fetchPokemonData(forPokemon: pokemon) {
            self.infoLabel.text = pokemon.description
            self.configureTableView()
        }
    }
}

extension PokemonInfoController: UITableViewDelegate, UITableViewDataSource {
    
    func configureTableView() {
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 50
        tableView.separatorColor = .mainPink()
        tableView.isScrollEnabled = false
        
        tableView.register(PokemonStatCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        view.addSubview(tableView)
        tableView.anchor(top: imageView.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 32, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: view.frame.width - 64, height: 200)
        tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PokemonStats.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! PokemonStatCell
        cell.pokemonViewModel = self.pokemonViewModel
        cell.titleLabel.text = PokemonStats(rawValue: indexPath.row)?.description
        cell.configureCell(withIndex: indexPath.row)
        return cell
    }
}
