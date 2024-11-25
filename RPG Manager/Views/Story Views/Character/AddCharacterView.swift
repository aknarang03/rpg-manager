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
                    "character description",
                    text: $viewModel.characterDescription
                )
                
                Spacer()
                
                HStack {
                    Text("health: \(Int(viewModel.health))")
                    Slider(value: $viewModel.health, in: 0...100, step: 1)
                }
                HStack {
                    Text("attack: \(Int(viewModel.attack))")
                    Slider(value: $viewModel.attack, in: 0...100, step: 1)
                }
                HStack {
                    Text("defense: \(Int(viewModel.defense))")
                    Slider(value: $viewModel.defense, in: 0...100, step: 1)
                }
                HStack {
                    Text("speed: \(Int(viewModel.speed))")
                    Slider(value: $viewModel.speed, in: 0...100, step: 1)
                }
                HStack {
                    Text("agility: \(Int(viewModel.agility))")
                    Slider(value: $viewModel.agility, in: 0...100, step: 1)
                }
                
                Spacer()
                
                HStack {
                    Text("Player?")
                    Picker("Player?", selection: $viewModel.isPlayer) {
                        ForEach([("Player", "true"), ("NPC", "false")], id: \.1) { display, value in
                            Text(display).tag(value)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }
                
                Spacer()
                
                Button ("Add") {
                    viewModel.addCharacter()
                }
                
                Spacer()
                
            }
            
        }
        .navigationBarTitle("Add Character")
        
    }
    
}
    
