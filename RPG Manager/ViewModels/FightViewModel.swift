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
    @Published var attackingCharacterID: String = ""
    
    @Published var fight: Fight = Fight(fightID: "", userID: "", character1ID: "", character2ID: "", outcomes: nil, winner: "")
    @Published var currentAttackerRoundOutcome: String = ""
    @Published var currentDefenderRoundOutcome: String = ""
    
    @Published var character1: Character = Character(characterID: "", creatorID: "", characterName: "", characterDescription: "", stats: Stats(health: 0, attack: 0, defense: 0, speed: 0, agility: 0, hp: 0), isPlayer: false, heldItem: "")
    @Published var character2: Character = Character(characterID: "", creatorID: "", characterName: "", characterDescription: "", stats: Stats(health: 0, attack: 0, defense: 0, speed: 0, agility: 0, hp: 0), isPlayer: false, heldItem: "")
    
    @Published var outcomes: [String] = []

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
    
    func timeInterval() -> String {
        let timeNow = Date()
        var timeStr = String(timeNow.timeIntervalSince1970)
        timeStr = timeStr.replacingOccurrences(of: ".", with: "")
        return timeStr
    }
    
    func stopFight() { // reset vars
        fight = Fight(fightID: "", userID: "", character1ID: "", character2ID: "", outcomes: nil, winner: "")
        attackingCharacterID = ""
    }
    
    func startFight() {
        
        updateCharacters()
        fight = Fight(fightID: timeInterval(), userID: userModel.currentUser!.uid, character1ID: character1ID, character2ID: character2ID, winner: "")
        storyModel.startFight(storyID: storyModel.currentStory!.storyID, fight: fight)
        
        if (character2.stats.speed > character1.stats.speed) {
            attackingCharacterID = character2ID
        } else {
            attackingCharacterID = character1ID
        }
        
    }
    
    func attackAction() { // TEST
        
        let DAMAGE_TEST = 20
        
        if (attackingCharacterID == character1ID) { // character 1 is attacking; character 2 is defending
            
            character2.stats.hp -= DAMAGE_TEST
            currentAttackerRoundOutcome = storyModel.getOutcomeString(type: OutcomeType.attackerAttack, attackerName: character1.characterName, defenderName: character2.characterName, impact: DAMAGE_TEST, itemName: "")
            currentDefenderRoundOutcome = storyModel.getOutcomeString(type: OutcomeType.defenderGetHit, attackerName: character1.characterName, defenderName: character2.characterName, impact: DAMAGE_TEST, itemName: "")
            
        } else { // character 2 is attacking; character 1 is defending
            
            character1.stats.hp -= DAMAGE_TEST
            currentAttackerRoundOutcome = storyModel.getOutcomeString(type: OutcomeType.attackerAttack, attackerName: character2.characterName, defenderName: character1.characterName, impact: DAMAGE_TEST, itemName: "")
            currentDefenderRoundOutcome = storyModel.getOutcomeString(type: OutcomeType.defenderGetHit, attackerName: character2.characterName, defenderName: character1.characterName, impact: DAMAGE_TEST, itemName: "")
            
        }
        
        if (attackingCharacterID == character1ID) {
            attackingCharacterID = character2ID
        } else {
            attackingCharacterID = character1ID
        }
        
    }
    
    func consumeItemAction() { // TEST
        
        let IMPACT_TEST = -10
        let ITEM_NAME_TEST = "fake test item"
        
        if (attackingCharacterID == character1ID) { // character 1 is consuming item; character 2 is idling
            
            character1.stats.hp -= IMPACT_TEST
            currentAttackerRoundOutcome = storyModel.getOutcomeString(type: OutcomeType.attackerUsesItem, attackerName: character1.characterName, defenderName: character2.characterName, impact: IMPACT_TEST, itemName: ITEM_NAME_TEST)
            currentDefenderRoundOutcome = storyModel.getOutcomeString(type: OutcomeType.defenderIdle, attackerName: character1.characterName, defenderName: character2.characterName, impact: IMPACT_TEST, itemName: ITEM_NAME_TEST)
            
        } else { // character 2 is consuming item; character 1 is idling
            
            character2.stats.hp -= IMPACT_TEST
            currentAttackerRoundOutcome = storyModel.getOutcomeString(type: OutcomeType.attackerUsesItem, attackerName: character2.characterName, defenderName: character1.characterName, impact: IMPACT_TEST, itemName: ITEM_NAME_TEST)
            currentDefenderRoundOutcome = storyModel.getOutcomeString(type: OutcomeType.defenderIdle, attackerName: character2.characterName, defenderName: character1.characterName, impact: IMPACT_TEST, itemName: ITEM_NAME_TEST)
            
        }
        
        if (attackingCharacterID == character1ID) {
            attackingCharacterID = character2ID
        } else {
            attackingCharacterID = character1ID
        }
        
    }
    
    // called at end of each action (attacker outcome, defender outcome)
    func finishOutcome() {
        fight.outcomes?.append((currentAttackerRoundOutcome,currentDefenderRoundOutcome))
        storyModel.updateFight(storyID: storyModel.currentStory!.storyID, fight: fight)
        currentAttackerRoundOutcome = ""
        currentDefenderRoundOutcome = ""
    }
    // NOTE: rounds are just two outcomes, which is the result of one action. rounds are not stored in database; they will just be displayed as such in the UI.
    
    // END FIGHT:
    // surrender(which character)
    // lose(which character)
        
}
