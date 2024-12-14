//
//  LoginViewModel.swift
//  RPG Manager
//
//  Created by Anjali Narang  on 11/18/24.
//

import Foundation

class LoginViewModel: ObservableObject {

    @Published var email: String = ""
    @Published var password: String = ""
        
    let userModel = UserModel.shared

    func login(onSuccess: @escaping () -> Void, onFailure: @escaping (String) -> Void) {
        
        Task {
                    
            if !email.isEmpty && !password.isEmpty {
                
                let (result, resultMessage) = try await userModel.signInAsync(withEmail: email, andPassword: password)
                
                if result { // LOGIN SUCCEEDED
                    print("Login successful")
                    DispatchQueue.main.async {
                        onSuccess()
                    }
                }
                
                else { // LOGIN FAILED
                    DispatchQueue.main.async {
                        onFailure("Login failed")
                    }
                }
                
            } else { // CREDENTIALS NOT ENTERED PROPERLY
                onFailure("Invalid credentials")
            }
            
        }
        
    }
    
    func testLogin(user: String, onSuccess: @escaping () -> Void, onFailure: @escaping (String) -> Void) {
        
        Task {
                    
                
            let (result, resultMessage) = try await userModel.signInAsync(withEmail: user, andPassword: "password")
            
            if result { // LOGIN SUCCEEDED
                print("Login successful")
                DispatchQueue.main.async {
                    onSuccess()
                }
            }
            
            else { // LOGIN FAILED
                DispatchQueue.main.async {
                    onFailure("Login failed")
                }
            }
            
        }
        
    }
        
    
}
