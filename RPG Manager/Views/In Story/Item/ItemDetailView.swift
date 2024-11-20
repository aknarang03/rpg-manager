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
    
    var item: Item
    
    // pass item to view model
    init(item: Item) {
        _viewModel = ObservedObject(wrappedValue: ItemDetailViewModel(item: item))
        self.item = item
    }
    
    var body: some View {
        
        NavigationView {
            
            VStack {
                
                Text(item.itemName)
                    .font(.largeTitle)
                    .padding()
                Text("description: \(item.itemDescription)")
                Text("impacts: \(item.impactsWhat)")
                Text("impact: \(item.impact)")

                Spacer()
                
                Text("created by: \(viewModel.uidToUsername(uid: item.creatorID))")
                
                Spacer()
                
                Button("test add item to bag") {
                    viewModel.testAddItemToBag()
                }

                
            }
            
        }
            
    }
    
}
