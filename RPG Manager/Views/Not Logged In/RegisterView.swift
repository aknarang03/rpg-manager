//
//  RegisterView.swift
//  RPG Manager
//
//  Created by Anjali Narang  on 11/18/24.
//

import SwiftUI

struct RegisterView: View {

    @ObservedObject var viewModel: RegisterViewModel = RegisterViewModel()

    @State private var showAlert = false
    @State private var alertMessage = ""

    var body: some View {
        
        VStack {
            
            Text("Register")
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
                TextField(
                    "username",
                    text: $viewModel.username
                )
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .padding(.top)
                SecureField(
                    "password",
                    text: $viewModel.password
                )
                .padding(.top)
            }
            
            Spacer()
            
            Button("Register") {
                viewModel.register(
                    onSuccess: { successMessage in
                        alertMessage = successMessage
                        showAlert = true
                    },
                    onFailure: { errorMessage in
                        alertMessage = errorMessage
                        showAlert = true
                    }
                )
            }
            .padding()
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Register"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
        
    }

}
