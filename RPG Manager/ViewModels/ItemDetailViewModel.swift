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
                if (updateCharacter!.stats.health > 100) {
                    updateCharacter!.stats.health = 100
                }
                else if (updateCharacter!.stats.health < 0) {
                    updateCharacter!.stats.health = 0
                }
                if (updateCharacter!.stats.hp > updateCharacter!.stats.health) {
                    updateCharacter!.stats.hp = updateCharacter!.stats.health
                }
                print("item impacts health: \(item.impact)")
            case "attack":
                updateCharacter!.stats.attack += item.impact
                if (updateCharacter!.stats.attack > 100) {
                    updateCharacter!.stats.attack = 100
                }
                else if (updateCharacter!.stats.attack < 0) {
                    updateCharacter!.stats.attack = 0
                }
                print("item impacts attack: \(item.impact)")
            case "defense":
                updateCharacter!.stats.defense += item.impact
                if (updateCharacter!.stats.defense > 100) {
                    updateCharacter!.stats.defense = 100
                }
                else if (updateCharacter!.stats.defense < 0) {
                    updateCharacter!.stats.defense = 0
                }
                print("item impacts defense: \(item.impact)")
            case "speed":
                updateCharacter!.stats.speed += item.impact
                if (updateCharacter!.stats.speed > 100) {
                    updateCharacter!.stats.speed = 100
                }
                else if (updateCharacter!.stats.speed < 0) {
                    updateCharacter!.stats.speed = 0
                }
                print("item impacts speed: \(item.impact)")
            case "agility":
                updateCharacter!.stats.agility += item.impact
                if (updateCharacter!.stats.agility > 100) {
                    updateCharacter!.stats.agility = 100
                }
                else if (updateCharacter!.stats.agility < 0) {
                    updateCharacter!.stats.agility = 0
                }
                print("item impacts agility: \(item.impact)")
            case "hp":
                updateCharacter!.stats.hp += item.impact
                if (updateCharacter!.stats.hp > updateCharacter!.stats.health) {
                    updateCharacter!.stats.hp = updateCharacter!.stats.health
                }
                else if (updateCharacter!.stats.hp < 0) {
                    updateCharacter!.stats.hp = 0
                }
                print("item impacts hp: \(item.impact)")
            default:
                print("unhandled impact type: \(item.impactsWhat)")
            }
            
            storyModel.updateCharacter(storyID: storyModel.currentStory!.storyID, character: updateCharacter!)

        }
    }

}
