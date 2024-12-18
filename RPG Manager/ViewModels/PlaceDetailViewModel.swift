//
//  PlaceDetailViewModel.swift
//  RPG Manager
//
//  Created by Anjali Narang  on 12/17/24.
//


import Foundation
import Combine
import PhotosUI

class PlaceDetailViewModel: ObservableObject {
    
    let userModel = UserModel.shared
    let storyModel = StoryModel.shared
    let characterModel = CharacterModel.shared
    let placeModel = PlaceModel.shared
    
    @Published var place: Place
    
    init(place: Place) {
        self.place = place
    }
    
    func uidToUsername(uid: String) -> String {
        guard let username = userModel.getUsername(for: uid) else {
            print("Username not found for \(uid)")
            return "Unknown" // default username
        }
        return username
    }
    
    func deletePlace() {
        placeModel.deletePlace(placeID: place.placeID)
    }
    
    func updatePlaceIcon(image: UIImage) {
        placeModel.uploadPlaceIcon(image: image, imageID: idWithTimeInterval(), placeID: place.placeID) // this also calls function that updates database ref
    }

}
