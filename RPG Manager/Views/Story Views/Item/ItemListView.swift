//
//  ItemListView.swift
//  RPG Manager
//
//  Created by Anjali Narang  on 11/20/24.
//

import SwiftUI

struct ItemListView: View {
    
    @State private var showInfo: Bool = false
    
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
                                    IconView(url: url)
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
                
                leading: Button(action: {
                    showInfo = true
                }
                               ) {
                    Image(systemName: "gearshape")
                },
                
                trailing: Button(action: {}, label: {
                    NavigationLink(destination: AddItemView()) {
                         Text("Add Item")
                    }
                }
                                )
                )
            .sheet(isPresented: $showInfo) {
                InfoView()
            }
                
        }
            
            
        }
        
    }
