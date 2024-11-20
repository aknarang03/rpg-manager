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
    
    func timeInterval() -> String {
        let timeNow = Date()
        var timeStr = String(timeNow.timeIntervalSince1970)
        timeStr = timeStr.replacingOccurrences(of: ".", with: "")
        return timeStr
    }
    
    func addStory() {
        
        let newStory = Story(storyID: timeInterval(), storyName: storyName, storyDescription: storyDescription, creator: userModel.currentUser!.uid)
        storyModel.postNewStory(story: newStory)
        testID = newStory.storyID

    }

}
