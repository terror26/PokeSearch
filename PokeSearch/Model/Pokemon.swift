//
//  File.swift
//  Pokedex3
//
//  Created by Kanishk Verma on 05/08/17.
//  Copyright © 2017 Kanishk Verma. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon {
    private var _name: String!
    private var _pokemonId: Int!
    private var _description:String!
    private var _type:String!
    private var _defense:String!
    private var _height:String!
    private var _weight:String!
    private var _attack:String!
    private var _nextEvolutionTxt:String!
    private var _pokemonUrl:String!
    private var _nextEvolutionName:String!
    private var _nextEvolLevel:String!
    private var _nextEvoId:String!
    
    
    
    var nextevolutionname:String {
        if _nextEvolutionName == nil {
            _nextEvolutionName = ""
        }
        return _nextEvolutionName
    }
    
    var nextEvoId:String {
        
        if _nextEvoId == nil {
            _nextEvoId = ""
        }
        return _nextEvoId
    }
    
    var nextEvolutionLevel:String {
        if _nextEvolLevel == nil {
            _nextEvolLevel = ""
        }
        return _nextEvolLevel
    }
    
    var type:String {
        if _type == nil {
            _type = ""
        }
        return _type
    }
    
    var description:String {
        if _description == nil {
            _description = ""
        }
        return _description
    }
    
    var height:String {
        if _height == nil {
            _height = "0"
        }
        return _height
    }
    
    var weight:String {
        if _weight == nil {
            _weight = "01"
        }
        return _weight
    }
    
    var defense : String {
        if _defense == nil {
            _defense = "001"
        }
        return _defense
    }
    var nextevolutionTxt :String {
        if _nextEvolutionTxt == nil {
            _nextEvolutionTxt = ""
        }
        return _nextEvolutionTxt
    }
    var attack:String {
        if _attack == nil {
            _attack = "0001"
        }
        return  _attack
    }
    
    
    
    var name : String {
        return _name
    }
    var pokemonId: Int {
        return _pokemonId
    }
    
    
    init(name:String, pokemonId:Int ) {
        self._name = name
        self._pokemonId = pokemonId
        self._pokemonUrl = "\(Url_Base)\(Url_Pokemon)\(self.pokemonId)/"
    }
    
    func downloadPokemonDetails(complete: @escaping DownloadComplete) {
        Alamofire.request(_pokemonUrl).responseJSON {
            (response) in
            if let dict = response.result.value as?Dictionary<String,AnyObject> {
                if let attack = dict["attack"] as?Int {
                    self._attack = "\(attack)"
                }
                if let defense = dict["defense"] as?Int {
                    self._defense = "\(defense)"
                }
                if let weight = dict["weight"] as?String {
                    self._weight = weight
                }
                if let height = dict["height"] as?String {
                    self._height = height
                }
                if let types = dict["types"] as?[Dictionary<String,AnyObject>], types.count>0 {
                 
                    if let name = types[0]["name"] as?String {
                        self._type = name
                    }
                    if types.count>1 {
                        for x in 1..<(types.count) {
                            if let name = types[x]["name"] {
                                self._type! += "/\(name)"
                            }
                        }
                    }
                }
                
                if let description = dict["descriptions"] as?[Dictionary<String,AnyObject>] ,description.count > 0 {
                    
                    if let urlbase = description[0]["resource_uri"] {
                        let descriptionurl = "\(Url_Base)\(urlbase)"
                        Alamofire.request(descriptionurl).responseJSON(completionHandler:
                            {
                                response in
                                if let descriptionss = response.result.value as?Dictionary<String,AnyObject> {
                                    if let realDescription = descriptionss["description"] as?String {
                                        self._description = realDescription
                                        print(realDescription)
                                        print("///////////////////////")
                                    }
                                }
                        complete()        
                        })
                        
                    }
                }
                
                if let nextEvo1 = dict["evolutions"] as?[Dictionary<String,AnyObject>] ,nextEvo1.count > 0 {
                 
                    if let nextEvo2 = nextEvo1[0]["to"] as?String {
                        
                        if nextEvo2.range(of: "mega") == nil {
                           
                            self._nextEvolutionName = nextEvo2
                            
                            if let urlOld = nextEvo1[0]["resource_uri"] as?String {
                              
                                var urlnew = urlOld.replacingOccurrences(of: "/api/v1/pokemon/", with: "")
                                
                                urlnew = urlnew.replacingOccurrences(of: "/", with: "")
                                
                                self._nextEvoId = urlnew
                                
                                if let nextEvolevel = nextEvo1[0]["level"] as?Int {
                                    
                                    self._nextEvolLevel =  "\(nextEvolevel)"
                                    
                                } else {
                                    self._nextEvolLevel = ""
                                }
                            }
                            
                            
                        }
                        else {
                            self._nextEvolutionName = ""
                        }
                        
                    
                }
                    print(self._nextEvolLevel)
                    print(self._nextEvoId)
                    print(self._nextEvolutionName)
            }
        }
            
                
                
            complete()
           
        }
        
    }
    
    
    
    
    
    
    
}
