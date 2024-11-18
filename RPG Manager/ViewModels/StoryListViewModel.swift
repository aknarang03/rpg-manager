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
    
    func startObserving() {
        print("start observing stories")
        userModel.observeUsers()
        storyModel.observeItems()
    }
    
    func stopObserving() {
        print("stop observing stories")
        storyModel.cancelObserver()
        userModel.cancelObserver()
    }

}
