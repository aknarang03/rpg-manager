//
//  CharacterBagView.swift
//  RPG Manager
//
//  Created by Anjali Narang  on 11/26/24.
//

import SwiftUI

struct CharacterBagView: View {
    
    @ObservedObject var viewModel: CharacterBagViewModel
    
    var character: Character
    
    // pass character to view model
    init(character: Character) {
        _viewModel = ObservedObject(wrappedValue: CharacterBagViewModel(character: character))
        self.character = character
    }
        
    @State private var showPopup = false
    @State private var popupMessage = ""
    
    var body: some View {
        
        VStack {
            
            if let bag = character.bag {
                
                if bag.isEmpty {
                    Text("Bag is empty")
                        .foregroundColor(.gray)
                        .italic()
                }
                
                else {
                    
                    List {
                        
                        ForEach(bag.keys.sorted(), id: \.self) { itemID in
                            
                            HStack {
                                
                                if let iconURLString = viewModel.getItem(itemID: itemID).iconURL, let url = URL(string: iconURLString) {
                                    IconView(url: url)
                                }
                                
                                Text(viewModel.itemIdToItemName(itemID: itemID))
                                
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
                                    .disabled(character.alive == false)
                                
                                Spacer()
                                
                                if itemID == character.heldItem {
                                    Image(systemName: "hand.palm.facing.fill")
                                }
                                
                                if (viewModel.getItemType(itemID: itemID) != "equippable") {
                                    Text("x\(bag[itemID] ?? 0)")
                                        .foregroundColor(.gray)
                                }
                                
                            } // HStack
                            
                            .swipeActions {
                                
                                if (youAreCharacterCreator(character: character) || youAreCurrentStoryCreator()) && character.alive {
                                    
                                    Button() {
                                        viewModel.itemID = itemID
                                        viewModel.deleteItem(characterID: character.characterID)
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                    
                                }
                                
                            } // swipeActions
                            
                            
                        } // ForEach
                        
                        
                    } // List
                    
                }
                
            } else {
                Text("Bag is empty")
                    .foregroundColor(.gray)
                    .italic()
            }
            
        } // VStack
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
            
        } // alert
        
    } // View

}
