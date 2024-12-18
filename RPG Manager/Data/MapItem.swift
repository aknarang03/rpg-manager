//
//  Map.swift
//  RPG Manager
//
//  Created by Anjali Narang  on 12/18/24.
//

import Foundation
import Firebase
import FirebaseDatabase

struct Coordinates{
    var x: Float
    var y: Float
}

struct MapItem {
    
    var ref: DatabaseReference?
    var iconID: String
    var coordinates: Coordinates
    
    init (iconID: String, coordinates: Coordinates) {
        self.ref = nil
        self.iconID = iconID
        self.coordinates = coordinates
    }
    
    init? (snapshot: DataSnapshot) {
     
        guard
            let value = snapshot.value as? [String: Any],
            let iconID = value["iconID"] as? String,
            let coordinates = value["coordinates"] as? Coordinates
        else {
            return nil
        }
                
        self.ref = snapshot.ref
        self.iconID = iconID
        self.coordinates = coordinates
    }
    
    func toAnyObject () -> Dictionary<String, Any> {
        
        var dict: [String: Any] = [
            "iconID": self.iconID,
            "coordinates": self.coordinates
        ]
        
        return dict
        
    }
    
}
