//
//  User.swift
//  RPG Manager
//
//  Created by Anjali Narang  on 11/18/24.
//

import Foundation
import Firebase
import FirebaseDatabase

struct User {

    let ref: DatabaseReference?
    let uid: String
    let email: String
    let username: String
    
    init(uid: String, username: String, email: String) {
        self.ref = nil
        self.uid = uid
        self.username = username
        self.email = email
    }
    
    init?(snapshot: DataSnapshot) {
        
        print (snapshot)
        
        guard
            let value = snapshot.value as? [String: AnyObject],
            let username = value["username"] as? String,
            let email = value["email"] as? String,
            let uid = value["uid"] as? String
        else {
            return nil
        }
        
        self.ref = snapshot.ref
        self.uid = uid
        self.username = username
        self.email = email
        
    }
    
    func toAnyObject() -> Dictionary<String, String> {
        return [
            "username": username,
            "email": email,
            "uid": uid
        ]
    }
    
}
