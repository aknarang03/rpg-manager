//
//  MapViewModel.swift
//  RPG Manager
//
//  Created by Anjali Narang  on 12/17/24.
//


import Foundation
import Combine

class MapViewModel: ObservableObject {
    
    //PLAN
    
    // map view shows the uploaded image.
    
    // in places and characters detail views, there should be a button "add to map". this would add their icon to the map (or some default icon if there was none uploaded...) the icon should actually reference the character or place, so that later i can add tapping on it to open the detail view.
    // i have to think of how to structure this in database. maybe each story has a "Map", which has a list of IDs of what has been added to it, which I can then use to a) ensure no duplicates and b) reference stuff and c) get the icon.
    // each ID would also have coordinates so that the map can load again as it was when someone reopens it. and so that it updates for every user.
    
    // eventually I should add that if a character is touching a place on the map, it marks them as being there, and character would have a current location attribute.
    // also character icons should be a layer above the places so that they go on top.

    
    
    
    
//    let storyModel = StoryModel.shared
//    let userModel = UserModel.shared
//    
//    private var cancellables: Set<AnyCancellable> = []
//    

    init() {
        
//        storyModel.$currentCollaborators
//            .sink { [weak self] newCollabs in self?.collaborators = newCollabs }
//            .store(in: &cancellables)
        
    }

}
