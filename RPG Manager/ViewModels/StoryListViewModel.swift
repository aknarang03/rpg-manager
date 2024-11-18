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
            .sink { [weak self] newStories in
                self?.stories = newStories
            }
            .store(in: &cancellables)

        userModel.observeUsers()
        storyModel.observeItems()
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
