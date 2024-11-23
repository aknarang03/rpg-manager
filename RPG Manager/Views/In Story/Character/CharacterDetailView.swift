//
//  CharacterDetailView.swift
//  RPG Manager
//
//  Created by Anjali Narang  on 11/20/24.
//


import SwiftUI

struct CharacterDetailView: View {
    
    @ObservedObject var viewModel: CharacterDetailViewModel = CharacterDetailViewModel()
    @EnvironmentObject var appState: AppState
    
    var character: Character
    
    @State private var showPopup = false
    @State private var popupMessage = ""
    
    var body: some View {
        
        NavigationView {
            
            VStack {
                
                Text(character.characterName)
                    .font(.largeTitle)
                    .padding()
                Text("\(character.characterDescription)")
                if (character.isPlayer) {
                    Text("player")
                } else {
                    Text("NPC")
                }
                
                Spacer()
                
                HStack {
                    Text("health: \(character.stats.health)")
                    ProgressView(value: Double(character.stats.health), total: 100)
                        .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                        .frame(height: 8)
                }
                HStack {
                    Text("attack: \(character.stats.attack)")
                    ProgressView(value: Double(character.stats.attack), total: 100)
                        .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                        .frame(height: 8)                }
                HStack {
                    Text("defense: \(character.stats.defense)")
                    ProgressView(value: Double(character.stats.defense), total: 100)
                        .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                        .frame(height: 8)                   }
                HStack {
                    Text("speed: \(character.stats.speed)")
                    ProgressView(value: Double(character.stats.speed), total: 100)
                        .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                        .frame(height: 8)
                }
                HStack {
                    Text("agility: \(character.stats.agility)")
                    ProgressView(value: Double(character.stats.agility), total: 100)
                        .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                        .frame(height: 8)
                }
                HStack {
                    Text("current hp: \(character.stats.hp)/\(character.stats.health)")
                    ProgressView(value: Double(character.stats.hp), total: Double(character.stats.health))
                        .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                        .frame(height: 8)
                        .onAppear {
                            let clampedHp = max(0, min(character.stats.hp, character.stats.health))
                        }
                }
                
                Spacer()
                
                Text("created by: \(viewModel.uidToUsername(uid: character.creatorID))")
                
                Divider()
                
                if let holding = character.heldItem {
                    Text("holding: \(viewModel.itemIdToItemName(itemID: holding))")
                } else {
                    Text("holding nothing")
                }
                
                Text("Bag")
                    .font(.title2)
                    .padding(.top)
                
                if let bag = character.bag {
                    
                    if bag.isEmpty {
                        Text("Bag is empty")
                            .foregroundColor(.gray)
                            .italic()
                    } else {
                        
                        let list: [String] = Array(bag.keys).sorted()
                        
                        List {
                            ForEach(list, id: \.self) { itemID in
                                HStack {
                                    Text(viewModel.itemIdToItemName(itemID: itemID))
                                    Spacer()
                                    if (viewModel.getItemType(itemID: itemID) != "equippable") {
                                        Text("Quantity: \(bag[itemID] ?? 0)")
                                    }
                                    Button("") {
                                        viewModel.itemID = itemID
                                        switch viewModel.getItemType(itemID: itemID) {
                                        case "consumable":
                                            popupMessage = "Consume \(viewModel.itemIdToItemName(itemID: itemID))?"
                                            viewModel.itemType = "consumable"
                                            viewModel.itemAction = { viewModel.consumeItem(characterID: character.characterID) }
                                        case "equippable":
                                            viewModel.itemType = "equippable"
                                            if (character.heldItem == viewModel.itemID) {
                                                viewModel.itemAction = { viewModel.unequip(characterID: character.characterID) }
                                                popupMessage = "Unequip \(viewModel.itemIdToItemName(itemID: itemID))?"
                                            } else {
                                                viewModel.itemAction = { viewModel.equipItem(characterID: character.characterID) }
                                                popupMessage = "Equip \(viewModel.itemIdToItemName(itemID: itemID))?"
                                            }
                                            
                                        case "passive":
                                            popupMessage = "\(viewModel.itemIdToItemName(itemID: itemID)) is passive."
                                            viewModel.itemType = "passive"
                                            viewModel.itemAction = { print("item is passive") }
                                        default:
                                            popupMessage = "Invalid item"
                                            viewModel.itemType = "unknown"
                                            viewModel.itemAction = { print("item is unknown") }
                                        }
                                        showPopup=true
                                    }.frame(width: 0, height: 0)
                                    Spacer()
                                    if itemID == character.heldItem {
                                        Image(systemName: "hand.palm.facing.fill")
                                    }
                                }
                            }
                        }
                    }
                    
                } else {
                    Text("Bag is empty")
                        .foregroundColor(.gray)
                        .italic()
                }
                
                
            }
            .padding()
            .alert(popupMessage, isPresented: $showPopup) {
                
                if (viewModel.itemType == "consumable" || viewModel.itemType == "equippable") {
                    Button("Yes", role: .none) {
                        viewModel.itemAction()
                    }
                    Button("No", role: .cancel) {
                        showPopup=false
                    }
                } else {
                    Button("OK", role: .cancel) {
                        showPopup=false
                    }
                }
                
            }
            
            
        }
        
        
    }
            
}
            
    
    

