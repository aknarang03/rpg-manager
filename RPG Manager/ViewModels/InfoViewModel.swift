//
//  InfoViewModel.swift
//  RPG Manager
//
//  Created by Anjali Narang  on 12/17/24.
//

import Foundation
import Combine

class InfoViewModel: ObservableObject {
    
    let storyModel = StoryModel.shared
    let userModel = UserModel.shared
    
    private var cancellables: Set<AnyCancellable> = []
    
    @Published var currentStory: Story = Story(storyID: "0", storyName: "None", storyDescription: "None", creator: "Unknown")
    @Published var collaborators: [String] = []

    init() {
        
        storyModel.$currentStory
            .sink { [weak self] newCurr in self?.currentStory = newCurr ?? Story(storyID: "0", storyName: "None", storyDescription: "None", creator: "Unknown") }
            .store(in: &cancellables)
        storyModel.$currentCollaborators
            .sink { [weak self] newCollabs in self?.collaborators = newCollabs }
            .store(in: &cancellables)
        
    }
    
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
    
    func deleteStory() {
        storyModel.deleteStory(storyID: currentStory.storyID)
    }

}
