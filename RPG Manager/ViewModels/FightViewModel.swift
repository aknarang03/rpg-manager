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

    init() {
        self.character1ID = ""
        self.character2ID = ""
        characterModel.$currentCharacters
            .sink { [weak self] newChars in
                self?.characters = newChars
                self?.updateCharacters() }
            .store(in: &cancellables)
    }
    
    func itemIdToItemName(itemID: String) -> String {
        guard let itemName = itemModel.getItemName(for: itemID) else {
            print("Item name not found for \(itemID)")
            return "nothing" // default item name
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
    
    func stopFight() {
        
        // set fight to complete
        fightModel.endFight(fightID: fight.fightID)
        
        // reset view model vars
        fight = Fight(fightID: "", userID: "", character1ID: "", character2ID: "", outcomes: nil, winner: "", complete: false)
        attackingCharacterID = ""
        character1ID = ""
        character2ID = ""
        
    }
    
    func startFight() {
        
        updateCharacters()
        fight = Fight(fightID: idWithTimeInterval(), userID: userModel.currentUser!.uid, character1ID: character1ID, character2ID: character2ID, winner: "", complete: false)
        fightModel.startFight(fight: fight)
        
        if (character2.stats.speed > character1.stats.speed) {
            attackingCharacterID = character2ID
        } else {
            attackingCharacterID = character1ID
        }
        
    }
    
    func fleeAction() {
                
        if (attackingCharacterID == character1ID) { // character 1 is attacking; character 2 is defending
            
            currentAttackerRoundOutcome = fightModel.getOutcomeString(type: OutcomeType.attackerFlee, attackerName: character1.characterName, defenderName: character2.characterName, impact: "", itemName: "")
            currentDefenderRoundOutcome = fightModel.getOutcomeString(type: OutcomeType.defenderIdle, attackerName: character1.characterName, defenderName: character2.characterName, impact: "", itemName: "")
            
            let out1 = "\(character2.characterName) wins."
            let out2 = "\(character1.characterName) loses." // character 1 loses because they fled
            fightModel.addOutcomesToFight(fightID: fight.fightID, outcome1: out1, outcome2: out2)
            fightModel.setWinner(fightID: fight.fightID, winnerID: character2.characterID)
            
        } else { // character 2 is attacking; character 1 is defending
            
            currentAttackerRoundOutcome = fightModel.getOutcomeString(type: OutcomeType.attackerFlee, attackerName: character2.characterName, defenderName: character1.characterName, impact: "", itemName: "")
            currentDefenderRoundOutcome = fightModel.getOutcomeString(type: OutcomeType.defenderIdle, attackerName: character2.characterName, defenderName: character1.characterName, impact: "", itemName: "")
            
            let out1 = "\(character1.characterName) wins."
            let out2 = "\(character2.characterName) loses." // character 2 loses because they fled
            fightModel.addOutcomesToFight(fightID: fight.fightID, outcome1: out1, outcome2: out2)
            fightModel.setWinner(fightID: fight.fightID, winnerID: character1.characterID)
            
        }
        
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
        self.showOutcome = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.isWorking = false
        }
        
    }
    
    func consumeItemAction() {
        
        isWorking = true
        
        if let item = itemModel.getItem(for: itemToConsume) {
            
            var plusMinus: String = "+"
            if (item.impact < 0) {
                plusMinus = ""
            }
            
            let impactStr = "\(plusMinus)\(item.impact) \(item.impactsWhat)"
            
            // I should just set temp attacker and defender name vars based on check instead of doing everything in the check. too much duplicate code
            
            if (attackingCharacterID == character1ID) { // character 1 is consuming item; character 2 is idling
                
                consumeItem(item:item,characterID:character1ID)
                
                currentAttackerRoundOutcome = fightModel.getOutcomeString(type: OutcomeType.attackerUsesItem, attackerName: character1.characterName, defenderName: character2.characterName, impact: impactStr, itemName: item.itemName)
                currentDefenderRoundOutcome = fightModel.getOutcomeString(type: OutcomeType.defenderIdle, attackerName: character1.characterName, defenderName: character2.characterName, impact: impactStr, itemName: item.itemName)
                
            } else { // character 2 is consuming item; character 1 is idling
                
                consumeItem(item:item,characterID:character2ID)

                currentAttackerRoundOutcome = fightModel.getOutcomeString(type: OutcomeType.attackerUsesItem, attackerName: character2.characterName, defenderName: character1.characterName, impact: impactStr, itemName: item.itemName)
                currentDefenderRoundOutcome = fightModel.getOutcomeString(type: OutcomeType.defenderIdle, attackerName: character2.characterName, defenderName: character1.characterName, impact: impactStr, itemName: item.itemName)
                
            }
            
        }
        
        else {
            
            if (attackingCharacterID == character1ID) {
                currentAttackerRoundOutcome = "\(character1.characterName) tries to use item."
                currentDefenderRoundOutcome = "\(character2.characterName) idles."
            } else {
                currentAttackerRoundOutcome = "\(character2.characterName) tries to use item."
                currentDefenderRoundOutcome = "\(character1.characterName) idles."
            }
            
        }
        
        swap()
        
        finishAction()
        self.showOutcome = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.isWorking = false
        }
        
    }
    
    func passAction() {
        
        // I should just set temp attacker and defender name vars based on check instead of doing everything in the check. too much duplicate code
        
        isWorking = true
            
        if (attackingCharacterID == character1ID) {
            
            currentAttackerRoundOutcome = fightModel.getOutcomeString(type: OutcomeType.attackerPass, attackerName: character1.characterName, defenderName: character2.characterName, impact: "", itemName: "")
            currentDefenderRoundOutcome = fightModel.getOutcomeString(type: OutcomeType.defenderIdle, attackerName: character1.characterName, defenderName: character2.characterName, impact: "", itemName: "")
            
        } else {
            
            currentAttackerRoundOutcome = fightModel.getOutcomeString(type: OutcomeType.attackerPass, attackerName: character2.characterName, defenderName: character1.characterName, impact: "", itemName: "")
            currentDefenderRoundOutcome = fightModel.getOutcomeString(type: OutcomeType.defenderIdle, attackerName: character2.characterName, defenderName: character1.characterName, impact: "", itemName: "")
            
        }
        
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
        
        
        // check for alive for both characters
        
        // I should just set temp attacker and defender name vars based on check instead of doing everything in the check. too much duplicate code
        
        if character1.stats.hp == 0 {
            
            character1.alive = false
            characterModel.updateCharacter(character: character1)
            
            let out1 = "\(character2.characterName) wins."
            let out2 = "\(character1.characterName) loses."
            
            fightModel.addOutcomesToFight(fightID: fight.fightID, outcome1: out1, outcome2: out2)
            fightModel.setWinner(fightID: fight.fightID, winnerID: character2.characterID)
            stopFight()
            
        }
        
        else if character2.stats.hp == 0 {
            
            character2.alive = false
            characterModel.updateCharacter(character: character2)
            
            let out1 = "\(character1.characterName) wins."
            let out2 = "\(character2.characterName) loses."
            
            fightModel.addOutcomesToFight(fightID: fight.fightID, outcome1: out1, outcome2: out2)
            fightModel.setWinner(fightID: fight.fightID, winnerID: character1.characterID)
            stopFight()
            
        }

    }
    
    func swap() {
        if (attackingCharacterID == character1ID) {
            attackingCharacterID = character2ID
        } else {
            attackingCharacterID = character1ID
        }
    }
    
    
    
    func consumeItem(item: Item, characterID: String) {
        
        characterModel.consumeItem(characterID: characterID, itemID: itemToConsume)
        
        if (item.impactsWhat == "none" || item.impact == 0) { // no impact
            print("item has no impact")
            return
        }
        
        else {
            
            //var updateCharacter = characterModel.getCharacter(for: characterID)
            //print("id for update character: \(characterID)")
            
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
    
    func character1Attacking() -> Bool {
        return character1ID == attackingCharacterID
    }
    func character2Attacking() -> Bool {
        return character2ID == attackingCharacterID
    }
        
}
