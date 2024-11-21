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
    
    func consumeItem(characterID: String) {
        
        storyModel.consumeItem(storyID: storyModel.currentStory!.storyID, characterID: characterID, itemID: itemID)
        let item = storyModel.getItem(for: itemID)
        
        if (item?.impactsWhat == "none" || item?.impact == 0) { // no impact
            print("item has no impact")
            return
        }
        
        else {
            
            var updateCharacter = storyModel.getCharacter(for: characterID)
            
            switch item?.impactsWhat {
            case "health":
                updateCharacter!.stats.health += item!.impact
                if (updateCharacter!.stats.hp > updateCharacter!.stats.health) {
                    updateCharacter!.stats.hp = updateCharacter!.stats.health
                }
                print("item impacts health: \(item?.impact ?? 0)")
            case "attack":
                updateCharacter!.stats.attack += item!.impact
                print("item impacts attack: \(item?.impact ?? 0)")
            case "defense":
                updateCharacter!.stats.defense += item!.impact
                print("item impacts defense: \(item?.impact ?? 0)")
            case "speed":
                updateCharacter!.stats.speed += item!.impact
                print("item impacts speed: \(item?.impact ?? 0)")
            case "agility":
                updateCharacter!.stats.agility += item!.impact
                print("item impacts agility: \(item?.impact ?? 0)")
            case "hp":
                updateCharacter!.stats.hp += item!.impact
                print("item impacts hp: \(item?.impact ?? 0)")
            default:
                print("unhandled impact type: \(item?.impactsWhat ?? "unknown")")
            }
            
            storyModel.updateCharacter(storyID: storyModel.currentStory!.storyID, character: updateCharacter!)

        }
    }

}
