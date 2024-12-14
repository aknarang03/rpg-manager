//
//  CharacterDetailView.swift
//  RPG Manager
//
//  Created by Anjali Narang  on 11/20/24.
//


import SwiftUI
import PhotosUI

struct CharacterDetailView: View {
        
    @ObservedObject var viewModel: CharacterDetailViewModel
    @EnvironmentObject var appState: AppState
    
    @Environment(\.dismiss) private var dismiss
    
    // NOTE TO SELF: I probably should only be referencing the view model character and not this one
    var character: Character
    
    // pass character to view model
    init(character: Character) {
        _viewModel = ObservedObject(wrappedValue: CharacterDetailViewModel(character: character))
        self.character = character
    }
    
    // should move the logic used with these to view model..
    let userModel = UserModel.shared
    
    @State private var showPopup = false
    @State private var popupMessage = ""
    
    var body: some View {
        
        NavigationView {
            
           // ScrollView {
                
                VStack {
                    
                    Text(character.characterName)
                        .font(.largeTitle)
                        .padding()
                    Text("\(character.characterDescription)")
                    Text("\(character.alive ? "alive" : "dead") \(character.isPlayer ? "player" : "NPC")")
                    
                    Spacer()
                    
                    if let iconURLString = character.iconURL, let url = URL(string: iconURLString) {
                        AsyncImage(url: url) { image in
                            image.resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 30)
                        } placeholder: {
                            ProgressView()
                        }
                    }
                                        
                    Spacer()
                    
                    StatsView(viewModel: viewModel)
                    
                    Spacer()
                    
                    Text("created by: \(viewModel.uidToUsername(uid: character.creatorID))")
                    
                    Spacer()
                    Divider()
                    Spacer()
                    
                    if character.heldItem == nil || character.heldItem == "" {
                        Text("holding nothing")
                    }
                    else if let holding = character.heldItem {
                        if let iconURLString = viewModel.getItem(itemID: holding).iconURL, let url = URL(string: iconURLString) {
                            AsyncImage(url: url) { image in
                                image.resizable()
                                    .scaledToFit()
                                    .frame(width: 30, height: 30)
                            } placeholder: {
                                ProgressView()
                            }
                        }
                        Text("holding: \(viewModel.itemIdToItemName(itemID: holding))")
                    } else {
                        Text("holding nothing")
                    }
                    
                    Text("Bag")
                        .font(.title2)
                        .padding(.top)
                    
                    CharacterBagView(character: viewModel.character)
                    
                    Spacer()
                    
                    HStack {
                        
                        PhotoPicker { image in
                            viewModel.updateCharacterIcon(image: image)
                        }
                        
                        if character.alive == false {
                            Spacer()
                            Button("Revive") {
                                viewModel.reviveCharacter()
                            }
                        }

                        if (userModel.currentUser?.uid) != nil {
                            if youAreCurrentStoryCreator() || youAreCharacterCreator(character: character) {
                                Spacer()
                                Button("Delete") {
                                    viewModel.deleteCharacter()
                                    dismiss()
                                }
                            }
                        }
                        
                    }
                    
                    Spacer()
                    
                } // VStack
                .padding()
                
                
            //} // ScrollView
            
            
        } // NavigationView
        
    } // View
            
}


struct StatsView: View {
    
    let viewModel: CharacterDetailViewModel
    
    var body: some View {
        
        StatRow(label: "health", value: viewModel.stats.health)
        StatRow(label: "attack", value: viewModel.stats.attack)
        StatRow(label: "defense", value: viewModel.stats.defense)
        StatRow(label: "speed", value: viewModel.stats.speed)
        StatRow(label: "agility", value: viewModel.stats.agility)
        HStack {
            Text("current hp: \(viewModel.stats.hp)/\(viewModel.stats.health)")
            ProgressView(value: Double(viewModel.stats.hp), total: Double(viewModel.stats.health))
                .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                .frame(height: 8)
        }
        
    }
    
}

struct StatRow: View {
    
    var label: String
    var value: Int
    
    var body: some View {
        HStack {
            Text("\(label): \(value)")
            ProgressView(value: Double(value), total: 100)
                .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                .frame(height: 8)
        }
    }
    
}
