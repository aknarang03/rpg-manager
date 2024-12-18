//
//  PlaceListViewModel.swift
//  RPG Manager
//
//  Created by Anjali Narang  on 12/17/24.
//


import Foundation
import Combine

class PlaceListViewModel: ObservableObject {
    
    let storyModel = StoryModel.shared
    let userModel = UserModel.shared
    let placeModel = PlaceModel.shared
    
    private var cancellables: Set<AnyCancellable> = []
    
    @Published var places: [Place] = []

    init() {
        placeModel.$currentPlaces
            .sink { [weak self] newPlaces in self?.places = newPlaces }
            .store(in: &cancellables)
    }
    
    func uidToUsername(uid: String) -> String {
        guard let username = userModel.getUsername(for: uid) else {
            print("Username not found for \(uid)")
            return "Unknown" // default username
        }
        return username
    }

}
