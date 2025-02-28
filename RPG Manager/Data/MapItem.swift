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
    var x: CGFloat
    var y: CGFloat
}

enum MapItemType: String, CaseIterable {
    case character = "character"
    case place = "place"
    case item = "item"
}

struct MapItem {
    
    var ref: DatabaseReference?
    var iconID: String
    var coordinates: Coordinates
    var type: String
    
    init (iconID: String, coordinates: Coordinates, type: String) {
        self.ref = nil
        self.iconID = iconID
        self.coordinates = coordinates
        self.type = type
    }
    
    init? (snapshot: DataSnapshot) {
     
        guard
            let value = snapshot.value as? [String: Any],
            let iconID = value["iconID"] as? String,
            let coordinatesDict = value["coordinates"] as? [String: CGFloat],
            let x = coordinatesDict["x"],
            let y = coordinatesDict["y"],
            let type = value["type"] as? String
        else {
            return nil
        }
                
        self.ref = snapshot.ref
        self.iconID = iconID
        self.coordinates = Coordinates(x: x, y: y)
        self.type = type
    }
    
    func toAnyObject () -> Dictionary<String, Any> {
        
        var dict: [String: Any] = [
            "iconID": self.iconID,
            "coordinates": [
                "x": self.coordinates.x,
                "y": self.coordinates.y
            ],
            "type": self.type
        ]
        
        return dict
        
    }
    
}
