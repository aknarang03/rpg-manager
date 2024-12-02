//
//  applyStatChanges.swift
//  RPG Manager
//
//  Created by Anjali Narang  on 12/2/24.
//

let characterModel = CharacterModel.shared
let itemModel = ItemModel.shared

func applyStatChangesWithTruncation(characterID: String, itemID: String) -> Character{
    
    var updateCharacter = characterModel.getCharacter(for: characterID)
    let item = itemModel.getItem(for: itemID)
    
    switch item?.impactsWhat {
        
    case "health":
        updateCharacter!.stats.health += item!.impact
        if (updateCharacter!.stats.health > 100) {
            updateCharacter!.stats.health = 100
        }
        else if (updateCharacter!.stats.health < 0) {
            updateCharacter!.stats.health = 0
        }
        if (updateCharacter!.stats.hp > updateCharacter!.stats.health) {
            updateCharacter!.stats.hp = updateCharacter!.stats.health
        }
        print("item impacts health: \(item?.impact ?? 0)")
    case "attack":
        updateCharacter!.stats.attack += item!.impact
        if (updateCharacter!.stats.attack > 100) {
            updateCharacter!.stats.attack = 100
        }
        else if (updateCharacter!.stats.attack < 0) {
            updateCharacter!.stats.attack = 0
        }
        print("item impacts attack: \(item?.impact ?? 0)")
    case "defense":
        updateCharacter!.stats.defense += item!.impact
        if (updateCharacter!.stats.defense > 100) {
            updateCharacter!.stats.defense = 100
        }
        else if (updateCharacter!.stats.defense < 0) {
            updateCharacter!.stats.defense = 0
        }
        print("item impacts defense: \(item?.impact ?? 0)")
    case "speed":
        updateCharacter!.stats.speed += item!.impact
        if (updateCharacter!.stats.speed > 100) {
            updateCharacter!.stats.speed = 100
        }
        else if (updateCharacter!.stats.speed < 0) {
            updateCharacter!.stats.speed = 0
        }
        print("item impacts speed: \(item?.impact ?? 0)")
    case "agility":
        updateCharacter!.stats.agility += item!.impact
        if (updateCharacter!.stats.agility > 100) {
            updateCharacter!.stats.agility = 100
        }
        else if (updateCharacter!.stats.agility < 0) {
            updateCharacter!.stats.agility = 0
        }
        print("item impacts agility: \(item?.impact ?? 0)")
    case "hp":
        updateCharacter!.stats.hp += item!.impact
        if (updateCharacter!.stats.hp > updateCharacter!.stats.health) {
            updateCharacter!.stats.hp = updateCharacter!.stats.health
        }
        else if (updateCharacter!.stats.hp < 0) {
            updateCharacter!.stats.hp = 0
        }
        print("item impacts hp: \(item?.impact ?? 0)")
    default:
        print("unhandled impact type: \(item?.impactsWhat ?? "unknown")")
    }
    
    return updateCharacter!
    
}
