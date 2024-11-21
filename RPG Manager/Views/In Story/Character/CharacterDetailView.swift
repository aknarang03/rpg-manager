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
                Text("is a player character?: \(character.isPlayer)")
                
                Spacer()
                
                Text("health: \(character.stats.health)")
                Text("attack: \(character.stats.attack)")
                Text("defense: \(character.stats.defense)")
                Text("speed: \(character.stats.speed)")
                Text("agility: \(character.stats.agility)")
                Text("current HP: \(character.stats.hp)/100")
                
                Spacer()
                
                Text("created by: \(viewModel.uidToUsername(uid: character.creatorID))")
                
                Divider()
                
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
                                    Text("Quantity: \(bag[itemID] ?? 0)")
                                    Button("") {
                                        viewModel.itemID = itemID
                                        popupMessage = "Consume \(viewModel.itemIdToItemName(itemID: itemID))?"
                                        showPopup=true
                                    }.frame(width: 0, height: 0)
                                }
                            }
                        }
                    }
                    
                } else {
                    Text("Bag is empty (err)")
                        .foregroundColor(.gray)
                        .italic()
                }
                
                
            }
            .padding()
            .alert(popupMessage, isPresented: $showPopup) {
                Button("Yes", role: .none) {
                    print("consume")
                    viewModel.consumeItem(characterID: character.characterID)
                }
                Button("No", role: .cancel) {
                    showPopup=false
                }
            }
            
            
        }
        
        
    }
            
}
            
    
    

