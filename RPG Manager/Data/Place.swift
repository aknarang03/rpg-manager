//
//  Place.swift
//  RPG Manager
//
//  Created by Anjali Narang  on 12/17/24.
//

import Foundation
import Firebase
import FirebaseDatabase

struct Place {
    
    var ref: DatabaseReference?
    var placeID: String
    var placeName: String
    var placeDescription: String
    var creator: String
    var iconURL: String?
        
    init (placeID: String, placeName: String, placeDescription: String, creator: String, iconURL: String) {
        self.ref = nil
        self.placeID = placeID
        self.placeName = placeName
        self.placeDescription = placeDescription
        self.creator = creator
        self.iconURL = iconURL
    }
    
    init? (snapshot: DataSnapshot) {
     
        guard
            let value = snapshot.value as? [String: Any],
            let placeID = value["placeID"] as? String,
            let placeName = value["placeName"] as? String,
            let placeDescription = value["placeDescription"] as? String,
            let creator = value["creator"] as? String
        else {
            return nil
        }
        let iconURL = value["iconURL"] as? String
        
        self.ref = snapshot.ref
        self.placeID = placeID
        self.placeName = placeName
        self.placeDescription = placeDescription
        self.creator = creator
        self.iconURL = iconURL
        
    }
    
    func toAnyObject () -> Dictionary<String, Any> {
        
        var dict: [String:Any] = [
            "placeID": self.placeID,
            "placeName": self.placeName,
            "placeDescription": self.placeDescription,
            "creator": self.creator
        ]
        
        if let iconURL = self.iconURL {
            dict["iconURL"] = iconURL
        }
        
        return dict
        
    }
    
}
