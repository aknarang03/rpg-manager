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
        self.stories = storyModel.stories
        storyModel.$stories
            .assign(to: &$stories)
    }

}
