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
        storyModel.addItemToBag(storyID: storyModel.currentStory!.storyID, characterID: characterID, itemID: item.itemID, addingAmt: 1)
    }

}
