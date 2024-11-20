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
                            Text("created by \(viewModel.uidToUsername(uid: item.creatorID))")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        .padding()
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
