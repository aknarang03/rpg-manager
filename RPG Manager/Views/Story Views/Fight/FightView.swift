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
    let characterModel = CharacterModel.shared

    
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
                    
                    Text("\(characterModel.getCharacter(for: viewModel.attackingCharacterID)?.characterName ?? "Unknown")'s Turn")
                        .font(.largeTitle)
                        .padding()
                    
                    Spacer()
                    
                    HStack { // characters view
                        
                        Spacer()
                        
                        VStack { // character 1 view
                            
                            if let iconURLString = viewModel.character1.iconURL, let url = URL(string: iconURLString) {
                                AsyncImage(url: url) { image in
                                    image.resizable()
                                        .scaledToFit()
                                        .frame(width: 30, height: 30)
                                } placeholder: {
                                    ProgressView()
                                }
                            } else {
                                Rectangle() // to even out spacing
                                    .frame(width: 30, height: 30)
                                    .opacity(0)
                            }
                            
                            if (viewModel.character1ID == viewModel.attackingCharacterID) { // need to make a method for detecting who is attacking..
                                Text(viewModel.character1.characterName)
                                    .font(.title)
                            } else {
                                Text(viewModel.character1.characterName)
                            }
                            
                            Text("hp: \(viewModel.character1.stats.hp)/\(viewModel.character1.stats.health)")
                            ProgressView(value: Double(viewModel.character1.stats.hp), total: Double(viewModel.character1.stats.health))
                                .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                                .frame(height: 8)
                            
                            Text("holding \(viewModel.itemIdToItemName(itemID: viewModel.character1.heldItem ?? "nothing"))")
                            
                        } // end character 1 view
                        
                        Spacer()
                        
                        VStack { // character 2 view
                            
                            if let iconURLString = viewModel.character2.iconURL, let url = URL(string: iconURLString) {
                                AsyncImage(url: url) { image in
                                    image.resizable()
                                        .scaledToFit()
                                        .frame(width: 30, height: 30)
                                } placeholder: {
                                    ProgressView()
                                }
                            } else {
                                Rectangle() // to even out spacing
                                    .frame(width: 30, height: 30)
                                    .opacity(0)
                            }
                            
                            if (viewModel.character2ID == viewModel.attackingCharacterID) { // need to make a method for detecting who is attacking..
                                Text(viewModel.character2.characterName)
                                    .font(.title)
                            } else {
                                Text(viewModel.character2.characterName)
                            }
                            
                            Text("hp: \(viewModel.character2.stats.hp)/\(viewModel.character2.stats.health)")
                            ProgressView(value: Double(viewModel.character2.stats.hp), total: Double(viewModel.character2.stats.health))
                                .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                                .frame(height: 8)
                            
                            Text("holding \(viewModel.itemIdToItemName(itemID: viewModel.character2.heldItem ?? "nothing"))")
                            
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
                                                        
                            Button("use item") {
                                viewModel.showCharacterBag = !viewModel.showCharacterBag
                            }.disabled(viewModel.showOutcome == true
                                       || viewModel.isWorking
                                       || characterModel.getCharacter(for: viewModel.attackingCharacterID)!.bag!.isEmpty
                            )
                            
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
                            fightStarted = false // this should be in view model..
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
                
                if (fightStarted) {
                    Button("Stop") {
                        fightStarted = false
                        viewModel.stopFight()
                    }
                } else {
                    Button("Start") {
                        fightStarted = true
                        viewModel.startFight()
                    }.disabled(viewModel.character1ID == "" || viewModel.character2ID == "" || viewModel.character1ID == viewModel.character2ID)

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
