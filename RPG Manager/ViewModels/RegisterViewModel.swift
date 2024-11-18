//
//  RegisterViewModel.swift
//  RPG Manager
//
//  Created by Anjali Narang  on 11/18/24.
//

import Foundation

class RegisterViewModel: ObservableObject {

    @Published var email: String = ""
    @Published var username: String = ""
    @Published var password: String = ""
    
    let userModel = UserModel.shared

    func register(onSuccess: @escaping (String) -> Void, onFailure: @escaping (String) -> Void) {
        
        Task {
                    
            if !email.isEmpty && !username.isEmpty && !password.isEmpty {
                
                let (result, resultMessage) = try await userModel.registerAsync(withEmail: email, andPassword: password, andUsername: username)
                
                if result { // REGISTER SUCCEEDED
                    print("Register successful")
                    DispatchQueue.main.async {
                        onSuccess("Register successful")
                    }
                }
                
                else { // REGISTER FAILED
                    DispatchQueue.main.async {
                        onFailure("Register failed")
                    }
                }
                
            } else { // CREDENTIALS NOT ENTERED PROPERLY
                onFailure("Invalid credentials")
            }
            
        }
        
    }
    
}
