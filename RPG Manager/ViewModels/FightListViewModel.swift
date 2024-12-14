//
//  FightListViewModel.swift
//  RPG Manager
//
//  Created by Anjali Narang  on 11/26/24.
//


import Foundation
import Combine

class FightListViewModel: ObservableObject {
    
    let storyModel = StoryModel.shared
    let userModel = UserModel.shared
    let fightModel = FightModel.shared
    let characterModel = CharacterModel.shared
    
    private var cancellables: Set<AnyCancellable> = []
    
    @Published var fights: [Fight] = []

    init() {
        fightModel.$currentFights
            .sink { [weak self] newFights in self?.fights = newFights }
            .store(in: &cancellables)
    }
    
    func getCharacter(characterID: String) -> Character? {
        if let character = characterModel.getCharacter(for: characterID) {
            return character
        } else {
            return nil
        }
    }
    
    func getCharacterName (characterID: String) -> String {
        if let characterName = characterModel.getCharacter(for: characterID)?.characterName {
            return characterName
        } else {
            return "Unknown"
        }
    }
    
    func characterIsWinner (characterID: String, winnerID: String) -> Bool {
        if characterID == winnerID {
            return true
        }
        return false
    }
    
    func removeFight(fightID: String) {
        fightModel.deleteFight(fightID: fightID)
    }

}
