//
//  OtherFightViewModel.swift
//  RPG Manager
//
//  Created by Anjali Narang  on 11/26/24.
//


import Foundation
import Combine

class FightDetailViewModel: ObservableObject {
    
    let fightModel = FightModel.shared
    let characterModel = CharacterModel.shared
    
    @Published var fight: Fight
    
    init(fight: Fight) {
        self.fight = fight
    }
    
    // NOTE TO SELF: handle when character has been deleted
    func getWinner() -> Character {
        // it is checked in the view that a winner exists
        let winner = characterModel.getCharacter(for: fight.winner!)!
        return winner
    }
    
    func getCharacterName (characterID: String) -> String {
        if let characterName = characterModel.getCharacter(for: characterID)?.characterName {
            return characterName
        } else {
            return "Unknown"
        }
    }

}
