//
//  AddCollaboratorViewModel.swift
//  RPG Manager
//
//  Created by Anjali Narang  on 11/20/24.
//

import Foundation

class AddCollaboratorViewModel: ObservableObject {
    
    let storyModel = StoryModel.shared
    let userModel = UserModel.shared
    
    @Published var username: String = ""
    
    func addCollaborator() {
        
        if (username == userModel.currentUser?.username) {
            print("Cannot add yourself")
            return
        }
        if (username == userModel.getUsername(for: storyModel.currentStory!.creator)) {
            print("Cannot add creator")
            return
        }
        
        guard let newCollaborator = userModel.getId(for: username)
        else {
            print("Cannot find user by this username")
            return
        }
                
        storyModel.addCollaboratorToStory(collaboratorID: newCollaborator)
        
    }

}
