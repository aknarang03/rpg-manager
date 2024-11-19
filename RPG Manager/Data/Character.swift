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
    var characterID: String
    var creatorID: String
    var characterName: String
    var stats: Stats
}


struct Stats {
    var attack: Int
    var defense: Int
    var speed: Int
    var agility: Int
    
//    func toAnyObject() -> [String: Any] {
//        return [
//            "attack": attack,
//            "defense": defense,
//            "speed": speed,
//            "agility": agility
//        ]
//    }
}

//struct Character {
//    
//    /*
//     ATTRIBUTES TO ADD LATER:
//    */
//    
//    var ref: DatabaseReference?
//    var characterID: String
//    var creatorID: String
//    var characterName: String
//    var stats: Stats
//        
//    init (characterID: String, creatorID: String, characterName: String, stats: Stats) {
//        self.ref = nil
//        self.characterID = characterID
//        self.creatorID = creatorID
//        self.characterName = characterName
//        self.stats = stats
//    }
//    
//    init? (snapshot: DataSnapshot) {
//     
//        guard
//            let value = snapshot.value as? [String: Any],
//            let characterID = value["characterID"] as? String,
//            let creatorID = value["creatorID"] as? String,
//            let characterName = value["characterName"] as? String,
//            let stats = value["stats"] as? Stats
//        else {
//            return nil
//        }
//        
//        self.ref = snapshot.ref
//        self.characterID = characterID
//        self.creatorID = creatorID
//        self.characterName = characterName
//        self.stats = stats
//        
//    }
//    
//    func toAnyObject () -> Dictionary<String, Any> {
//        return [
//            "characterID": self.characterID,
//            "creatorID": self.creatorID,
//            "characterName": self.characterName,
//            "stats": self.stats
//        ]
//    }
//    
//}
