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
    
    /*
     ATTRIBUTES TO ADD LATER:
     - storyDescription: String
     - characters: [String]
    */
    
    var ref: DatabaseReference?
    var storyID: String
    var creator: String
    var collaborators: [String]
        
    init (storyID: String, creator: String, collaborators: [String]) {
        self.ref = nil
        self.storyID = storyID
        self.creator = creator
        self.collaborators = collaborators
    }
    
    init? (snapshot: DataSnapshot) {
     
        guard
            let value = snapshot.value as? [String: Any],
            let storyID = value["storyID"] as? String,
            let creator = value["creator"] as? String,
            let collaborators = value["collaborators"] as? [String]
        else {
            return nil
        }
        
        self.ref = snapshot.ref
        self.storyID = storyID
        self.creator = creator
        self.collaborators = collaborators
        
    }
    
    func toAnyObject () -> Dictionary<String, Any> {
        return [
            "storyID": self.storyID,
            "creator": self.creator,
            "collaborators": self.collaborators
        ]
    }
    
}
