//
//  CollaboratorsListViewModel.swift
//  RPG Manager
//
//  Created by Anjali Narang  on 11/20/24.
//

import Foundation
import Combine

class CollaboratorListViewModel: ObservableObject {
    
    let storyModel = StoryModel.shared
    let userModel = UserModel.shared
    
    private var cancellables: Set<AnyCancellable> = []
    
    @Published var collaborators: [String] = []

    init() {
        // I don't fully understand it, but it lets this.stories synch with storyModel.stories...
        // This way I can keep this stuff out of the view and in the view model.
        storyModel.$currentCollaborators
            .sink { [weak self] newCollabs in self?.collaborators = newCollabs }
            .store(in: &cancellables)
    }
    
//    func tappedCollaborator(
//            collaborator: String,
//            onSuccess: @escaping () -> Void,
//            onFailure: @escaping (String) -> Void
//        ) {
//            onSuccess()
//    }
    
    func removeCollaborator(uid: String) {
        storyModel.removeCollaboratorFromStory(collaboratorID: uid)
    }
    
    func getCreator() -> String {
        
        if let creator = storyModel.currentStory?.creator {
            return creator
        } else {
            return "Unknown"
        }
        
    }
    
    func uidToUsername(uid: String) -> String {
        guard let username = userModel.getUsername(for: uid) else {
            print("Username not found for \(uid)")
            return "Unknown" // default username
        }
        return username
    }

}
