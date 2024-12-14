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
        
    init (storyID: String, storyName: String, storyDescription: String, creator: String, collaborators: [String]? = nil) {
        self.ref = nil
        self.storyID = storyID
        self.storyName = storyName
        self.storyDescription = storyDescription
        self.creator = creator
        self.collaborators = collaborators
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
        
        let collaborators = value["Collaborators"] as? [String] ?? []
        
        self.ref = snapshot.ref
        self.storyID = storyID
        self.storyName = storyName
        self.storyDescription = storyDescription
        self.creator = creator
        self.collaborators = collaborators
        
    }
    
    func toAnyObject () -> Dictionary<String, Any> {
        
        var dict: [String:Any] = [
            "storyID": self.storyID,
            "storyName": self.storyName,
            "storyDescription": self.storyDescription,
            "creator": self.creator
        ]
        
        if let collaborators = self.collaborators {
            dict["collaborators"] = collaborators
        }
        
        return dict
    }
    
}
