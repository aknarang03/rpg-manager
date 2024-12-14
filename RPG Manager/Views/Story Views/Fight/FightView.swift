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
    
    let characterModel = CharacterModel.shared
    
    // take some views out and insert in because this is too messy
    
    var body: some View {
        
        NavigationView {
            
            VStack {
                
                Spacer()
                
                if (!viewModel.fightOngoing) { // SETUP SCREEN CONTENT
                    
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
                    
                    Text("\(characterModel.getCharacter(for: viewModel.attackingCharacterID)?.characterName ?? "Unknown")'s Turn")
                        .font(.largeTitle)
                        .padding()
                    
                    Spacer()
                    
                    HStack { // characters view
                        
                        Spacer()
                        
                        VStack { // character 1 view
                            
                            if let iconURLString = viewModel.character1.iconURL, let url = URL(string: iconURLString) {
                                IconView(url: url)
                            } else {
                                Rectangle() // to even out spacing
                                    .frame(width: 30, height: 30)
                                    .opacity(0)
                            }
                            
                            if (viewModel.character1Attacking()) {
                                Text(viewModel.character1.characterName)
                                    .font(.title)
                            } else {
                                Text(viewModel.character1.characterName)
                            }
                            
                            Text("hp: \(viewModel.character1Stats.hp)/\(viewModel.character1Stats.health)")
                            ProgressView(value: Double(viewModel.character1Stats.hp), total: Double(viewModel.character1Stats.health))
                                .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                                .frame(height: 8)
                            
                            Text("holding \(viewModel.itemIdToItemName(itemID: viewModel.character1.heldItem ?? "nothing"))")
                            if let holding = viewModel.character1.heldItem {
                                if let iconURLString = viewModel.getItem(itemID: holding).iconURL, let url = URL(string: iconURLString) {
                                    IconView(url: url)
                                } else {
                                    Rectangle() // to even out spacing
                                        .frame(width: 30, height: 30)
                                        .opacity(0)
                                }
                            } else {
                                Rectangle() // to even out spacing
                                    .frame(width: 30, height: 30)
                                    .opacity(0)
                            }
                            
                        } // end character 1 view
                        
                        Spacer()
                        
                        VStack { // character 2 view
                            
                            if let iconURLString = viewModel.character2.iconURL, let url = URL(string: iconURLString) {
                                IconView(url: url)
                            } else {
                                Rectangle() // to even out spacing
                                    .frame(width: 30, height: 30)
                                    .opacity(0)
                            }
                            
                            if (viewModel.character2Attacking()) {
                                Text(viewModel.character2.characterName)
                                    .font(.title)
                            } else {
                                Text(viewModel.character2.characterName)
                            }
                            
                            Text("hp: \(viewModel.character2Stats.hp)/\(viewModel.character2Stats.health)")
                            ProgressView(value: Double(viewModel.character2Stats.hp), total: Double(viewModel.character2Stats.health))
                                .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                                .frame(height: 8)
                            
                            Text("holding \(viewModel.itemIdToItemName(itemID: viewModel.character2.heldItem ?? "nothing"))")
                            if let holding = viewModel.character2.heldItem {
                                if let iconURLString = viewModel.getItem(itemID: holding).iconURL, let url = URL(string: iconURLString) {
                                    IconView(url: url)
                                } else {
                                    Rectangle() // to even out spacing
                                        .frame(width: 30, height: 30)
                                        .opacity(0)
                                }
                            } else {
                                Rectangle() // to even out spacing
                                    .frame(width: 30, height: 30)
                                    .opacity(0)
                            }
                            
                        } // end character 2 view
                        
                        Spacer()
                        
                    } // end characters view
                    
                    Spacer()
                    
                    HStack { // actions view
                        
                        Spacer()
                        
                        Button("attack") {
                            viewModel.attackAction()
                            viewModel.showCharacterBag = false
                        }.disabled(viewModel.showOutcome == true || viewModel.isWorking)
                        
                        Spacer()
                        
                        VStack {
                            
                            if let char = characterModel.getCharacter(for: viewModel.attackingCharacterID) {
                                if let bag = char.bag {
                                    Button("use item") {
                                        viewModel.showCharacterBag = !viewModel.showCharacterBag
                                    }.disabled(viewModel.showOutcome == true
                                               || viewModel.isWorking
                                               || bag.isEmpty
                                    )
                                }
                            }
                            
                            if (viewModel.showCharacterBag == true) {
                                                                
                                HStack {
                                    
                                    Picker("Consumables", selection: $viewModel.itemToConsume) {
                                        
                                        if (viewModel.character1Attacking()) {
                                            
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
                                    }.disabled(
                                        viewModel.itemToConsume == ""
                                    )
                                } // end use item hstack
                                
                            } // end show character bag
                            
                        } // end item vstack
                    
                        Spacer()
                        
                        Button("pass") {
                            viewModel.passAction()
                            viewModel.showCharacterBag = false
                        }.disabled(viewModel.showOutcome == true || viewModel.isWorking)
                        
                        Spacer()
                        
                        Button("flee") {
                            viewModel.fleeAction()
                            viewModel.showCharacterBag = false
                        }.disabled(viewModel.showOutcome == true || viewModel.isWorking)
                        
                        Spacer()
                        
                    } // end actions view
                    
                    Spacer()
                    
                    if (viewModel.showOutcome) { // outcome view
                        
                        VStack {
                            
                            Text(viewModel.showOutcomeStr)
                                .foregroundColor(.red)
                                .opacity(viewModel.showOutcome ? 1 : 0)
                            
                        }.onChange(of: viewModel.isWorking) {
                            if !viewModel.isWorking {
                                withAnimation {
                                    print("anim done")
                                    viewModel.showOutcome = false
                                }
                            }
                        }
                        
                    } // end outcome view
                    
                } // end fight screen content
                
                Spacer()
                
                if (viewModel.fightOngoing) {
                    Button("Stop") {
                        viewModel.stopFight()
                    }
                } else {
                    Button("Start") {
                        viewModel.startFight()
                    }.disabled(!viewModel.shouldStart())

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
