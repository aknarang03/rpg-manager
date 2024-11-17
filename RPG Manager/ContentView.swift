//
//  ContentView.swift
//  RPG Manager
//
//  Created by Anjali Narang  on 11/17/24.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var viewModel = TestViewModel()

    var body: some View {
        
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
        }
        
//        .padding()
//        
//        Button("Change Screen") {
//            // NAVIGATION
//        }
        
    }
}
