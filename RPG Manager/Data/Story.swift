//
//  Story.swift
//  RPG Manager
//
//  Created by Anjali Narang  on 11/18/24.
//

import Foundation
import Firebase
import FirebaseDatabase

struct Story {
        
    var ref: DatabaseReference?
    var storyID: String
    var storyName: String
    var creator: String
    var storyDescription: String
    var collaborators: [String]?
    var mapImageURL: String?
        
    init (storyID: String, storyName: String, storyDescription: String, creator: String, mapImageURL: String) {
        self.ref = nil
        self.storyID = storyID
        self.storyName = storyName
        self.storyDescription = storyDescription
        self.creator = creator
        self.collaborators = nil
    }
    
    init? (snapshot: DataSnapshot) {
     
        guard
            let value = snapshot.value as? [String: Any],
            let storyID = value["storyID"] as? String,
            let storyName = value["storyName"] as? String,
            let storyDescription = value["storyDescription"] as? String,
            let creator = value["creator"] as? String
        else {
            return nil
        }
        let mapImageURL = value["mapImageURL"] as? String
        
        self.ref = snapshot.ref
        self.storyID = storyID
        self.storyName = storyName
        self.storyDescription = storyDescription
        self.creator = creator
        self.mapImageURL = mapImageURL
        
    }
    
    func toAnyObject () -> Dictionary<String, Any> {
        var dict : [String:Any] = [
            "storyID": self.storyID,
            "storyName": self.storyName,
            "storyDescription": self.storyDescription,
            "creator": self.creator
        ]
        
        if let mapImageURL = self.mapImageURL {
            dict["mapImageURL"] = mapImageURL
        }
        
        return dict
    }
    
}
