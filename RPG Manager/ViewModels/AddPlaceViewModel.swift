//
//  AddPlaceViewModel.swift
//  RPG Manager
//
//  Created by Anjali Narang  on 12/17/24.
//

import Foundation

class AddPlaceViewModel: ObservableObject {
    
    let userModel = UserModel.shared
    let placeModel = PlaceModel.shared
    
    @Published var placeName: String = ""
    @Published var placeDescription: String = ""
    
    func addPlace() {
                
        let newPlace = Place(placeID: idWithTimeInterval(), placeName: placeName, placeDescription: placeDescription, creator: userModel.currentUser!.uid, iconURL: "")
        placeModel.addPlaceToStory(place: newPlace)

    }

}
