//
//  StoryViewModel.swift
//  RPG Manager
//
//  Created by Anjali Narang  on 11/20/24.
//

import Foundation
import Combine

class StoryViewModel: ObservableObject {
    
    let storyModel = StoryModel.shared
    let userModel = UserModel.shared
    let fightModel = FightModel.shared
    let itemModel = ItemModel.shared
    let characterModel = CharacterModel.shared
    
    func startObserving() {
        print("start observing current characters, items, fights, and collaborators")
        characterModel.observeCurrentCharacters()
        itemModel.observeCurrentItems()
        fightModel.observeCurrentFights()
    }
    
    func stopObserving() {
        print("stop observing current characters, items, fights, and collaborators")
        characterModel.cancelCurrentCharactersObserver()
        itemModel.cancelCurrentItemsObserver()
        fightModel.cancelCurrentFightsObserver()
    }
    
}
