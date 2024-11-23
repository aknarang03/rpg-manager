//
//  CharacterDetailView.swift
//  RPG Manager
//
//  Created by Anjali Narang  on 11/20/24.
//


import SwiftUI

struct CharacterDetailView: View {
        
    @ObservedObject var viewModel: CharacterDetailViewModel
    @EnvironmentObject var appState: AppState
    
    var character: Character
    
    // pass character to view model
    init(character: Character) {
        _viewModel = ObservedObject(wrappedValue: CharacterDetailViewModel(character: character))
        self.character = character
    }
    
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
                    Text("health: \(viewModel.stats.health)")
                    ProgressView(value: Double(viewModel.stats.health), total: 100)
                        .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                        .frame(height: 8)
                }
                HStack {
                    Text("attack: \(viewModel.stats.attack)")
                    ProgressView(value: Double(viewModel.stats.attack), total: 100)
                        .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                        .frame(height: 8)                }
                HStack {
                    Text("defense: \(viewModel.stats.defense)")
                    ProgressView(value: Double(viewModel.stats.defense), total: 100)
                        .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                        .frame(height: 8)                   }
                HStack {
                    Text("speed: \(viewModel.stats.speed)")
                    ProgressView(value: Double(viewModel.stats.speed), total: 100)
                        .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                        .frame(height: 8)
                }
                HStack {
                    Text("agility: \(viewModel.stats.agility)")
                    ProgressView(value: Double(viewModel.stats.agility), total: 100)
                        .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                        .frame(height: 8)
                }
                HStack {
                    Text("current hp: \(viewModel.stats.hp)/\(viewModel.stats.health)")
                    ProgressView(value: Double(viewModel.stats.hp), total: Double(viewModel.stats.health))
                        .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                        .frame(height: 8)
//                        .onAppear {
//                            let clampedHp = max(0, min(viewModel.stats.hp, viewModel.stats.health))
//                        }
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
                                                                        
                        List {
                           ForEach(bag.keys.sorted(), id: \.self) { itemID in
                               
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
                                               viewModel.itemAction = { viewModel.unequipItem(characterID: character.characterID) }
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
                                   
                                   Spacer()
                                   
                                   Button(action: {
                                       viewModel.deleteItem(characterID: character.characterID)
                                   }) {
                                       Image(systemName: "trash")
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
            
    
    

