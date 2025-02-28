//
//  ProfileVieq.swift
//  RPG Manager
//
//  Created by Anjali Narang  on 11/25/24.
//

import SwiftUI

struct ProfileView: View {
    
    @ObservedObject var viewModel: ProfileViewModel = ProfileViewModel()
    @EnvironmentObject var appState: AppState
        
    let userModel = UserModel.shared
    
    var body: some View {
        
        NavigationView {
            
            VStack {
                
                Spacer()
                
                if let user = userModel.currentUser {
                    
                    Text(user.username)
                        .font(.largeTitle)
                        .padding()
                    Text("email: \(user.email)")
                    
                }
                
                Spacer()
                Spacer()
                
                Button("Delete Account") {
                    Task {
                        await viewModel.deleteAccount()
                        appState.isLoggedIn = false
                    }
                }
                
                Spacer()
                    
            }
            
        }
            
    }
    
}
