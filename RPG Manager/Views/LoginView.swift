//
//  LoginView.swift
//  RPG Manager
//
//  Created by Anjali Narang  on 11/17/24.
//

import SwiftUI

struct LoginView: View {
    
    @ObservedObject var viewModel: LoginViewModel = LoginViewModel()
    @EnvironmentObject var appState: AppState
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        
        VStack {
            
            Text("Login")
                .font(.largeTitle)
                .padding()
            
            Spacer()
            
            VStack {
                TextField(
                    "email",
                    text: $viewModel.email
                )
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .padding(.top)
                Divider()
                SecureField(
                    "password",
                    text: $viewModel.password
                )
                .padding(.top)
            }
            
            Spacer()
            
            Button("login") {
                viewModel.login(
                    onSuccess: {
                        appState.isLoggedIn = true
                    },
                    onFailure: { errorMessage in
                        alertMessage = errorMessage
                        showAlert = true
                    }
                )
            }
            .padding()
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
        
    }
    
}
