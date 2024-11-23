//
//  ItemDetailViewModel.swift
//  RPG Manager
//
//  Created by Anjali Narang  on 11/20/24.
//

import Foundation
import Combine

class ItemDetailViewModel: ObservableObject {
    
    let userModel = UserModel.shared
    let storyModel = StoryModel.shared
    
    @Published var item: Item
    @Published var characterID: String
    
    private var cancellables: Set<AnyCancellable> = []
    
    @Published var characters: [Character] = []

    init(item: Item) {
        self.item = item
        self.characterID = ""
        storyModel.$currentCharacters
            .sink { [weak self] newChars in self?.characters = newChars }
            .store(in: &cancellables)
    }
    
    func uidToUsername(uid: String) -> String {
        guard let username = userModel.getUsername(for: uid) else {
            print("Username not found for \(uid)")
            return "Unknown" // default username
        }
        return username
    }
    
    func addItemToBag() {
        let character = storyModel.getCharacter(for: characterID)
        if character?.bag?.keys.contains(item.itemID) == true {
            if (item.type == "equippable") {
                return;
            }
        }
        storyModel.addItemToBag(storyID: storyModel.currentStory!.storyID, characterID: characterID, itemID: item.itemID, addingAmt: 1)
    }
    
    
    // problem: what if a stat is truncated but then it's reduced, but passive item impact doesn't then adjust...
    func applyPassiveStatChanges() {
        
        if (item.impactsWhat == "none" || item.impact == 0) { // no impact
            print("item has no impact")
            return
        }
        
        else {
            
            var updateCharacter = storyModel.getCharacter(for: characterID)
            
            // make an update stats method.. this is very messy
            
            switch item.impactsWhat {
            case "health":
                updateCharacter!.stats.health += item.impact
                print("item impacts health: \(item.impact)")
            case "attack":
                updateCharacter!.stats.attack += item.impact
                print("item impacts attack: \(item.impact)")
            case "defense":
                updateCharacter!.stats.defense += item.impact
                print("item impacts defense: \(item.impact)")
            case "speed":
                updateCharacter!.stats.speed += item.impact
                print("item impacts speed: \(item.impact)")
            case "agility":
                updateCharacter!.stats.agility += item.impact
                print("item impacts agility: \(item.impact)")
            case "hp":
                updateCharacter!.stats.hp += item.impact
                print("item impacts hp: \(item.impact)")
            default:
                print("unhandled impact type: \(item.impactsWhat)")
            }
            
            storyModel.updateCharacter(storyID: storyModel.currentStory!.storyID, character: updateCharacter!)

        }
    }

}
