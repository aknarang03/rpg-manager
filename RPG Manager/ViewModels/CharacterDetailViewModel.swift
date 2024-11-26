//
//  CharacterDetailViewModel.swift
//  RPG Manager
//
//  Created by Anjali Narang  on 11/20/24.
//

import Foundation
import Combine

class CharacterDetailViewModel: ObservableObject {
    
    let userModel = UserModel.shared
    let storyModel = StoryModel.shared
    
    @Published var itemID: String = ""
    @Published var itemType: String = ""
    @Published var itemAction: () -> Void = {}
    
    @Published var character: Character
    @Published var stats: Stats
    
    init(character: Character) {
        self.character = character
        self.stats = storyModel.getTruncatedStats(characterID: character.characterID)
    }
    
    func uidToUsername(uid: String) -> String {
        guard let username = userModel.getUsername(for: uid) else {
            print("Username not found for \(uid)")
            return "Unknown" // default username
        }
        return username
    }
    
    func itemIdToItemName(itemID: String) -> String {
        
        guard let itemName = storyModel.getItemName(for: itemID) else {
            print("Item name not found for \(itemID)")
            return "Unknown" // default item name
        }
        return itemName
        
    }
    
    func deleteCharacter() {
        storyModel.deleteCharacter(storyID: storyModel.currentStory!.storyID, characterID: character.characterID)
    }

}
