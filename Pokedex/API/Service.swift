//
//  Service.swift
//  Pokedex
//
//  Created by Stephen Dowless on 12/26/18.
//  Copyright © 2018 Stephan Dowless. All rights reserved.
//

import Foundation
import UIKit

class Service {
    static let shared = Service()
    
    func fetchPokemon(completion: @escaping([Pokemon]) -> ()) {
        var pokemonArray = [Pokemon]()
        
        fetchResults { (results) in
            for (key, result) in results.enumerated() {
                guard let name = result["name"] as? String else { return }
                let id = key + 1
                let imageUrl = BASE_IMG_URL + "\(id).png"
                
                self.setImage(withUrlString: imageUrl, completion: { (image) in
                    let pokemon = Pokemon(id: id, name: name, image: image)
                    pokemonArray.append(pokemon)
                    pokemonArray.sort(by: { (poke1, poke2) -> Bool in
                        poke1.id < poke2.id
                    })
                    completion(pokemonArray)
                })
            }
        }
    }
    
    func fetchPokemonData(forPokemon pokemon: Pokemon, completion: @escaping() -> ()) {
        guard let infoUrl = pokemon.infoUrl else { return }
        
        self.beginURLSession(with: infoUrl) { (data) in
            do {
                guard let dictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject] else { return }
                
                let descriptionUrlString = DESCRIPTION_URL + "\(pokemon.id ?? 0)/"
                self.fetchDescription(withUrlString: descriptionUrlString, completion: { (description) in
                    
                    DispatchQueue.main.async {
                        pokemon.configurePokemonData(withDescription: description,  dictionary: dictionary)
                        completion()
                    }
                })
            } catch let error {
                print("Failed to fetch data with error: ", error)
            }
        }
    }
    
   private func fetchResults(completion: @escaping([[String: AnyObject]]) -> ()) {
        self.beginURLSession(with: BASE_URL) { (data) in
            do {
                guard let dictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject] else { return }
            
                if let results = dictionary["results"] as? [[String: AnyObject]] {
                let slicedResults = Array(results[0...200])
                completion(slicedResults)
                }
            } catch let error {
                print("Failed to fetch data with error: ", error)
            }
        }
    }
    
    private func setImage(withUrlString urlString: String, completion: @escaping(UIImage) -> ()) {
        self.beginURLSession(with: urlString) { (data) in
            guard let image = UIImage(data: data) else { return }
            
            DispatchQueue.main.async {
                completion(image)
            }
        }
    }
    
    private func fetchDescription(withUrlString urlString: String, completion: @escaping(String) -> ()) {
        self.beginURLSession(with: urlString, completion: { (data) in
            do {
                guard let dictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject] else { return }
                
                if let descriptionArray = dictionary["flavor_text_entries"] as? [Dictionary<String, AnyObject>] {
                    for (key, dictionary) in descriptionArray.enumerated() {
                        if key == 1 {
                            if let description = dictionary["flavor_text"] as? String {
                                completion(description)
                            }
                        }
                    }
                }
            } catch let error {
                print("Failed to fetch data with error: ", error)
            }
        })
    }
    
    private func beginURLSession(with urlString: String, completion: @escaping(Data) -> ()) {
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Failed to fetch pokemon with error: ", error)
                return
            }
            
            guard let data = data else { return }
            completion(data)
        }.resume()
    }
}
