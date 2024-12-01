//
//  youAreCreator.swift
//  RPG Manager
//
//  Created by Anjali Narang  on 11/30/24.
//

func youAreCurrentStoryCreator() -> Bool {
    
    let userModel = UserModel.shared
    let storyModel = StoryModel.shared
    
    if (userModel.currentUser?.uid == storyModel.currentStory?.creator) {
        return true
    } else {
        return false
    }
    
}

func youAreCharacterCreator(character: Character) -> Bool {
    
    let userModel = UserModel.shared

    if userModel.currentUser?.uid == character.creatorID {
        return true
    } else {
        return false
    }
    
}

func youAreItemCreator(item: Item) -> Bool {
    
    let userModel = UserModel.shared

    if userModel.currentUser?.uid == item.creatorID {
        return true
    } else {
        return false
    }
    
}

