//
//  Item.swift
//  RPG Manager
//
//  Created by Anjali Narang  on 11/20/24.
//

import Foundation
import Firebase
import FirebaseDatabase

enum ImpactsWhat: String {
    case attack = "attack"
    case defense = "defense"
    case speed = "speed"
    case agility = "agility"
    case none = "none"
    // add health and HP when those are there
}

struct Item {
    
    var ref: DatabaseReference?
    var creatorID: String
    var itemName: String
    var itemDescription: String
    var impactsWhat: ImpactsWhat
    var impact: Int
    
    init (creatorID: String, itemName: String, itemDescription: String, impactsWhat: ImpactsWhat, impact: Int) {
        self.ref = nil
        self.creatorID = creatorID
        self.itemName = itemName
        self.itemDescription = itemDescription
        self.impactsWhat = impactsWhat
        self.impact = impact
    }
    
    init? (snapshot: DataSnapshot) {
     
        guard
            let value = snapshot.value as? [String: Any],
            let creatorID = value["creatorID"] as? String,
            let itemName = value["itemName"] as? String,
            let itemDescription = value["itemDescription"] as? String,
            let impactsWhat = value["impactsWhat"] as? ImpactsWhat,
            let impact = value["impact"] as? Int
        else {
            return nil
        }
        
        self.ref = snapshot.ref
        self.creatorID = creatorID
        self.itemName = itemName
        self.itemDescription = itemDescription
        self.impactsWhat = impactsWhat
        self.impact = impact
    }
    
    func toAnyObject () -> Dictionary<String, Any> {
        return [
            "creatorID": self.creatorID,
            "itemName": self.itemName,
            "itemDescription": self.itemDescription,
            "impactsWhat": self.impactsWhat,
            "impact": self.impact
        ]
    }
    
}
