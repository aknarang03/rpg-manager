//
//  StoryViewModel.swift
//  RPG Manager
//
//  Created by Anjali Narang  on 11/20/24.
//

import Foundation
import Combine
import SwiftUICore

class StoryViewModel: ObservableObject {
    
    let storyModel = StoryModel.shared
    let userModel = UserModel.shared
    let fightModel = FightModel.shared
    let itemModel = ItemModel.shared
    let characterModel = CharacterModel.shared
    
    @Published var isStoryDeleted: Bool = false

    init() {
        storyModel.$deleted
            .sink { [weak self] deleted in
                self?.isStoryDeleted = deleted
                if deleted {
                    print("story has been deleted")
                }
            }
            .store(in: &cancellables)
    }

    var cancellables = Set<AnyCancellable>()
    
    func startObserving() {
        print("start observing current characters, items, fights, and collaborators")
        characterModel.observeCurrentCharacters()
        itemModel.observeCurrentItems()
        storyModel.observeCurrentCollaborators()
        storyModel.observeCurrentStoryDeletion()
        fightModel.observeCurrentFights()
    }
    
    func stopObserving() {
        print("stop observing current characters, items, fights, and collaborators")
        characterModel.cancelCurrentCharactersObserver()
        itemModel.cancelCurrentItemsObserver()
        storyModel.cancelCurrentCollaboratorsObserver()
        fightModel.cancelCurrentFightsObserver()
        storyModel.stopObservingCurrentStoryDeletion()
    }
    
}
