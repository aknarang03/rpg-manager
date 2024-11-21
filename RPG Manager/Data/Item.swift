//
//  Item.swift
//  RPG Manager
//
//  Created by Anjali Narang  on 11/20/24.
//

import Foundation
import Firebase
import FirebaseDatabase

enum ImpactsWhat: String, CaseIterable {
    case health = "health"
    case attack = "attack"
    case defense = "defense"
    case speed = "speed"
    case agility = "agility"
    case hp = "hp"
    case none = "none"
}

struct Item {
    
    var ref: DatabaseReference?
    var itemID: String
    var creatorID: String
    var itemName: String
    var itemDescription: String
    var impactsWhat: String
    var impact: Int
    
    init (itemID: String, creatorID: String, itemName: String, itemDescription: String, impactsWhat: String, impact: Int) {
        self.ref = nil
        self.itemID = itemID
        self.creatorID = creatorID
        self.itemName = itemName
        self.itemDescription = itemDescription
        self.impactsWhat = impactsWhat
        self.impact = impact
    }
    
    init? (snapshot: DataSnapshot) {
     
        guard
            let value = snapshot.value as? [String: Any],
            let itemID = value["itemID"] as? String,
            let creatorID = value["creatorID"] as? String,
            let itemName = value["itemName"] as? String,
            let itemDescription = value["itemDescription"] as? String,
            let impactsWhat = value["impactsWhat"] as? String,
            let impact = value["impact"] as? Int
        else {
            return nil
        }
        
        self.ref = snapshot.ref
        self.itemID = itemID
        self.creatorID = creatorID
        self.itemName = itemName
        self.itemDescription = itemDescription
        self.impactsWhat = impactsWhat
        self.impact = impact
    }
    
    func toAnyObject () -> Dictionary<String, Any> {
        return [
            "itemID": self.itemID,
            "creatorID": self.creatorID,
            "itemName": self.itemName,
            "itemDescription": self.itemDescription,
            "impactsWhat": self.impactsWhat,
            "impact": self.impact
        ]
    }
    
}
