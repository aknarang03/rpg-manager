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
    
    func startObserving() {
        print("start observing current characters and collaborators")
        storyModel.observeCurrentCharacters()
        storyModel.observeCurrentCollaborators()
    }
    
    func stopObserving() {
        print("stop observing current characters and collaborators")
        storyModel.cancelCurrentCharactersObserver()
        storyModel.cancelCurrentCollaboratorsObserver()
    }


}
