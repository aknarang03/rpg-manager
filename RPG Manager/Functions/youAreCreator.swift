//
//  youAreCreator.swift
//  RPG Manager
//
//  Created by Anjali Narang  on 11/30/24.
//

let userModel = UserModel.shared
let storyModel = StoryModel.shared

func youAreCurrentStoryCreator() -> Bool {
    
    if (userModel.currentUser?.uid == storyModel.currentStory?.creator) {
        return true
    } else {
        return false
    }
    
}

func youAreCharacterCreator(character: Character) -> Bool {
    
    if userModel.currentUser?.uid == character.creatorID {
        return true
    } else {
        return false
    }
    
}

func youAreItemCreator(item: Item) -> Bool {
    
    if userModel.currentUser?.uid == item.creatorID {
        return true
    } else {
        return false
    }
    
}

