//
//  AddCharacterViewModel.swift
//  RPG Manager
//
//  Created by Anjali Narang  on 11/20/24.
//


import Foundation

class AddCharacterViewModel: ObservableObject {
    
    let userModel = UserModel.shared
    let characterModel = CharacterModel.shared
    
    @Published var characterName: String = ""
    @Published var characterDescription: String = ""
    @Published var health: Float = 0
    @Published var attack: Float = 0
    @Published var defense: Float = 0
    @Published var speed: Float = 0
    @Published var agility: Float = 0
    @Published var isPlayer: String = "true"
    
    func addCharacter() {
        
        let healthVal = Int(health)
        let attackVal = Int(attack)
        let defenseVal = Int(defense)
        let speedVal = Int(speed)
        let agilityVal = Int(agility)
        
        var playerbool = false
        if (isPlayer == "false") { playerbool = false } else { playerbool = true }
        
        let newCharacter = Character(characterID: idWithTimeInterval(), creatorID: userModel.currentUser!.uid, characterName: characterName, characterDescription: characterDescription, stats: Stats(health: healthVal, attack: attackVal, defense: defenseVal, speed: speedVal, agility: agilityVal, hp: healthVal), bag: [:], isPlayer: playerbool, heldItem: "", iconURL: "", alive: true)
        characterModel.addCharacterToStory(character: newCharacter)

    }

}
