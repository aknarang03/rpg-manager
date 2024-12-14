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
    var characters: [Character]?
    var collaborators: [String]?
        
    init (storyID: String, storyName: String, storyDescription: String, creator: String) {
        self.ref = nil
        self.storyID = storyID
        self.storyName = storyName
        self.storyDescription = storyDescription
        self.creator = creator
        self.characters = nil
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
        
        self.ref = snapshot.ref
        self.storyID = storyID
        self.storyName = storyName
        self.storyDescription = storyDescription
        self.creator = creator
        
    }
    
    func toAnyObject () -> Dictionary<String, Any> {
        return [
            "storyID": self.storyID,
            "storyName": self.storyName,
            "storyDescription": self.storyDescription,
            "creator": self.creator
        ]
    }
    
}
