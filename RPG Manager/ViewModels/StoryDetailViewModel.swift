//
//  StoryDetailViewModel.swift
//  RPG Manager
//
//  Created by Anjali Narang  on 11/20/24.
//

import Foundation
import Combine

class StoryDetailViewModel: ObservableObject {
    
    let storyModel = StoryModel.shared
    
    private var cancellables: Set<AnyCancellable> = []
    
    @Published var currentStory: Story = Story(storyID: "0", storyName: "None", storyDescription: "None", creator: "Unknown")

    init() {
        
        storyModel.$currentStory
            .sink { [weak self] newCurr in self?.currentStory = newCurr ?? Story(storyID: "0", storyName: "None", storyDescription: "None", creator: "Unknown") }
            .store(in: &cancellables)
        
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
