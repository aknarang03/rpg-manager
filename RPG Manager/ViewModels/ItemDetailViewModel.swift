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
    
    init(item: Item) {
        self.item = item
    }
    
    func uidToUsername(uid: String) -> String {
        guard let username = userModel.getUsername(for: uid) else {
            print("Username not found for \(uid)")
            return "Unknown" // default username
        }
        return username
    }
    
    func testAddItemToBag() {
        storyModel.addItemToBag(storyID: storyModel.currentStory!.storyID, characterID: storyModel.currentCharacters[0].characterID, itemID: item.itemID, addingAmt: 1)
    }

}
