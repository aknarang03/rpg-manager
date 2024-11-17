//
//  ContentView.swift
//  RPG Manager
//
//  Created by Anjali Narang  on 11/17/24.
//

import SwiftUI

struct MainView: View {
    
    @StateObject private var viewModel = TestViewModel()
    @Binding var isLoggedIn: Bool

    var body: some View {
        
        NavigationView {
            
            VStack {
                
                TextField("Enter text here", text: $viewModel.inputText, onCommit: {
                    viewModel.handleSubmit() // submit if they press enter key in text field
                })
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button("Print to Console") {
                    viewModel.handleSubmit() // submit if they press button
                }
                .padding()
                
                NavigationLink(
                    destination: NavTestView(),
                    label: {
                        Text("Navigate")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                            .navigationBarTitle("Main View", displayMode: .inline)
                            .navigationBarItems(leading: Button("Logout") {
                                isLoggedIn = false
                            })
                    }
                    
                )
                
            }
                        
        }
        
    }
    
}
