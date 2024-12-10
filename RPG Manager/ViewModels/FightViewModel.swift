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
    let fightModel = FightModel.shared
    let itemModel = ItemModel.shared
    let characterModel = CharacterModel.shared
        
    var cancellables: Set<AnyCancellable> = []
    
    // NOTE TO SELF: some of these may not need to be Published
    
    @Published var showCharacterBag: Bool = false
    @Published var itemToConsume: String = ""
    
    @Published var isWorking = false
    
    @Published var characters: [Character] = []
    
    @Published var character1ID: String
    @Published var character2ID: String
    @Published var attackingCharacterID: String = ""
    
    @Published var fight: Fight = Fight(fightID: "", userID: "", character1ID: "", character2ID: "", outcomes: nil, winner: "", complete: false)
    
    @Published var currentAttackerRoundOutcome: String = ""
    @Published var currentDefenderRoundOutcome: String = ""
    
    @Published var showOutcomeStr: String = ""
    @Published var showOutcome: Bool = false
    
    @Published var character1: Character = Character(characterID: "", creatorID: "", characterName: "", characterDescription: "", stats: Stats(health: 0, attack: 0, defense: 0, speed: 0, agility: 0, hp: 0), isPlayer: false, heldItem: "", iconURL: "", alive: false)
    @Published var character2: Character = Character(characterID: "", creatorID: "", characterName: "", characterDescription: "", stats: Stats(health: 0, attack: 0, defense: 0, speed: 0, agility: 0, hp: 0), isPlayer: false, heldItem: "", iconURL: "", alive: false)
        
    @Published var outcomes: [String] = []
    
    @Published var fightOngoing = false
    
    init() {
        self.character1ID = ""
        self.character2ID = ""
        // need to call updateCharacters() when characters are changed, so that the two character refs
        // are still accurate even if they are changed somewhere else in the app
        characterModel.$currentCharacters
            .sink { [weak self] newChars in
                self?.characters = newChars
                self?.updateCharacters() }
            .store(in: &cancellables)
    }
    
    func shouldStart() -> Bool {
        
        let char1Alive = characterModel.getCharacter(for: character1ID)?.alive
        let char2Alive = characterModel.getCharacter(for: character2ID)?.alive

        if character1ID == "" || character2ID == "" || character1ID == character2ID {
            return false
        } else if char1Alive != nil && char2Alive != nil {
            if !char1Alive! || !char2Alive! {
                return false
            }
        }
        return true
    }
    
    func itemIdToItemName(itemID: String) -> String {
        guard let itemName = itemModel.getItemName(for: itemID) else {
            print("Item name not found for \(itemID)")
            return "nothing"
        }
        return itemName
    }
    
    func getItemType(itemID: String) -> String {
        guard let item = itemModel.getItem(for: itemID) else {
            print("Item not found for \(itemID)")
            return "unknown"
        }
        return item.type
    }
    
    func updateCharacters () { // update references to the two selected characters, including truncated stats
        if let char1 = characters.first(where: { $0.characterID == character1ID }),
           let char2 = characters.first(where: { $0.characterID == character2ID }) {
            character1 = char1
            character2 = char2
            character1.stats = getTruncatedStats(character: char1)
            character2.stats = getTruncatedStats(character: char2)
        }
    }
    
    func startFight() {
        
        fightOngoing = true // for fight view
        
        updateCharacters() // get initial references to the two selected characters
        fight = Fight(fightID: idWithTimeInterval(), userID: userModel.currentUser!.uid, character1ID: character1ID, character2ID: character2ID, winner: "", complete: false)
        fightModel.startFight(fight: fight) // create the fight in firebase
        
        // whoever is faster moves first
        if (character2.stats.speed > character1.stats.speed) {
            attackingCharacterID = character2ID
        } else {
            attackingCharacterID = character1ID
        }
        
    }
    
    func fleeAction() {
        
        // set up temp vars
        var attackingChar: Character = character1
        var defendingChar: Character = character2
        if (attackingCharacterID == character2ID) {
            attackingChar = character2
            defendingChar = character1
        }
        
        currentAttackerRoundOutcome = fightModel.getOutcomeString(type: OutcomeType.attackerFlee, attackerName: attackingChar.characterName, defenderName: defendingChar.characterName, impact: "", itemName: "")
        currentDefenderRoundOutcome = fightModel.getOutcomeString(type: OutcomeType.defenderIdle, attackerName: attackingChar.characterName, defenderName: defendingChar.characterName, impact: "", itemName: "")
        
        fightModel.setWinner(fightID: fight.fightID, winnerID: character2.characterID)
        
        swap()
        
        finishAction()
        stopFight()
        
    }
    
    func attackAction() {
        
        isWorking = true
        
        // set up temp vars
        var attackingChar: Character = character1
        var defendingChar: Character = character2
        if (attackingCharacterID == character2ID) {
            attackingChar = character2
            defendingChar = character1
        }
        
        let damage = calculateDamage(attacker: attackingChar, defender: defendingChar)
        
        let avoidChance = calcAvoidChance(attacker: attackingChar, defender: defendingChar)
        let tryAvoid = Int.random(in: 0...100)
        
        if (tryAvoid < avoidChance) { // defender avoids attack
            
            currentAttackerRoundOutcome = fightModel.getOutcomeString(type: OutcomeType.attackerAttack, attackerName: attackingChar.characterName, defenderName: defendingChar.characterName, impact: String(damage), itemName: "")
            currentDefenderRoundOutcome = fightModel.getOutcomeString(type: OutcomeType.defenderAvoid, attackerName: attackingChar.characterName, defenderName: defendingChar.characterName, impact: String(damage), itemName: "")
            
        } else { // defender is hit
                        
            defendingChar.stats.hp -= damage
            if (defendingChar.stats.hp < 0) {
                defendingChar.stats.hp = 0
            }
            
            currentAttackerRoundOutcome = fightModel.getOutcomeString(type: OutcomeType.attackerAttack, attackerName: attackingChar.characterName, defenderName: defendingChar.characterName, impact: String(damage), itemName: "")
            currentDefenderRoundOutcome = fightModel.getOutcomeString(type: OutcomeType.defenderGetHit, attackerName: attackingChar.characterName, defenderName: defendingChar.characterName, impact: String(damage), itemName: "")
            
            // apply changes
            if (attackingCharacterID == character1ID) {
                character1 = attackingChar
                character2 = defendingChar
            } else {
                character1 = defendingChar
                character2 = attackingChar
            }
            
        }
        
        swap()
        
        finishAction()
        
        if !checkDeath() {
            self.showOutcome = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.isWorking = false
        }
        
    }
    
    func consumeItemAction() {
        
        isWorking = true
        
        var attackingChar: Character = character1
        var defendingChar: Character = character2
        if (attackingCharacterID == character2ID) {
            attackingChar = character2
            defendingChar = character1
        }
        
        if let item = itemModel.getItem(for: itemToConsume) {
            
            var plusMinus: String = "+"
            if (item.impact < 0) {
                plusMinus = ""
            }
            
            let impactStr = "\(plusMinus)\(item.impact) \(item.impactsWhat)"
            
            consumeItem(item:item,characterID:attackingChar.characterID)

            currentAttackerRoundOutcome = fightModel.getOutcomeString(type: OutcomeType.attackerUsesItem, attackerName: attackingChar.characterName, defenderName: defendingChar.characterName, impact: impactStr, itemName: item.itemName)
            currentDefenderRoundOutcome = fightModel.getOutcomeString(type: OutcomeType.defenderIdle, attackerName: attackingChar.characterName, defenderName: defendingChar.characterName, impact: impactStr, itemName: item.itemName)
            
        }
        
        else {
           
            currentAttackerRoundOutcome = "\(attackingChar.characterName) tries to use item."
            currentDefenderRoundOutcome = "\(defendingChar.characterName) idles."
            
        }
        
        swap()
        
        finishAction()
        
        if !checkDeath() {
            self.showOutcome = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.isWorking = false
        }
        
    }
    
    func passAction() {
        
        isWorking = true
        
        var attackingChar: Character = character1
        var defendingChar: Character = character2
        if (attackingCharacterID == character2ID) {
            attackingChar = character2
            defendingChar = character1
        }
        
        currentAttackerRoundOutcome = fightModel.getOutcomeString(type: OutcomeType.attackerPass, attackerName: attackingChar.characterName, defenderName: defendingChar.characterName, impact: "", itemName: "")
        currentDefenderRoundOutcome = fightModel.getOutcomeString(type: OutcomeType.defenderIdle, attackerName: attackingChar.characterName, defenderName: defendingChar.characterName, impact: "", itemName: "")
        
        swap()
        
        finishAction()
        
        self.showOutcome = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.isWorking = false
        }
        
    }
    
    // called at end of each action
    func finishAction() {
                
        showOutcomeStr = "\(currentAttackerRoundOutcome)\n\(currentDefenderRoundOutcome)"
        //showOutcome = true
                                
        fightModel.addOutcomesToFight(fightID: fight.fightID, outcome1: currentAttackerRoundOutcome, outcome2: currentDefenderRoundOutcome)
        currentAttackerRoundOutcome = ""
        currentDefenderRoundOutcome = ""
        itemToConsume = ""
        
        characterModel.updateCharacter(character: character1)
        characterModel.updateCharacter(character: character2)
        
    }
    
    func stopFight() {
        
        fightOngoing = false // for fight view
        
        // set fight to complete
        fightModel.endFight(fightID: fight.fightID)
        
        // reset view model vars
        fight = Fight(fightID: "", userID: "", character1ID: "", character2ID: "", outcomes: nil, winner: "", complete: false)
        attackingCharacterID = ""
        character1ID = ""
        character2ID = ""
        
    }
    
    func checkDeath() -> Bool {
        
        if character1.stats.hp <= 0 {
            character1.alive = false
            characterModel.updateCharacter(character: character1)
            fightModel.setWinner(fightID: fight.fightID, winnerID: character2.characterID)
            stopFight()
            return true
        }
        
        else if character2.stats.hp <= 0 {
            character2.alive = false
            characterModel.updateCharacter(character: character2)
            fightModel.setWinner(fightID: fight.fightID, winnerID: character1.characterID)
            stopFight()
            return true
        }
        
        return false
        
    }
    
    func consumeItem(item: Item, characterID: String) {
        
        characterModel.consumeItem(characterID: characterID, itemID: itemToConsume)
        
        if (item.impactsWhat == "none" || item.impact == 0) { // no impact
            print("item has no impact")
            return
        }
        
        else {
            
            let updateCharacter = applyStatChangesWithTruncation(characterID: characterID, itemID: item.itemID)
                        
            if character1ID == attackingCharacterID {
                character1 = updateCharacter
            } else {
                character2 = updateCharacter
            }

        }
        
    }
    
    // TEMP FORMULA
    func calculateDamage(attacker: Character, defender: Character) -> Int {
        var damage = max(0, (attacker.stats.attack - defender.stats.defense) / 2)
        let randomFactor = Double.random(in: 0.8...1.2)
        damage = Int(Double(damage) * randomFactor)
        return max(damage, 1)
    }
    
    // TEMP FORMULA
    func calcAvoidChance(attacker: Character, defender: Character) -> Int {
        guard attacker.stats.agility + defender.stats.agility > 0 else {
            return 0
        }
        let avoidChance = Double(defender.stats.agility) / Double(attacker.stats.agility + defender.stats.agility) * 0.5 * 100
        return Int(avoidChance)
    }
    
    func swap() {
        if (attackingCharacterID == character1ID) {
            attackingCharacterID = character2ID
        } else {
            attackingCharacterID = character1ID
        }
    }
    
    func character1Attacking() -> Bool {
        return character1ID == attackingCharacterID
    }
    func character2Attacking() -> Bool {
        return character2ID == attackingCharacterID
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
        
}
