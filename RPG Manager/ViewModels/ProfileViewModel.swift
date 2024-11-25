//
//  ProfileViewModel.swift
//  RPG Manager
//
//  Created by Anjali Narang  on 11/25/24.
//

import Foundation
import Combine

class ProfileViewModel: ObservableObject {
    
    let userModel = UserModel.shared
    
    func deleteAccount() async {
        do {
            try await userModel.deleteAccount()
            print("account successfully deleted")
        } catch {
            print("failed to delete account: \(error.localizedDescription)")
        }
    }

}
