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

enum ItemType: String, CaseIterable {
    case passive = "passive"
    case consumable = "consumable"
    case equippable = "equippable"
}

struct Item {
    
    var ref: DatabaseReference?
    var itemID: String
    var creatorID: String
    var itemName: String
    var itemDescription: String
    var impactsWhat: String
    var impact: Int
    var type: String
    
    init (itemID: String, creatorID: String, itemName: String, itemDescription: String, impactsWhat: String, impact: Int, type: String) {
        self.ref = nil
        self.itemID = itemID
        self.creatorID = creatorID
        self.itemName = itemName
        self.itemDescription = itemDescription
        self.impactsWhat = impactsWhat
        self.impact = impact
        self.type = type
    }
    
    init? (snapshot: DataSnapshot) {
     
        guard
            let value = snapshot.value as? [String: Any],
            let itemID = value["itemID"] as? String,
            let creatorID = value["creatorID"] as? String,
            let itemName = value["itemName"] as? String,
            let itemDescription = value["itemDescription"] as? String,
            let impactsWhat = value["impactsWhat"] as? String,
            let impact = value["impact"] as? Int,
            let type = value["type"] as? String
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
        self.type = type
    }
    
    func toAnyObject () -> Dictionary<String, Any> {
        return [
            "itemID": self.itemID,
            "creatorID": self.creatorID,
            "itemName": self.itemName,
            "itemDescription": self.itemDescription,
            "impactsWhat": self.impactsWhat,
            "impact": self.impact,
            "type": self.type
        ]
    }
    
}
