//
//  AddItemView.swift
//  RPG Manager
//
//  Created by Anjali Narang  on 11/20/24.
//


import SwiftUI

struct AddItemView: View {
    
    @ObservedObject var viewModel: AddItemViewModel = AddItemViewModel()
    @EnvironmentObject var appState: AppState

    var body: some View {
        
        NavigationView {
            
            VStack {
                TextField(
                    "item name",
                    text: $viewModel.itemName
                )
                .padding(.top)
                TextField(
                    "item description",
                    text: $viewModel.itemDescription
                )
                .padding(.top)
                TextField(
                    "impacts what", // make this a dropdown from enum
                    text: $viewModel.impactsWhat
                )
                .padding(.top)
                TextField(
                    "impact",
                    text: $viewModel.impact
                )
                .padding(.top)
                
                Button ("Add") {
                    viewModel.addItem()
                }
                
                Spacer()
                
            }
            
        }
        .navigationBarTitle("Add Item")
        
    }
    
}
    
