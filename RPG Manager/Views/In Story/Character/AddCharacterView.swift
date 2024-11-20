//
//  AddCharacterView.swift
//  RPG Manager
//
//  Created by Anjali Narang  on 11/20/24.
//

import SwiftUI

struct AddCharacterView: View {
    
    @ObservedObject var viewModel: AddCharacterViewModel = AddCharacterViewModel()
    @EnvironmentObject var appState: AppState

    var body: some View {
        
        NavigationView {
            
            VStack {
                TextField(
                    "character name",
                    text: $viewModel.characterName
                )
                .padding(.top)
                TextField(
                    "attack",
                    text: $viewModel.attack
                )
                .padding(.top)
                TextField(
                    "defense",
                    text: $viewModel.defense
                )
                .padding(.top)
                TextField(
                    "speed",
                    text: $viewModel.speed
                )
                .padding(.top)
                TextField(
                    "agility",
                    text: $viewModel.agility
                )
                .padding(.top)
                
                Button ("Add") {
                    viewModel.addCharacter()
                }
                
                Spacer()
                
            }
            
        }
        .navigationBarTitle("Add Character")
        
    }
    
}
    
