//
//  MapViewModel.swift
//  RPG Manager
//
//  Created by Anjali Narang  on 12/17/24.
//


import Foundation
import Combine
import PhotosUI

class MapViewModel: ObservableObject {
    
    @Published var currentStory: Story?
        
    private let storyModel = StoryModel.shared
    private let mapItemModel = MapItemModel.shared
    private let characterModel = CharacterModel.shared
    
    private var cancellables: Set<AnyCancellable> = []
    @Published var mapItems: [MapItem] = []
    
    init() {
        storyModel.$currentStory
            .assign(to: &$currentStory)
        mapItemModel.$currentMapItems
            .sink { [weak self] newItems in self?.mapItems = newItems }
            .store(in: &cancellables)
    }
    
    func updateStoryMapImg(image: UIImage) {
        storyModel.uploadMapImg(image: image, imageID: idWithTimeInterval()) // this also calls function that updates database ref
    }
    
    func getIcon(type: String, id: String) -> String {
        var url = ""
        if type == "character" {
            url = characterModel.getIconUrl(for: id) ?? ""
        }
        return url
    }
    
    func updatePosition(item: MapItem) {
        
    }
    
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

}
