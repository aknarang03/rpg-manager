//
//  Character.swift
//  RPG Manager
//
//  Created by Anjali Narang  on 11/18/24.
//

import Foundation
import Firebase
import FirebaseDatabase

struct Character {
    
    var ref: DatabaseReference?
    var characterID: String
    var creatorID: String
    var characterName: String
    var characterDescription: String
    var stats: Stats
    var bag: [String: Int]? // id : quantity
    var isPlayer: Bool
    var heldItem: String?
    
    init (characterID: String, creatorID: String, characterName: String, characterDescription: String, stats: Stats, bag: [String: Int]? = nil, isPlayer: Bool, heldItem: String) {
        self.ref = nil
        self.characterID = characterID
        self.creatorID = creatorID
        self.characterName = characterName
        self.characterDescription = characterDescription
        self.stats = stats
        self.bag = bag
        self.isPlayer = isPlayer
        self.heldItem = heldItem
    }
    
    init? (snapshot: DataSnapshot) {
     
        guard
            let value = snapshot.value as? [String: Any],
            let characterID = value["characterID"] as? String,
            let creatorID = value["creatorID"] as? String,
            let characterName = value["characterName"] as? String,
            let characterDescription = value["characterDescription"] as? String,
            let statsDict = value["stats"] as? [String: Int],
            let health = statsDict["health"],
            let attack = statsDict["attack"],
            let defense = statsDict["defense"],
            let speed = statsDict["speed"],
            let agility = statsDict["agility"],
            let hp = statsDict["hp"],
            let isPlayer = value["isPlayer"] as? Bool
        else {
            return nil
        }
        
        let bag = value["bag"] as? [String: Int] ?? [:]
        let heldItem = value["heldItem"] as? String
        
        self.ref = snapshot.ref
        self.characterID = characterID
        self.creatorID = creatorID
        self.characterName = characterName
        self.characterDescription = characterDescription
        self.stats = Stats(health: health, attack: attack, defense: defense, speed: speed, agility: agility, hp: hp)
        self.bag = bag
        self.isPlayer = isPlayer
        self.heldItem = heldItem
    }
    
    func toAnyObject () -> Dictionary<String, Any> {
        
        var dict: [String: Any] = [
    
            "characterID": self.characterID,
            "creatorID": self.creatorID,
            "characterName": self.characterName,
            "characterDescription": self.characterDescription,
            "stats": [
                "health": self.stats.health,
                "attack": self.stats.attack,
                "defense": self.stats.defense,
                "speed": self.stats.speed,
                "agility": self.stats.agility,
                "hp": self.stats.hp
            ],
            "isPlayer": self.isPlayer
        ]
                
        // only add bag if it's not nil
        if let bag = self.bag {
            dict["bag"] = bag
        }
        if let heldItem = self.heldItem {
            dict["heldItem"] = heldItem
        }
        
        return dict
        
    }
    
}

struct Stats {
    var health: Int
    var attack: Int
    var defense: Int
    var speed: Int
    var agility: Int
    var hp: Int
}
