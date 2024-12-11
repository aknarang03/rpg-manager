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
    
    init(character: Character) {
        self.bagOwner = character
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
    
    func getItem(itemID: String) -> Item {
        guard let item = itemModel.getItem(for: itemID) else {
            print("Item not found for \(itemID)")
            return Item(itemID: "", creatorID: "", itemName: "", itemDescription: "", impactsWhat: "", impact: 0, type: "", iconURL: "")
        }
        return item
    }
    
    // NOTE TO SELF: maybe I don't need updateCharacter in the methods?? or passing in characterID to the methods? can I just use bagOwner? it's because of how I structured applyStatChanges tho, so I have to see if i need that anywhere at all 
    
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
            
            var updateCharacter = applyStatChangesWithTruncation(characterID: characterID, itemID: itemID)
            if (updateCharacter.stats.hp <= 0) {
                updateCharacter.alive = false
            }
            characterModel.updateCharacter(character: updateCharacter)

        }
                
    }
    
    func deleteItem(characterID: String) {
        
        print("delete item \(itemID)")
        
        if let item = itemModel.getItem(for: itemID) {
                        
            if (item.itemID == bagOwner.heldItem) { // if item is equipped
                unequipItem(characterID: bagOwner.characterID) // uneuqip item before deleted if it's equipped
            }
            
            if (item.type == "passive") {
                var updateCharacter = unapplyStatChanges(characterID: bagOwner.characterID, itemID: itemID)
                if (updateCharacter.stats.hp <= 0) {
                    updateCharacter.alive = false
                }
                characterModel.updateCharacter(character: updateCharacter)
            }
           
        }
        
        characterModel.removeItemFromBag(characterID: bagOwner.characterID, itemID: itemID, removingAmt: 1)
                
    }
    
    func equipItem(characterID: String) {
        var updateCharacter = applyStatChanges(characterID: characterID, itemID: itemID)
        updateCharacter.heldItem = itemID
        if (updateCharacter.stats.hp <= 0) {
            updateCharacter.alive = false
        }
        characterModel.updateCharacter(character: updateCharacter)
    }
    
    func unequipItem(characterID: String) {
        var updateCharacter = unapplyStatChanges(characterID: characterID, itemID: itemID)
        updateCharacter.heldItem = nil
        if (updateCharacter.stats.hp <= 0) {
            updateCharacter.alive = false
        }
        characterModel.updateCharacter(character: updateCharacter)
    }
    
}
