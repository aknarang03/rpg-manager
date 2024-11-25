//
//  CharacterListViewModel.swift
//  RPG Manager
//
//  Created by Anjali Narang  on 11/20/24.
//

import Foundation
import Combine

class CharacterListViewModel: ObservableObject {
    
    let storyModel = StoryModel.shared
    let userModel = UserModel.shared
    
    private var cancellables: Set<AnyCancellable> = []
    
    @Published var characters: [Character] = []

    init() {
        // I don't fully understand it, but it lets this.stories synch with storyModel.stories...
        // This way I can keep this stuff out of the view and in the view model.
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
    
    func deleteCharacter(characterID: String) {
        storyModel.deleteCharacter(storyID: storyModel.currentStory!.storyID, characterID: characterID)
    }

}
