//
//  FightView.swift
//  RPG Manager
//
//  Created by Anjali Narang  on 11/25/24.
//


import SwiftUI

struct FightView: View {
    
    @ObservedObject var viewModel: FightViewModel = FightViewModel()
    
    @EnvironmentObject var appState: AppState
    @State var fightStarted = false
    
    // should move the logic used with these to view model..
    let userModel = UserModel.shared
    let storyModel = StoryModel.shared

    var body: some View {
        
        NavigationView {
            
            VStack {
                
                Spacer()
                
                if (!fightStarted) { // SETUP SCREEN CONTENT
                    Text("fight not started")
                    Spacer()
                    
                    HStack {
                        
                        Spacer()
                        
                        Picker("Character", selection: $viewModel.character1ID) {
                            ForEach(viewModel.characters, id: \.characterID) { character in
                                Text(character.characterName).tag(character.characterID)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        
                        Spacer()
                        
                        Picker("Character", selection: $viewModel.character2ID) {
                            ForEach(viewModel.characters, id: \.characterID) { character in
                                Text(character.characterName).tag(character.characterID)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        
                        Spacer()
                        
                    }
                    
                }
                
                else { // FIGHT SCREEN CONTENT
                    Text("fight started")
                    Spacer()
                    
                    HStack {
                        
                        Spacer()
                        
                        VStack {
                            Text(viewModel.character1.characterName)
                            Text("\(viewModel.character1.stats.hp)/\(viewModel.character1.stats.health)")
                        }
                        
                        Spacer()
                        
                        VStack {
                            Text(viewModel.character2.characterName)
                            Text("\(viewModel.character2.stats.hp)/\(viewModel.character2.stats.health)")
                        }
                        
                        Spacer()
                        
                    }
                    
                }
                
                Spacer()
                
                if (fightStarted) {
                    Button("Stop") {
                        fightStarted = false
                    }
                } else {
                    Button("Start") {
                        fightStarted = true
                        viewModel.startFight()
                    }
                }
                
                Spacer()
                
            }
            .navigationBarTitle("Fight")
            .navigationBarItems(
                trailing: Button("Fights") { }
            )
            
        }
            
    }
    
}
