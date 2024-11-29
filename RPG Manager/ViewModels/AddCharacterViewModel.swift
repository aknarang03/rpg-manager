//
//  AddCharacterViewModel.swift
//  RPG Manager
//
//  Created by Anjali Narang  on 11/20/24.
//


import Foundation

class AddCharacterViewModel: ObservableObject {
    
    let storyModel = StoryModel.shared
    let userModel = UserModel.shared
    
    @Published var characterName: String = ""
    @Published var characterDescription: String = ""
    @Published var health: Float = 0
    @Published var attack: Float = 0
    @Published var defense: Float = 0
    @Published var speed: Float = 0
    @Published var agility: Float = 0
    @Published var isPlayer: String = "true"

    func timeInterval() -> String {
        let timeNow = Date()
        var timeStr = String(timeNow.timeIntervalSince1970)
        timeStr = timeStr.replacingOccurrences(of: ".", with: "")
        return timeStr
    }
    
    func addCharacter() {
        
        if (characterName == "" || isPlayer == "") {
            print("cannot add empty character name or isplayer")
            return
        }
        
        let healthVal = Int(health)
        let attackVal = Int(attack)
        let defenseVal = Int(defense)
        let speedVal = Int(speed)
        let agilityVal = Int(agility)
        
        var playerbool = false
        if (isPlayer == "false") { playerbool = false } else { playerbool = true }
        
        let newCharacter = Character(characterID: timeInterval(), creatorID: userModel.currentUser!.uid, characterName: characterName, characterDescription: characterDescription, stats: Stats(health: healthVal, attack: attackVal, defense: defenseVal, speed: speedVal, agility: agilityVal, hp: healthVal), bag: [:], isPlayer: playerbool, heldItem: "", iconURL: "")
        storyModel.addCharacterToStory(storyID: storyModel.currentStory!.storyID, character: newCharacter)

    }

}
