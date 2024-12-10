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
    let characterModel = CharacterModel.shared
    let itemModel = ItemModel.shared
    
    @Published var item: Item
    @Published var characterID: String
    
    private var cancellables: Set<AnyCancellable> = []
    
    @Published var characters: [Character] = []

    init(item: Item) {
        self.item = item
        self.characterID = ""
        characterModel.$currentCharacters
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
        let character = characterModel.getCharacter(for: characterID)
        if character?.bag?.keys.contains(item.itemID) == true {
            if (item.type == "equippable") {
                return;
            }
        }
        characterModel.addItemToBag(characterID: characterID, itemID: item.itemID, addingAmt: 1)
    }
    
    func applyPassiveStatChanges() {
        
        if (item.impactsWhat == "none" || item.impact == 0) { // no impact
            print("item has no impact")
            return
        }
        
        else {
            
            let updateCharacter = applyStatChanges(characterID: characterID, itemID: item.itemID)
            characterModel.updateCharacter(character: updateCharacter)

        }
    }
    
    func deleteItem() {
        itemModel.deleteItem(itemID: item.itemID)
    }

}
