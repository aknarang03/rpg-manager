//
//  Fight.swift
//  RPG Manager
//
//  Created by Anjali Narang  on 11/25/24.
//


import Foundation
import Firebase
import FirebaseDatabase

struct Fight {
    
    var ref: DatabaseReference?
    var fightID: String
    var userID: String
    var character1ID: String
    var character2ID: String
    var outcomes: [String]?
    var winner: String?
    
    init (fightID: String, userID: String, character1ID: String, character2ID: String, outcomes: [String]? = nil, winner: String) {
        self.ref = nil
        self.fightID = fightID
        self.userID = userID
        self.character1ID = character1ID
        self.character2ID = character2ID
        self.outcomes = outcomes
        self.winner = winner
    }
    
    init? (snapshot: DataSnapshot) {
     
        guard
            let value = snapshot.value as? [String: Any],
            let fightID = value["fightID"] as? String,
            let userID = value["userID"] as? String,
            let character1ID = value["character1ID"] as? String,
            let character2ID = value["character2ID"] as? String
        else {
            return nil
        }
        
        let outcomes = value["outcomes"] as? [String] ?? []
        let winner = value["winner"] as? String
        
        self.ref = snapshot.ref
        self.fightID = fightID
        self.userID = userID
        self.character1ID = character1ID
        self.character2ID = character2ID
        self.outcomes = outcomes
        self.winner = winner
    }
    
    func toAnyObject () -> Dictionary<String, Any> {
        
        var dict: [String: Any] = [
            "fightID": self.fightID,
            "userID": self.userID,
            "character1ID": self.character1ID,
            "character2ID": self.character2ID
        ]
                
        // only add bag if it's not nil
        if let outcomes = self.outcomes {
            dict["outcomes"] = outcomes
        }
        if let winner = self.winner {
            dict["winner"] = winner
        }
        
        return dict
        
    }
    
}
