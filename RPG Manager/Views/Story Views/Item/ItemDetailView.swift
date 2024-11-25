//
//  ItemDetailView.swift
//  RPG Manager
//
//  Created by Anjali Narang  on 11/20/24.
//


import SwiftUI

struct ItemDetailView: View {
    
    @ObservedObject var viewModel: ItemDetailViewModel
    @EnvironmentObject var appState: AppState
    
    @Environment(\.dismiss) private var dismiss
    
    var item: Item
    
    // pass item to view model
    init(item: Item) {
        _viewModel = ObservedObject(wrappedValue: ItemDetailViewModel(item: item))
        self.item = item
    }
    
    // should move the logic used with these to view model..
    let userModel = UserModel.shared
    let storyModel = StoryModel.shared
    
    var body: some View {
        
        NavigationView {
            
            VStack {
                
                Text(item.itemName)
                    .font(.largeTitle)
                    .padding()
                Text(item.itemDescription)
                
                Spacer()
                
                if item.impact > 0 {
                    Text("impact: +\(item.impact) \(item.impactsWhat)")
                } else {
                    Text("impact: \(item.impact) \(item.impactsWhat)")
                }
                Text("type: \(item.type)")

                Spacer()
                
                Text("created by: \(viewModel.uidToUsername(uid: item.creatorID))")
                
                Spacer()
                Divider()
                Spacer()
                                
                // Dropdown to select character
                Picker("Character", selection: $viewModel.characterID) {
                    ForEach(viewModel.characters, id: \.characterID) { character in
                        Text(character.characterName).tag(character.characterID)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .padding()

                Button("Give Item to Character") {
                    viewModel.addItemToBag()
                    if (viewModel.item.type == "passive") {
                        viewModel.applyPassiveStatChanges()
                    }
                }
                .padding()
                .disabled(viewModel.characterID.isEmpty)

                Spacer()
                
                if let userid = userModel.currentUser?.uid {
                    if userid == storyModel.currentStory?.creator || userid == item.creatorID {
                        Button("Delete Item") {
                            viewModel.deleteItem()
                            dismiss()
                        }
                        Spacer()
                    }
                }
                
            }
            
        }
            
    }
    
}
