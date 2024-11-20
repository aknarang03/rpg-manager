//
//  UserModel.swift
//  RPG Manager
//
//  Created by Anjali Narang  on 11/18/24.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

class UserModel {
    
    static let shared = UserModel()
    
    var msgObserverHandle: UInt?
    
    let userDBref = Database.database().reference(withPath: "Users")
        
    var authorizedUser: AuthenticatedUser?
    var currentUser: User?
    
    var users:[User] = []
    
    private init() {}
    
    // sign in using Firebase authentication
    func signInAsync (withEmail email: String, andPassword password: String) async throws -> (Bool, String) {
        do {
            print("sign in async")
            let authData = try await Auth.auth().signIn(withEmail: email, password: password)
            authorizedUser = AuthenticatedUser(uid: authData.user.uid, email: authData.user.email!)
            try await getLoggedInUser()
            return (true, "Login successful")
        }
        catch {
            let e = error
            print("sign in error \(e)")
            return (false, e.localizedDescription)
        }
    }
    
    // sign out using Firebase authentication
    func signOut() {
        do {
            print("sign out")
            try Auth.auth().signOut()
            authorizedUser = nil
            currentUser = nil
        }
        catch let signOutError as NSError {
            print("Error signing out: \(signOutError)")
        }
    }
    
    // register using Firebase authentication
    func registerAsync (withEmail email: String, andPassword password: String, andUsername username: String) async throws -> (Bool, String) {
        do {
            let userCreateResponse = try await Auth.auth().createUser(withEmail: email, password: password)
            authorizedUser = AuthenticatedUser(uid: userCreateResponse.user.uid, email: userCreateResponse.user.email!)
            addNewUser(withUid: authorizedUser!.uid, andUsername: username, andEmail: email)
            return (true, "User registered")
        }
        catch {
            let e = error
            return (false, e.localizedDescription)
        }
    }

    // add user to realtime database
    func addNewUser(withUid uid: String, andUsername name: String, andEmail email: String) {
        let user = User(uid: uid, username: name, email: email)
        let userNodeRef = userDBref.child(user.uid)
        userNodeRef.setValue(user.toAnyObject())
    }

    // watch for updates from User realtime database table
    func observeUsers () {
        print("observe users")
        msgObserverHandle = userDBref.observe(.value, with: {snapshot in
            var tempUsers:[User] = []
            for child in snapshot.children {
                if let data = child as? DataSnapshot {
                    if let tempUser = User(snapshot: data) {
                        tempUsers.append(tempUser)
                    }
                }
            }
            self.users.removeAll()
            self.users = tempUsers // store users in this model
        })
    }
    
    // stop listening for updates
    func cancelObserver() {
        if let observerHandle = msgObserverHandle {
            userDBref.removeObserver(withHandle: observerHandle)
        }
    }
    
    // get logged in user's user info and save in this model
    func getLoggedInUser() async throws {
        do {
            print("getting logged in user")
            if let uid = authorizedUser?.uid {
                print ("authorized user uid: \(uid)")
                let userDBref = Database.database().reference()
                let userData = try await userDBref.child("Users/\(uid)").getData()
                currentUser = User(snapshot: userData)
                print("get logged in user: \(currentUser?.uid ?? "no uid")")
            }
            
        } catch {
            print ("Cannot get logged in user")
        }
    }
    
    // get username based on ID using this model's saved data
    func getUsername(for uid: String) -> String? {
        return users.first(where: { $0.uid == uid })?.username
    }
    
    // get ID based on username
    func getId(for username: String) -> String? {
        return users.first(where: { $0.username == username })?.uid
    }
    
}
