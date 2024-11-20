//
//  CharacterDetailViewModel.swift
//  RPG Manager
//
//  Created by Anjali Narang  on 11/20/24.
//

import Foundation
import Combine

class CharacterDetailViewModel: ObservableObject {
    
    let userModel = UserModel.shared
    
    func uidToUsername(uid: String) -> String {
        guard let username = userModel.getUsername(for: uid) else {
            print("Username not found for \(uid)")
            return "Unknown" // default username
        }
        return username
    }

}
