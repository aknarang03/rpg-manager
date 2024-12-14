//
//  StoryListViewModel.swift
//  RPG Manager
//
//  Created by Anjali Narang  on 11/18/24.
//

import Foundation
import Combine

class StoryListViewModel: ObservableObject {
    
    let storyModel = StoryModel.shared
    let userModel = UserModel.shared
    
    private var cancellables: Set<AnyCancellable> = []
    
    @Published var stories: [Story] = []

    init() {
        storyModel.$stories
            .sink { [weak self] newStories in self?.stories = newStories }
            .store(in: &cancellables)
    }
    
    func tappedStory(
            story: Story,
            onSuccess: @escaping () -> Void,
            onFailure: @escaping (String) -> Void
        ) {
            storyModel.setCurrentStory(tappedOn: story)
            onSuccess()
    }
    
    func uidToUsername(uid: String) -> String {
        guard let username = userModel.getUsername(for: uid) else {
            print("Username not found for \(uid)")
            return "Unknown" // default username
        }
        return username
    }

}
