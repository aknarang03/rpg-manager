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

    
    // take some views out and insert in because this is too messy
    
    var body: some View {
        
        NavigationView {
            
            VStack {
                
                Spacer()
                
                if (!fightStarted) { // SETUP SCREEN CONTENT
                    
                    Text("Select Characters")
                        .font(.largeTitle)
                        .padding()
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
                    
                } // end setup screen content
                
                else { // FIGHT SCREEN CONTENT
                    
                    Text("\(storyModel.getCharacter(for: viewModel.attackingCharacterID)!.characterName)'s Turn")
                        .font(.largeTitle)
                        .padding()
                    
                    Spacer()
                    
                    HStack { // characters view
                        
                        Spacer()
                        
                        VStack {
                            Text(viewModel.character1.characterName)
                            
                            Text("hp: \(viewModel.character1.stats.hp)/\(viewModel.character1.stats.health)")
                            ProgressView(value: Double(viewModel.character1.stats.hp), total: Double(viewModel.character1.stats.health))
                                .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                                .frame(height: 8)
                            
                        }
                        
                        Spacer()
                        
                        VStack {
                            Text(viewModel.character2.characterName)
                            
                            Text("hp: \(viewModel.character2.stats.hp)/\(viewModel.character2.stats.health)")
                            ProgressView(value: Double(viewModel.character2.stats.hp), total: Double(viewModel.character2.stats.health))
                                .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                                .frame(height: 8)
                            
                        }
                        
                        Spacer()
                        
                    } // end characters view
                    
                    Spacer()
                    
                    HStack { // actions view
                        
                        Spacer()
                        
                        Button("attack") {
                            viewModel.attackAction()
                            viewModel.showCharacterBag = false
                        }
                        
                        Spacer()
                        
                        VStack {
                            
                            Button("use item") {
                                viewModel.showCharacterBag = !viewModel.showCharacterBag
                            }
                            
                            if (viewModel.showCharacterBag == true) {
                                                                
                                HStack {
                                    
                                    Picker("Consumables", selection: $viewModel.itemToConsume) {
                                        
                                        if (viewModel.attackingCharacterID == viewModel.character1ID) {
                                            
                                            if let bag = viewModel.character1.bag {
                                                
                                                ForEach(bag.keys.sorted(), id: \.self) { itemID in
                                                    
                                                    if (viewModel.getItemType(itemID: itemID) == "consumable") {
                                                        Text(viewModel.itemIdToItemName(itemID: itemID))
                                                            .tag(itemID)
                                                    }
                                                                                                
                                                }
                                                
                                            }
                                            
                                        } // end show character 1 bag
                                        
                                        else {
                                            
                                            if let bag = viewModel.character2.bag {
                                                
                                                ForEach(bag.keys.sorted(), id: \.self) { itemID in
                                                    
                                                    if (viewModel.getItemType(itemID: itemID) == "consumable") {
                                                        Text(viewModel.itemIdToItemName(itemID: itemID))
                                                            .tag(itemID)
                                                    }
                                                                                                
                                                }
                                                
                                            }
                                            
                                        } // end show character 2 bag
                                    
                                    } // end picker
                                    .pickerStyle(MenuPickerStyle())
                                    Button("use") {
                                        viewModel.consumeItemAction()
                                        viewModel.showCharacterBag = false
                                    }
                                } // end use item hstack
                                
                            } // end show character bag
                            
                        } // end item vstack
                    
                        Spacer()
                        
                        Button("pass") {
                            viewModel.passAction()
                            viewModel.showCharacterBag = false
                        }
                        
                        Spacer()
                        
                    } // end actions view
                    
                    Spacer()
                    
                } // end fight screen content
                
                Spacer()
                
                if (fightStarted) {
                    Button("Stop") {
                        fightStarted = false
                        viewModel.stopFight()
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
                trailing: Button(action: {}, label: {
                    NavigationLink(destination: FightListView()) {
                         Text("Fights")
                    }
                }
                                )
                )
            
            
        }
            
    }
    
}
