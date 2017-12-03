//
//  ViewController.swift
//  Pokedex3
//
//  Created by Kanishk Verma on 04/08/17.
//  Copyright © 2017 Kanishk Verma. All rights reserved.
//

import UIKit
import AVFoundation

protocol MyProtocol {
    func setResultOfPokeSelection(valueSent: Int)
}

class PokeCollection: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,UISearchBarDelegate {
    
    
    @IBOutlet weak var collection :UICollectionView!
    @IBOutlet weak var SearchBar: UISearchBar!
    
    var insearchmode = false
    var pokemon = [Pokemon]()
    var delegate:MyProtocol?
    var filteredPokemon = [Pokemon]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collection.dataSource = self
        collection.delegate = self
        SearchBar.delegate = self
        
        SearchBar.returnKeyType = UIReturnKeyType.done
        parsePokemonCSv()
        
    }
    
    func parsePokemonCSv() {
        let path = Bundle.main.path(forResource: "pokemon", ofType: "csv")
        do {
            let csv = try CSV(contentsOfURL: path!)
            let rows = csv.rows
            print(rows)
            for row in rows {
                
                let name = row["identifier"]!
                let pokeId = Int(row["id"]!)!
                let poke = Pokemon(name: name, pokemonId: pokeId)
                pokemon.append(poke)
            }
            
        } catch _ as NSError {
            print(NSError.description())
        }
    }
    
    
    // perform the segue but not here
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var poke: Pokemon!
        if insearchmode {
            poke = filteredPokemon[indexPath.row]
        } else {
            poke = pokemon[indexPath.row]
        }
        print("RamRam ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++RamRam")
        print(poke.name)
        delegate?.setResultOfPokeSelection(valueSent: indexPath.row)
        dismiss(animated: true, completion: nil)
    }
    
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if insearchmode {
            return filteredPokemon.count
        } else {
            return pokemon.count
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath:IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PokeCell", for: indexPath) as?PokeCell {
            
            let poke:Pokemon!
            
            if insearchmode {
                poke = filteredPokemon[indexPath.row]
                cell.ConfigureCell(poke)
            } else {
                poke = pokemon[indexPath.row]
                cell.ConfigureCell(poke)
            }
            return cell
            
        }
        else {
            return UICollectionViewCell()
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 108, height: 108)
    }
    
    
   
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            insearchmode = false
            collection.reloadData()
            view.endEditing(true)
        } else {
            insearchmode = true
            let lower = searchBar.text!.lowercased()
            filteredPokemon = pokemon.filter( { $0.name.range(of: lower) != nil })
            collection.reloadData()
        }
    }
    
    
}

