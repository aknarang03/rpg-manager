//
//  ItemDetailView.swift
//  RPG Manager
//
//  Created by Anjali Narang  on 11/20/24.
//


import SwiftUI

struct ItemDetailView: View {
    
    @ObservedObject var viewModel: ItemDetailViewModel = ItemDetailViewModel()
    @EnvironmentObject var appState: AppState
    
    var item: Item
    
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

                
            }
            
        }
            
    }
    
}
