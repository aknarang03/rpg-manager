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
        storyModel.postNewItem(story: newStory)
        testID = newStory.storyID

    }
    
    func addCollaboratorTest() {
        // try adding a collaborator
        guard let newCollaborator = userModel.getId(for: "usuh")
        else {
            print("Cannot find user by this username")
            return
        }
        storyModel.addCollaboratorToStory(storyID: testID, collaboratorID: newCollaborator)
    }
    
    func addCharacterTest() {
        // try adding a character
        let newCharacter = Character(characterID: timeInterval(), creatorID: userModel.currentUser!.uid, characterName: "Bob", stats: Stats(attack: 5, defense: 4, speed: 3, agility: 2))
        storyModel.addCharacterToStory(storyID: testID, character: newCharacter)
    }

}
