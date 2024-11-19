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
    */
    
    // NOTE: I think I need to somehow switch to having collaborators and characters as child nodes
    
    var ref: DatabaseReference?
    var storyID: String
    var storyName: String
    var creator: String
    var collaborators: [String]
    var characters: [Character]
        
    init (storyID: String, storyName: String, creator: String, collaborators: [String], characters: [Character]) {
        self.ref = nil
        self.storyID = storyID
        self.storyName = storyName
        self.creator = creator
        self.collaborators = collaborators
        self.characters = characters
    }
    
    init? (snapshot: DataSnapshot) {
     
        guard
            let value = snapshot.value as? [String: Any],
            let storyID = value["storyID"] as? String,
            let storyName = value["storyName"] as? String,
            let creator = value["creator"] as? String,
            let collaborators = value["collaborators"] as? [String],
            let characters = value["characters"] as? [Character]
        else {
            return nil
        }
        
        self.ref = snapshot.ref
        self.storyID = storyID
        self.storyName = storyName
        self.creator = creator
        self.collaborators = collaborators
        self.characters = characters
        
    }
    
    func toAnyObject () -> Dictionary<String, Any> {
        return [
            "storyID": self.storyID,
            "storyName": self.storyName,
            "creator": self.creator,
            "collaborators": self.collaborators,
            "characters": self.characters
        ]
    }
    
}
