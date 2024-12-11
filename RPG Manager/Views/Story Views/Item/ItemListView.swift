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
    
    let userModel = UserModel.shared
    
    var body: some View {
        
        NavigationView {
                    
            List {
                
                ForEach(viewModel.items, id: \.itemID) { item in
                    NavigationLink(destination: ItemDetailView(item: item)) {
                        VStack(alignment: .leading) {
                            
                            HStack {
                                if let iconURLString = item.iconURL, let url = URL(string: iconURLString) {
                                    AsyncImage(url: url) { image in
                                        image.resizable()
                                            .scaledToFit()
                                            .frame(width: 30, height: 30)
                                    } placeholder: {
                                        ProgressView()
                                    }
                                }
                                Text(item.itemName)
                            }
                            
                            Text(item.itemDescription)
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
