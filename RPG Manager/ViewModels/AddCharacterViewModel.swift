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
    @Published var health: String = ""
    @Published var attack: String = ""
    @Published var defense: String = ""
    @Published var speed: String = ""
    @Published var agility: String = ""

    func timeInterval() -> String {
        let timeNow = Date()
        var timeStr = String(timeNow.timeIntervalSince1970)
        timeStr = timeStr.replacingOccurrences(of: ".", with: "")
        return timeStr
    }
    
    func addCharacter() {
        
        let healthVal = Int(health) ?? 0
        let attackVal = Int(attack) ?? 0
        let defenseVal = Int(defense) ?? 0
        let speedVal = Int(speed) ?? 0
        let agilityVal = Int(agility) ?? 0
        
        let newCharacter = Character(characterID: timeInterval(), creatorID: userModel.currentUser!.uid, characterName: characterName, stats: Stats(health: healthVal, attack: attackVal, defense: defenseVal, speed: speedVal, agility: agilityVal, hp: 100), bag: [:])
        storyModel.addCharacterToStory(storyID: storyModel.currentStory!.storyID, character: newCharacter)

    }

}
