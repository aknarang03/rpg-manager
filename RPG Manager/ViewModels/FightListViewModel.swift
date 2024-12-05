//
//  FightListViewModel.swift
//  RPG Manager
//
//  Created by Anjali Narang  on 11/26/24.
//


import Foundation
import Combine

class FightListViewModel: ObservableObject {
    
    let storyModel = StoryModel.shared
    let userModel = UserModel.shared
    let fightModel = FightModel.shared
    let characterModel = CharacterModel.shared
    
    private var cancellables: Set<AnyCancellable> = []
    
    @Published var fights: [Fight] = []

    init() {
        // I don't fully understand it, but it lets this.stories synch with storyModel.stories...
        // This way I can keep this stuff out of the view and in the view model.
        fightModel.$currentFights
            .sink { [weak self] newFights in self?.fights = newFights }
            .store(in: &cancellables)
    }
    
    func getCharacterName (characterID: String) -> String {
        if let characterName = characterModel.getCharacter(for: characterID)?.characterName {
            return characterName
        } else {
            return "Unknown"
        }
    }
    
    func removeFight(fightID: String) {
        fightModel.deleteFight(fightID: fightID)
    }
    
//    func startObserving() {
//        print("start observing fights")
//        storyModel.observeCurrentFights()
//    }
//    
//    func stopObserving() {
//        print("stop observing fights")
//        storyModel.cancelCurrentFightsObserver()
//    }

}
