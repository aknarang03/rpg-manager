//
//  Fight.swift
//  RPG Manager
//
//  Created by Anjali Narang  on 11/25/24.
//


import Foundation
import Firebase
import FirebaseDatabase

enum OutcomeType: String, CaseIterable {
    
    // attacker actions
    case attackerAttack = "attack" // {attacker} attacks {defender} for {damage} damage.
    case attackerUsesItem = "uses item" // {attacker} uses {consumable item name} for {+ or -}{imapct amt} {impact}.
    case attackerPass = "pass" // {attacker} idles.
    case attackerLose = "attacker lose" // {attacker} loses.
    case attackerFlee = "attacker flee" // {attacker} flees.
    
    // defender actions
    case defenderAvoid = "avoid" // {defender} avoids attack.
    case defenderGetHit = "get hit" // {defender} is hit. Loses {damage} HP.
    case defenderIdle = "idle" // {defender} idles. (THIS IS WHEN ATTACKER DOESNT DO SOMETHING THAT IMPACTS DEFENDER)
    case defenderLose = "defender lose" // {defender} loses.
    case defenderFlee = "defender flee" // {defender} flees.
    
}

struct Fight {
    
    var ref: DatabaseReference?
    var fightID: String
    var userID: String
    var character1ID: String
    var character2ID: String
    var outcomes: [String]? // each round consists of two outcomes
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
