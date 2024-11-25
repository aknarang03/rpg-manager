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
            character1.stats = getTruncatedStats(character: char1)
            character2.stats = getTruncatedStats(character: char2)
        }
    }
    
    // couldnt use the story model one because of what seems to be a synchronization issue...
    func getTruncatedStats(character: Character) -> Stats {
                
        var stats = character.stats
        
        if (character.stats.health > 100) {
            stats.health = 100
        }
        else if (character.stats.health < 0) {
            stats.health = 0
        }
    
        if (character.stats.attack > 100) {
            stats.attack = 100
        }
        else if (character.stats.attack < 0) {
            stats.attack = 0
        }
    
        if (character.stats.defense > 100) {
            stats.defense = 100
        }
        else if (character.stats.defense < 0) {
            stats.defense = 0
        }
    
        if (character.stats.speed > 100) {
            stats.speed = 100
        }
        else if (character.stats.speed < 0) {
            stats.speed = 0
        }
        
        if (character.stats.agility > 100) {
            stats.agility = 100
        }
        else if (character.stats.agility < 0) {
            stats.agility = 0
        }
    
        if (character.stats.hp > character.stats.health) {
            stats.hp = stats.health
        }
        else if (character.stats.hp < 0) {
            stats.hp = 0
        }
        
        return stats
        
    
    }
    
    func startFight() {
        updateCharacters()
    }
    
}
