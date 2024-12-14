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
                
        VStack {
            
            Spacer()
            
            TextField(
                "item name",
                text: $viewModel.itemName
            )
            TextField(
                "item description",
                text: $viewModel.itemDescription
            )
            
            Spacer()
            
            HStack {
                Text("Impacts what?")
                Picker("Impacts what?", selection: $viewModel.impactsWhat) {
                    ForEach(ImpactsWhat.allCases, id:\.self) { value in
                        Text(value.rawValue)
                    }
                }
                .pickerStyle(MenuPickerStyle())
            }
            
            HStack {
                Text("impact: \(Int(viewModel.impact))")
                Slider(value: $viewModel.impact, in: -100...100, step: 1)
            }
            
            Spacer()
            
            HStack {
                Text("Type")
                Picker("Type", selection: $viewModel.type) {
                    ForEach(ItemType.allCases, id:\.self) { value in
                        Text(value.rawValue)
                    }
                }
                .pickerStyle(MenuPickerStyle())
            }
            
            Spacer()
            
            Button ("Add") {
                viewModel.addItem()
            }.disabled((viewModel.type.rawValue == "passive" || viewModel.type.rawValue == "equippable") && viewModel.impactsWhat.rawValue == "hp") // do not allow a passive or equippable item that impacts hp
            
            Spacer()
            
        }
        
        .navigationBarTitle("Add Item")
        
    }
    
}
    
