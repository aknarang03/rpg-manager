//
//  LoginView.swift
//  RPG Manager
//
//  Created by Anjali Narang  on 11/17/24.
//

import SwiftUI

struct LoginView: View {
    
    @Binding var isLoggedIn: Bool
    
    var body: some View {
        
        VStack {
            
            Text("Login Screen")
                .font(.largeTitle)
                .padding()
            
            Button("Log In") {
                isLoggedIn = true // Change the root view to MainView
            }
            .padding()
            
        }
        
    }
    
}
