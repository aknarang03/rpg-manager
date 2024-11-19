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
}

//struct Character {
//    
//    /*
//     ATTRIBUTES TO ADD LATER:
//    */
//    
//    var ref: DatabaseReference?
//    var characterID: String
//    var story: String
//    var creator: String
//    var characterName: String
//        
//    init (characterID: String, story: String, creator: String, characterName: String) {
//        self.ref = nil
//        self.characterID = characterID
//        self.story = story
//        self.creator = creator
//        self.characterName = characterName
//    }
//    
//    init? (snapshot: DataSnapshot) {
//     
//        guard
//            let value = snapshot.value as? [String: Any],
//            let characterID = value["characterID"] as? String,
//            let story = value["story"] as? String,
//            let creator = value["creator"] as? String,
//            let characterName = value["characterName"] as? String
//        else {
//            return nil
//        }
//        
//        self.ref = snapshot.ref
//        self.characterID = characterID
//        self.story = story
//        self.creator = creator
//        self.characterName = characterName
//        
//    }
//    
//    func toAnyObject () -> Dictionary<String, Any> {
//        return [
//            "characterID": self.characterID,
//            "story": self.story,
//            "creator": self.creator,
//            "characterName": self.characterName
//        ]
//    }
//    
//}
