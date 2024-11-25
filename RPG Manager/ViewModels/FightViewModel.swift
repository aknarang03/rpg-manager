//
//  FightViewModel.swift
//  RPG Manager
//
//  Created by Anjali Narang  on 11/25/24.
//


import Foundation
import Combine

class FightViewModel: ObservableObject {
    
    let userModel = UserModel.shared
    let storyModel = StoryModel.shared
        
    var cancellables: Set<AnyCancellable> = []
    
    @Published var characters: [Character] = []
    
    @Published var character1ID: String
    @Published var character2ID: String
    
    @Published var character1: Character = Character(characterID: "", creatorID: "", characterName: "", characterDescription: "", stats: Stats(health: 0, attack: 0, defense: 0, speed: 0, agility: 0, hp: 0), isPlayer: false, heldItem: "")
    @Published var character2: Character = Character(characterID: "", creatorID: "", characterName: "", characterDescription: "", stats: Stats(health: 0, attack: 0, defense: 0, speed: 0, agility: 0, hp: 0), isPlayer: false, heldItem: "")

    init() {
        self.character1ID = ""
        self.character2ID = ""
        storyModel.$currentCharacters
            .sink { [weak self] newChars in
                self?.characters = newChars
                self?.updateCharacters() }
            .store(in: &cancellables)
    }
    
    func updateCharacters () {
        
        if let char1 = characters.first(where: { $0.characterID == character1ID }),
           let char2 = characters.first(where: { $0.characterID == character2ID }) {
            character1 = char1
            character2 = char2
        }
        
    }
    
    func startFight() {
        updateCharacters()
    }
    
    // when fight starts, need to store the 2 characters.. I think.. but let them update. they
    // should be refs to the ones in firebase.
    
}
