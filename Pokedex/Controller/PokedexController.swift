//
//  PokedexController.swift
//  Pokedex
//
//  Created by Stephen Dowless on 12/26/18.
//  Copyright © 2018 Stephan Dowless. All rights reserved.
//

import UIKit

private let reuseIdentifer = "Cell"

class PokedexController: UICollectionViewController {
    
    // MARK: - Properties
    
    var searchBar: UISearchBar!
    var pokemonViewModels = [PokemonViewModel]()
    var filteredPokemonViewModels = [PokemonViewModel]()
    var inSearchMode = false
    
    lazy var infoView: InfoView = {
        let view = InfoView()
        view.layer.cornerRadius = 5
        return view
    }()
    
    let visualEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let view = UIVisualEffectView(effect: blurEffect)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewComponents()
        fetchPokemon()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        inSearchMode = false
        collectionView.reloadData()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Selectors
    
    @objc func handleSearch() {
        configureSearchBar(shouldShow: true)
    }
    
    @objc func handleDismissal() {
        dismissInfoView(withViewModel: nil)
    }
    
    // MARK: - Helper Functions
    
    func dismissInfoView(withViewModel pokemonViewModel: PokemonViewModel?) {
        UIView.animate(withDuration: 0.5, animations: {
            self.visualEffectView.alpha = 0
            self.infoView.alpha = 0
            self.infoView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        }) { (_) in
            self.infoView.removeFromSuperview()
            guard let pokemonViewModel = pokemonViewModel else { return }
            let controller = PokemonInfoController()
            controller.pokemonViewModel = pokemonViewModel
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func configureSearchBar(shouldShow: Bool) {
        inSearchMode = shouldShow
        
        if shouldShow {
            searchBar = UISearchBar()
            searchBar.delegate = self
            searchBar.sizeToFit()
            searchBar.showsCancelButton = true
            searchBar.becomeFirstResponder()
            searchBar.tintColor = .white
            
            navigationItem.rightBarButtonItem = nil
            navigationItem.titleView = searchBar
        } else {
            navigationItem.titleView = nil
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(handleSearch))
            navigationItem.rightBarButtonItem?.tintColor = .white
        }
    }
    
    func configureViewComponents() {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleDismissal))
        visualEffectView.addGestureRecognizer(gestureRecognizer)
        
        navigationItem.title = "Pokedex"
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barStyle = .black
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(handleSearch))
        navigationItem.rightBarButtonItem?.tintColor = .white
        
        collectionView.addSubview(visualEffectView)
        visualEffectView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        visualEffectView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        visualEffectView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        visualEffectView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        visualEffectView.alpha = 0
        
        collectionView.register(PokedexCell.self, forCellWithReuseIdentifier: reuseIdentifer)
        collectionView.backgroundColor = .white
    }
    
    // MARK: - API
    
    func fetchPokemon() {
        Service.shared.fetchPokemon { (pokemon) in
            self.pokemonViewModels = pokemon.map({ return PokemonViewModel(pokemon: $0)})
            self.collectionView.reloadData()
        }
    }
}

// MARK: - UICollectionViewDelegate/DataSource

extension PokedexController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return inSearchMode ? filteredPokemonViewModels.count : pokemonViewModels.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifer, for: indexPath) as! PokedexCell
        cell.delegate = self
        cell.pokemonViewModel = inSearchMode ? filteredPokemonViewModels [indexPath.item] : pokemonViewModels[indexPath.item]
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = PokemonInfoController()
        
        guard  let pokemon = inSearchMode ? filteredPokemonViewModels [indexPath.item].pokemon: pokemonViewModels[indexPath.item].pokemon else { return }
        
        Service.shared.fetchPokemonData(forPokemon: pokemon) {
            controller.pokemonViewModel = PokemonViewModel(pokemon: pokemon)
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}

// MARK: - UICollectionViewFlowLayout

extension PokedexController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 32, left: 8, bottom: 0, right: 8)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (view.frame.width - 36) / 3
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
}

// MARK: - UISearchBarDelegate

extension PokedexController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        configureSearchBar(shouldShow: false)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let searchText = searchText.lowercased()
        
        if searchText == "" || searchBar.text == nil {
            inSearchMode = false
            collectionView.reloadData()
            view.endEditing(true)
        } else {
            inSearchMode = true
            filteredPokemonViewModels = pokemonViewModels.filter({ $0.name.range(of: searchText) != nil })
            collectionView.reloadData()
        }
    }
}

extension PokedexController: PokedexCellDelegate {
    
    func presentInfoView(withPokemonViewModel pokemonViewModel: PokemonViewModel) {
//        configureSearchBar(shouldShow: false)
//
//        Service.shared.fetchPokemonData(forPokemon: pokemonViewModel.pokemon) {
//            self.view.addSubview(self.infoView)
//            self.infoView.pokemonViewModel = PokemonViewModel(pokemon: pokemonViewModel.pokemon)
//            self.infoView.delegate = self
//            self.infoView.translatesAutoresizingMaskIntoConstraints = false
//            self.infoView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
//            self.infoView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -44).isActive = true
//            self.infoView.heightAnchor.constraint(equalToConstant: 500).isActive = true
//            self.infoView.widthAnchor.constraint(equalToConstant: self.view.frame.width - 64).isActive = true
//
//            self.infoView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
//            self.infoView.alpha = 0
//
//            UIView.animate(withDuration: 0.5) {
//                self.visualEffectView.alpha = 1
//                self.infoView.alpha = 1
//                self.infoView.transform = CGAffineTransform.identity
//            }
//        }
        
        pokemonViewModel.presentInfoView(inController: self)
    }
    
    func viewMoreInfo(withViewModel pokemonViewModel: PokemonViewModel?) {
        self.dismissInfoView(withViewModel: pokemonViewModel)
    }
}

