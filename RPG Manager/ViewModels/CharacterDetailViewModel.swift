//
//  CharacterDetailViewModel.swift
//  RPG Manager
//
//  Created by Anjali Narang  on 11/20/24.
//

import Foundation
import Combine
import PhotosUI

class CharacterDetailViewModel: ObservableObject {
    
    let userModel = UserModel.shared
    let itemModel = ItemModel.shared
    let characterModel = CharacterModel.shared
    
    @Published var itemID: String = ""
    @Published var itemType: String = ""
    @Published var itemAction: () -> Void = {}
    
    @Published var character: Character
    @Published var stats: Stats
    
    init(character: Character) {
        self.character = character
        self.stats = characterModel.getTruncatedStats(characterID: character.characterID)
    }
    
    func uidToUsername(uid: String) -> String {
        guard let username = userModel.getUsername(for: uid) else {
            print("Username not found for \(uid)")
            return "Unknown" // default username
        }
        return username
    }
    
    func itemIdToItemName(itemID: String) -> String {
        
        guard let itemName = itemModel.getItemName(for: itemID) else {
            print("Item name not found for \(itemID)")
            return "Unknown" // default item name
        }
        return itemName
        
    }
    
    func getItem(itemID: String) -> Item {
        guard let item = itemModel.getItem(for: itemID) else {
            print("Item not found for \(itemID)")
            return Item(itemID: "", creatorID: "", itemName: "", itemDescription: "", impactsWhat: "", impact: 0, type: "", iconURL: "")
        }
        return item
    }
    
    func deleteCharacter() {
        characterModel.deleteCharacter(characterID: character.characterID)
    }
    
    func updateCharacterIcon(image: UIImage) {
        characterModel.uploadCharacterIcon(image: image, imageID: idWithTimeInterval(), characterID: character.characterID) // this also calls function that updates database ref
    }
    
    func reviveCharacter() {
        var updateCharacter = character
        updateCharacter.stats.hp = updateCharacter.stats.health
        updateCharacter.alive = true
        characterModel.updateCharacter(character: updateCharacter)
    }

}
