//
//  HomeViewModel.swift
//  RPG Manager
//
//  Created by Anjali Narang  on 11/25/24.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    
    let storyModel = StoryModel.shared
    let userModel = UserModel.shared
    
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
