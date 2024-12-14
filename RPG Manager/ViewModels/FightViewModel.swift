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
    @Published var character1Stats: Stats
    
    @Published var character2ID: String
    @Published var character2Stats: Stats
    
    @Published var attackingCharacterID: String = ""
    
    @Published var fight: Fight = Fight(fightID: "", userID: "", character1ID: "", character2ID: "", outcomes: nil, winner: "", complete: false)
    
    @Published var currentAttackerRoundOutcome: String = ""
    @Published var currentDefenderRoundOutcome: String = ""
    
    @Published var showOutcomeStr: String = ""
    @Published var showOutcome: Bool = false
    
    @Published var character1: Character = Character(characterID: "", creatorID: "", characterName: "", characterDescription: "", stats: Stats(health: 0, attack: 0, defense: 0, speed: 0, agility: 0, hp: 0), isPlayer: false, heldItem: "", iconURL: "", alive: false)
    @Published var character2: Character = Character(characterID: "", creatorID: "", characterName: "", characterDescription: "", stats: Stats(health: 0, attack: 0, defense: 0, speed: 0, agility: 0, hp: 0), isPlayer: false, heldItem: "", iconURL: "", alive: false)
        
    //@Published var outcomes: [String] = []
    
    @Published var fightOngoing = false
    
    init() {
        self.character1ID = ""
        self.character2ID = ""
        // use real stats when updating stats, but use these when calculating and showing things
        self.character1Stats = Stats(health: 0, attack: 0, defense: 0, speed: 0, agility: 0, hp: 0)
        self.character2Stats = Stats(health: 0, attack: 0, defense: 0, speed: 0, agility: 0, hp: 0)
        // need to call updateCharacters() when characters are changed, so that the two character refs are still accurate even if they are changed somewhere else in the app
        characterModel.$currentCharacters
            .sink { [weak self] newChars in
                self?.characters = newChars
                self?.updateCharacters() }
            .store(in: &cancellables)
        NotificationCenter.default.addObserver(self, selector: #selector(handleResumeFight(notification:)), name: Notification.Name("resumeFight"), object: nil)
    }
    
    @objc private func handleResumeFight(notification: Notification) {
        if let fight = notification.object as? Fight {
            self.character1ID = fight.character1ID
            self.character2ID = fight.character2ID
            if shouldStart() {
                startOngoingFight(fightID: fight.fightID)
            } else {
                self.character1ID = ""
                self.character2ID = ""
            }
        }
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
    
    func getItem(itemID: String) -> Item {
        guard let item = itemModel.getItem(for: itemID) else {
            print("Item not found for \(itemID)")
            return Item(itemID: "", creatorID: "", itemName: "", itemDescription: "", impactsWhat: "", impact: 0, type: "", iconURL: "")
        }
        return item
    }
    
    func updateCharacters () { // update references to the two selected characters, including truncated stats
        if let char1 = characters.first(where: { $0.characterID == character1ID }),
           let char2 = characters.first(where: { $0.characterID == character2ID }) {
            character1 = char1
            character2 = char2
            character1Stats = getTruncatedStats(character: char1)
            character2Stats = getTruncatedStats(character: char2)
            print("TEST: fight stats 1: \(character1Stats.attack), real stats: \(character1.stats.attack)")
            print("TEST: fight stats 2: \(character2Stats.attack), real stats: \(character2.stats.attack)")
            //character1.stats = getTruncatedStats(character: char1)
            //character2.stats = getTruncatedStats(character: char2)
        }
    }
    
    func startOngoingFight(fightID: String) {
        
        if let fight = fightModel.getFight(for: fightID) {
            
            self.fight = fight
            
            fightOngoing = true // for fight view
            
            updateCharacters() // get initial references to the two selected characters
            
            // whoever is faster moves first
            if (character2Stats.speed > character1Stats.speed) {
                attackingCharacterID = character2ID
            } else {
                attackingCharacterID = character1ID
            }

        }
        
        // if fight DNE, don't do anything, just show default screen. fightOngoing will be false so that's what would happen
        
    }
    
    func startFight() {
        
        fightOngoing = true // for fight view
        
        updateCharacters() // get initial references to the two selected characters
        fight = Fight(fightID: idWithTimeInterval(), userID: userModel.currentUser!.uid, character1ID: character1ID, character2ID: character2ID, winner: "", complete: false)
        fightModel.startFight(fight: fight) // create the fight in firebase
        
        // whoever is faster moves first
        if (character2Stats.speed > character1Stats.speed) {
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
        
        finishAction(updateChar: false)
        stopFight()
        
    }
    
    func attackAction() {
        
        isWorking = true
        
        // set up temp vars
        var attackingChar: Character = character1
        var attackingCharStats: Stats = character1Stats
        var defendingChar: Character = character2
        var defendingCharStats: Stats = character2Stats
        if (attackingCharacterID == character2ID) {
            attackingChar = character2
            attackingCharStats = character2Stats
            defendingChar = character1
            defendingCharStats = character1Stats
        }
        
        let damage = calculateDamage(attackerStats: attackingCharStats, defenderStats: defendingCharStats)
        
        let avoidChance = calcAvoidChance(attackerStats: attackingCharStats, defenderStats: defendingCharStats)
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
        
        finishAction(updateChar: true)
        
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
        
        finishAction(updateChar: true)
        
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
        
        finishAction(updateChar: false)
        
        self.showOutcome = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.isWorking = false
        }
        
    }
    
    // called at end of each action
    func finishAction(updateChar: Bool) {
                
        showOutcomeStr = "\(currentAttackerRoundOutcome)\n\(currentDefenderRoundOutcome)"
                                
        fightModel.addOutcomesToFight(fightID: fight.fightID, outcome1: currentAttackerRoundOutcome, outcome2: currentDefenderRoundOutcome)
        currentAttackerRoundOutcome = ""
        currentDefenderRoundOutcome = ""
        itemToConsume = ""
        
        if updateChar { // if the action should trigger an update, i.e. stats were changed
            characterModel.updateCharacter(character: character1)
            characterModel.updateCharacter(character: character2)
        }
        
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
        
        print("character 1: fight hp \(character1Stats.hp), real hp: \(character1.stats.hp)")
        print("character 2: fight hp \(character2Stats.hp), real hp: \(character2.stats.hp)")

        
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
    func calculateDamage(attackerStats: Stats, defenderStats: Stats) -> Int {
        var damage = max(0, (attackerStats.attack - defenderStats.defense) / 2)
        let randomFactor = Double.random(in: 0.8...1.2)
        damage = Int(Double(damage) * randomFactor)
        return max(damage, 1)
    }
    
    // TEMP FORMULA
    func calcAvoidChance(attackerStats: Stats, defenderStats: Stats) -> Int {
        guard attackerStats.agility + defenderStats.agility > 0 else {
            return 0
        }
        let avoidChance = Double(defenderStats.agility) / Double(attackerStats.agility + defenderStats.agility) * 0.5 * 100
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
