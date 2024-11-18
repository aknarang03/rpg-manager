//
//  StoryListViewModel.swift
//  RPG Manager
//
//  Created by Anjali Narang  on 11/18/24.
//

import Foundation

class StoryListViewModel: ObservableObject {
    
    let storyModel = StoryModel.shared
    
    @Published var stories: [Story] = []

    init() {
        // I may have to return snapshot here instead of accessing stories in model. Not sure
        storyModel.observeItems()
        self.stories = storyModel.stories
        storyModel.$stories
            .assign(to: &$stories)
    }

}
