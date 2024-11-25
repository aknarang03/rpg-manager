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
        // I don't fully understand it, but it lets this.stories synch with storyModel.stories...
        // This way I can keep this stuff out of the view and in the view model.
        storyModel.$stories
            .sink { [weak self] newStories in self?.stories = newStories }
            .store(in: &cancellables)
    }
    
    func deleteStory(storyID: String) {
        storyModel.deleteStory(storyID: storyID)
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
    
    func startObserving() {
        print("start observing")
        userModel.observeUsers()
        storyModel.observeStories()
    }
    
    func stopObserving() {
        print("stop observing")
        storyModel.cancelStoryObserver()
        userModel.cancelObserver()
    }

}
