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
        
    var body: some View {
        
        NavigationStack {
            
            VStack {
                
                Spacer()
                
                if (!viewModel.fightOngoing) {
                    SetupFightView(viewModel: viewModel)
                }
                
                else { // FIGHT SCREEN CONTENT
                    
                    // who's turn is it
                    Text("\(characterModel.getCharacter(for: viewModel.attackingCharacterID)?.characterName ?? "Unknown")'s Turn")
                        .font(.largeTitle)
                        .padding()
                    
                    Spacer()
                    
                    HStack { // characters view
                        
                        Spacer()
                        CharacterView(isChar1: true, viewModel: viewModel)
                        Spacer()
                        CharacterView(isChar1: false, viewModel: viewModel)
                        Spacer()
                        
                    }
                    
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
                                            FightBagView(isChar1: true, viewModel: viewModel)
                                        }
                                        else {
                                            FightBagView(isChar1: false, viewModel: viewModel)
                                        }
                                    }
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

struct FightBagView: View {
    
    let character: Character
    @ObservedObject var viewModel: FightViewModel
    
    init(isChar1: Bool, viewModel: FightViewModel) {
        
        self.viewModel = viewModel
        
        if isChar1 {
            character = viewModel.character1
        } else {
            character = viewModel.character2
        }
        
    }

    var body: some View {
        
        if let bag = character.bag {
            
            ForEach(bag.keys.sorted(), id: \.self) { itemID in
                
                if (viewModel.getItemType(itemID: itemID) == "consumable") {
                    Text(viewModel.itemIdToItemName(itemID: itemID))
                        .tag(itemID)
                }
                
            }
            
        }
        
    }
    
}

struct CharacterView: View {
    
    @ObservedObject var viewModel: FightViewModel
    
    let character: Character
    let stats: Stats
    let attacking: Bool
    
    init(isChar1: Bool, viewModel: FightViewModel) {
        
        self.viewModel = viewModel
        
        if isChar1 {
            character = viewModel.character1
            stats = viewModel.character1Stats
            attacking = viewModel.character1Attacking()
        } else {
            character = viewModel.character2
            stats = viewModel.character2Stats
            attacking = viewModel.character2Attacking()
        }
        
    }
    
    var body: some View {
        
        VStack {
            
            if let iconURLString = character.iconURL, let url = URL(string: iconURLString) {
                IconView(url: url)
            } else {
                Rectangle() // to even out spacing
                    .frame(width: 30, height: 30)
                    .opacity(0)
            }
            
            if (attacking) {
                Text(character.characterName)
                    .font(.title)
            } else {
                Text(character.characterName)
            }
            
            Text("hp: \(stats.hp)/\(stats.health)")
            ProgressView(value: Double(stats.hp), total: Double(stats.health))
                .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                .frame(height: 8)
            
            Text("holding \(viewModel.itemIdToItemName(itemID: character.heldItem ?? "nothing"))")
            if let holding = character.heldItem {
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
            
        }
        
    }
    
}


struct SetupFightView: View {
    
    @ObservedObject var viewModel: FightViewModel
    
    var body: some View {
        
        Text("Select Characters")
            .font(.largeTitle)
            .padding()
        
        Spacer()
        
        HStack {
            
            Spacer()
            
            Picker("Character", selection: $viewModel.character1ID) {
                if viewModel.characters.isEmpty {
                        Text("no characters available").tag(-1)
                } else {
                    ForEach(viewModel.characters, id: \.characterID) { character in
                        Text(character.characterName).tag(character.characterID)
                    }
                }
            }
            .pickerStyle(MenuPickerStyle())
            
            Spacer()
            
            Picker("Character", selection: $viewModel.character2ID) {
                if viewModel.characters.isEmpty {
                        Text("no characters available").tag(-1)
                } else {
                    ForEach(viewModel.characters, id: \.characterID) { character in
                        Text(character.characterName).tag(character.characterID)
                    }
                }
            }
            .pickerStyle(MenuPickerStyle())
            
            Spacer()
            
        }
        
        
    }
    
}
