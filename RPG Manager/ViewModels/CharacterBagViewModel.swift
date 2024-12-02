//
//  CharacterBagViewModel.swift
//  RPG Manager
//
//  Created by Anjali Narang  on 11/26/24.
//


import Foundation
import Combine

class CharacterBagViewModel: ObservableObject {
    
    let userModel = UserModel.shared
    let characterModel = CharacterModel.shared
    let itemModel = ItemModel.shared
    
    @Published var itemID: String = ""
    @Published var itemType: String = ""
    @Published var itemAction: () -> Void = {}
    
    @Published var bagOwner: Character
    @Published var stats: Stats
    
    init(character: Character) {
        self.bagOwner = character
        self.stats = characterModel.getTruncatedStats(characterID: character.characterID)
    }
    
    func itemIdToItemName(itemID: String) -> String {
        guard let itemName = itemModel.getItemName(for: itemID) else {
            print("Item name not found for \(itemID)")
            return "Unknown" // default item name
        }
        return itemName
    }
    
    func getItemType(itemID: String) -> String {
        guard let item = itemModel.getItem(for: itemID) else {
            print("Item not found for \(itemID)")
            return "unknown"
        }
        return item.type
    }
    
    // stats will be truncated right away since item is consumable; unlike with passive / equippable,
    // since with those, if you remove an item from bag and something's impact was truncated, it should
    // kick back in.
    func consumeItem(characterID: String) {
        
        characterModel.consumeItem(characterID: characterID, itemID: itemID)
        let item = itemModel.getItem(for: itemID)
        
        if (item?.impactsWhat == "none" || item?.impact == 0) { // no impact
            print("item has no impact")
            return
        }
        
        else {
            
            let updateCharacter = applyStatChangesWithTruncation(characterID: characterID, itemID: itemID)
            characterModel.updateCharacter(character: updateCharacter)

        }
    }
    
    func deleteItem(characterID: String) {
        
        print("delete item \(itemID)")
        
        if let item = itemModel.getItem(for: itemID) {
            
            print("item = item")
            
            if (item.itemID == bagOwner.heldItem) { // if item is equipped
                unequipItem(characterID: bagOwner.characterID) // uneuqip item before deleted if it's equipped
            }
            
            if (item.type == "passive") { // if item is passively impacting stats right now
                // since passive stat changes were applied directly to character when item was added to bag,
                // we now have to remove these stat changes
                
                var updateCharacter = bagOwner

                switch item.impactsWhat {
                case "health":
                    updateCharacter.stats.health -= item.impact
                    print("item impacts health: \(item.impact)")
                case "attack":
                    updateCharacter.stats.attack -= item.impact
                    print("item impacts attack: \(item.impact)")
                case "defense":
                    updateCharacter.stats.defense -= item.impact
                    print("item impacts defense: \(item.impact)")
                case "speed":
                    updateCharacter.stats.speed -= item.impact
                    print("item impacts speed: \(item.impact)")
                case "agility":
                    updateCharacter.stats.agility -= item.impact
                    print("item impacts agility: \(item.impact)")
                case "hp":
                    updateCharacter.stats.hp -= item.impact
                    print("item impacts hp: \(item.impact)")
                default:
                    print("unhandled impact type: \(item.impactsWhat)")
                }
                
                characterModel.updateCharacter(character: updateCharacter)
                self.stats = characterModel.getTruncatedStats(characterID: bagOwner.characterID)
                
            }

        }
        
        // otherwise, item was consumable so does not matter; we can just remove it without worrying about
        // stat changes
        
        characterModel.removeItemFromBag(characterID: bagOwner.characterID, itemID: itemID, removingAmt: 1)
        
    }
    
    func equipItem(characterID: String) {
        var updateCharacter = characterModel.getCharacter(for: characterID)
        updateCharacter?.heldItem = itemID
        
        let item = itemModel.getItem(for: itemID)
        switch item?.impactsWhat {
        case "health":
            updateCharacter!.stats.health += item!.impact
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
        
        characterModel.updateCharacter(character: updateCharacter!)
        self.stats = characterModel.getTruncatedStats(characterID: bagOwner.characterID)
    }
    
    func unequipItem(characterID: String) {
        var updateCharacter = characterModel.getCharacter(for: characterID)
        updateCharacter?.heldItem = nil
        
        let item = itemModel.getItem(for: itemID)
        switch item?.impactsWhat {
        case "health":
            updateCharacter!.stats.health -= item!.impact
            print("item impacts health: \(item?.impact ?? 0)")
        case "attack":
            updateCharacter!.stats.attack -= item!.impact
            print("item impacts attack: \(item?.impact ?? 0)")
        case "defense":
            updateCharacter!.stats.defense -= item!.impact
            print("item impacts defense: \(item?.impact ?? 0)")
        case "speed":
            updateCharacter!.stats.speed -= item!.impact
            print("item impacts speed: \(item?.impact ?? 0)")
        case "agility":
            updateCharacter!.stats.agility -= item!.impact
            print("item impacts agility: \(item?.impact ?? 0)")
        case "hp":
            updateCharacter!.stats.hp -= item!.impact
            print("item impacts hp: \(item?.impact ?? 0)")
        default:
            print("unhandled impact type: \(item?.impactsWhat ?? "unknown")")
        }
        
        characterModel.updateCharacter(character: updateCharacter!)
        self.stats = characterModel.getTruncatedStats(characterID: bagOwner.characterID)
    }

}
