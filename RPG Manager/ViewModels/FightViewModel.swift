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
    
    @Published var showCharacterBag: Bool = false
    @Published var itemToConsume: String = ""
    
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
    
    func itemIdToItemName(itemID: String) -> String {
        guard let itemName = storyModel.getItemName(for: itemID) else {
            print("Item name not found for \(itemID)")
            return "Unknown" // default item name
        }
        return itemName
    }
    
    func getItemType(itemID: String) -> String {
        guard let item = storyModel.getItem(for: itemID) else {
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
        
        // NOTE TO SELF: should truncate defender hp at 0
        
        let DAMAGE_TEST = 20
        
        if (attackingCharacterID == character1ID) { // character 1 is attacking; character 2 is defending
            
            character2.stats.hp -= DAMAGE_TEST
            if (character2.stats.hp < 0) {
                character2.stats.hp = 0
            }
            
            currentAttackerRoundOutcome = storyModel.getOutcomeString(type: OutcomeType.attackerAttack, attackerName: character1.characterName, defenderName: character2.characterName, impact: String(DAMAGE_TEST), itemName: "")
            currentDefenderRoundOutcome = storyModel.getOutcomeString(type: OutcomeType.defenderGetHit, attackerName: character1.characterName, defenderName: character2.characterName, impact: String(DAMAGE_TEST), itemName: "")
            
        } else { // character 2 is attacking; character 1 is defending
            
            character1.stats.hp -= DAMAGE_TEST
            if (character1.stats.hp < 0) {
                character1.stats.hp = 0
            }
            
            currentAttackerRoundOutcome = storyModel.getOutcomeString(type: OutcomeType.attackerAttack, attackerName: character2.characterName, defenderName: character1.characterName, impact: String(DAMAGE_TEST), itemName: "")
            currentDefenderRoundOutcome = storyModel.getOutcomeString(type: OutcomeType.defenderGetHit, attackerName: character2.characterName, defenderName: character1.characterName, impact: String(DAMAGE_TEST), itemName: "")
            
        }
        
        if (attackingCharacterID == character1ID) {
            attackingCharacterID = character2ID
        } else {
            attackingCharacterID = character1ID
        }
        
        finishAction()
        
    }
    
    func consumeItemAction() {
        
        if let item = storyModel.getItem(for: itemToConsume) {
            
            var plusMinus: String = "+"
            if (item.impact < 0) {
                plusMinus = ""
            }
            
            let impactStr = "\(plusMinus)\(item.impact) \(item.impactsWhat)"
            
            if (attackingCharacterID == character1ID) { // character 1 is consuming item; character 2 is idling
                
                consumeItem(item:item,characterID:character1ID)
                
                currentAttackerRoundOutcome = storyModel.getOutcomeString(type: OutcomeType.attackerUsesItem, attackerName: character1.characterName, defenderName: character2.characterName, impact: impactStr, itemName: item.itemName)
                currentDefenderRoundOutcome = storyModel.getOutcomeString(type: OutcomeType.defenderIdle, attackerName: character1.characterName, defenderName: character2.characterName, impact: impactStr, itemName: item.itemName)
                
            } else { // character 2 is consuming item; character 1 is idling
                
                consumeItem(item:item,characterID:character2ID)

                currentAttackerRoundOutcome = storyModel.getOutcomeString(type: OutcomeType.attackerUsesItem, attackerName: character2.characterName, defenderName: character1.characterName, impact: impactStr, itemName: item.itemName)
                currentDefenderRoundOutcome = storyModel.getOutcomeString(type: OutcomeType.defenderIdle, attackerName: character2.characterName, defenderName: character1.characterName, impact: impactStr, itemName: item.itemName)
                
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
        
        if (attackingCharacterID == character1ID) {
            attackingCharacterID = character2ID
        } else {
            attackingCharacterID = character1ID
        }
        
        finishAction()
        
    }
    
    // called at end of each action (attacker outcome, defender outcome)
    func finishAction() {
        
        print("in finish outcome")
                                
        storyModel.addOutcomesToFight(storyID: storyModel.currentStory!.storyID, fightID: fight.fightID, outcome1: currentAttackerRoundOutcome, outcome2: currentDefenderRoundOutcome)
        currentAttackerRoundOutcome = ""
        currentDefenderRoundOutcome = ""
        itemToConsume = ""
        
        storyModel.updateCharacter(storyID: storyModel.currentStory!.storyID, character: character1)
        storyModel.updateCharacter(storyID: storyModel.currentStory!.storyID, character: character2)
        
    }
    // NOTE: rounds are just two outcomes, which is the result of one action. rounds are not stored in database; they will just be displayed as such in the UI.
    
    // END FIGHT:
    // surrender(which character)
    // lose(which character)
    
    
    
    
    func consumeItem(item: Item, characterID: String) {
        
        storyModel.consumeItem(storyID: storyModel.currentStory!.storyID, characterID: characterID, itemID: itemToConsume)
        
        if (item.impactsWhat == "none" || item.impact == 0) { // no impact
            print("item has no impact")
            return
        }
        
        else {
            
            var updateCharacter = storyModel.getCharacter(for: characterID)
            print("id for update character: \(characterID)")
            
            // make an update stats method.. this is very messy
            
            switch item.impactsWhat {
            case "health":
                updateCharacter!.stats.health += item.impact
                if (updateCharacter!.stats.health > 100) {
                    updateCharacter!.stats.health = 100
                }
                else if (updateCharacter!.stats.health < 0) {
                    updateCharacter!.stats.health = 0
                }
                if (updateCharacter!.stats.hp > updateCharacter!.stats.health) {
                    updateCharacter!.stats.hp = updateCharacter!.stats.health
                }
                print("item impacts health: \(item.impact)")
            case "attack":
                updateCharacter!.stats.attack += item.impact
                if (updateCharacter!.stats.attack > 100) {
                    updateCharacter!.stats.attack = 100
                }
                else if (updateCharacter!.stats.attack < 0) {
                    updateCharacter!.stats.attack = 0
                }
                print("item impacts attack: \(item.impact)")
            case "defense":
                updateCharacter!.stats.defense += item.impact
                if (updateCharacter!.stats.defense > 100) {
                    updateCharacter!.stats.defense = 100
                }
                else if (updateCharacter!.stats.defense < 0) {
                    updateCharacter!.stats.defense = 0
                }
                print("item impacts defense: \(item.impact)")
            case "speed":
                updateCharacter!.stats.speed += item.impact
                if (updateCharacter!.stats.speed > 100) {
                    updateCharacter!.stats.speed = 100
                }
                else if (updateCharacter!.stats.speed < 0) {
                    updateCharacter!.stats.speed = 0
                }
                print("item impacts speed: \(item.impact)")
            case "agility":
                updateCharacter!.stats.agility += item.impact
                if (updateCharacter!.stats.agility > 100) {
                    updateCharacter!.stats.agility = 100
                }
                else if (updateCharacter!.stats.agility < 0) {
                    updateCharacter!.stats.agility = 0
                }
                print("item impacts agility: \(item.impact)")
            case "hp":
                updateCharacter!.stats.hp += item.impact
                if (updateCharacter!.stats.hp > updateCharacter!.stats.health) {
                    updateCharacter!.stats.hp = updateCharacter!.stats.health
                }
                else if (updateCharacter!.stats.hp < 0) {
                    updateCharacter!.stats.hp = 0
                }
                print("item impacts hp: \(item.impact)")
            default:
                print("unhandled impact type: \(item.impactsWhat)")
            }
                        
            if character1ID == attackingCharacterID {
                character1 = updateCharacter!
            } else {
                character2 = updateCharacter!
            }

        }
    }
        
}
