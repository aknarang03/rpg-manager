//
//  ItemListView.swift
//  RPG Manager
//
//  Created by Anjali Narang  on 11/20/24.
//

import SwiftUI

struct ItemListView: View {
    
    @ObservedObject var viewModel: ItemListViewModel = ItemListViewModel()
    @EnvironmentObject var appState: AppState
        
    @State private var selectedStory: Story?
    
    // should move the logic used with these to view model..
    let userModel = UserModel.shared
    let storyModel = StoryModel.shared

    var body: some View {
        
        NavigationView {
                        
            List {
                
                ForEach(viewModel.items, id: \.itemID) { item in
                    NavigationLink(destination: ItemDetailView(item: item)) {
                        VStack(alignment: .leading) {
                            Text(item.itemName)
                            Text(item.itemDescription)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        .padding()
                    }
                    
                    .swipeActions {
                        
                        if userModel.currentUser?.uid == item.creatorID || userModel.currentUser?.uid == storyModel.currentStory?.creator {
                            
                            Button() {
                                viewModel.deleteItem(itemID: item.itemID)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                    }
                    
                }
                    
                    
            }
            .navigationBarTitle("Items")
            .navigationBarItems(
                trailing: Button(action: {}, label: {
                    NavigationLink(destination: AddItemView()) {
                         Text("Add")
                    }
                }
                                )
                )
                
        }
            
            
        }
        
    }
