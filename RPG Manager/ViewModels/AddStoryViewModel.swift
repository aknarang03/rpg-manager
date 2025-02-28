//
//  AddStoryViewModel.swift
//  RPG Manager
//
//  Created by Anjali Narang  on 11/18/24.
//

import Foundation

class AddStoryViewModel: ObservableObject {
    
    let userModel = UserModel.shared
    let storyModel = StoryModel.shared
    
    @Published var storyName: String = ""
    @Published var storyDescription: String = ""
    @Published var testID: String = ""
    
    func addStory() {
        
        let newStory = Story(storyID: idWithTimeInterval(), storyName: storyName, storyDescription: storyDescription, creator: userModel.currentUser!.uid, mapImageURL: "")
        storyModel.postNewStory(story: newStory)
        testID = newStory.storyID

    }

}
