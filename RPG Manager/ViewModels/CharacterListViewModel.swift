//
//  CharacterListViewModel.swift
//  RPG Manager
//
//  Created by Anjali Narang  on 11/20/24.
//

import Foundation
import Combine

class CharacterListViewModel: ObservableObject {
    
    let userModel = UserModel.shared
    let characterModel = CharacterModel.shared
    
    private var cancellables: Set<AnyCancellable> = []
    
    @Published var characters: [Character] = []

    init() {
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

}
