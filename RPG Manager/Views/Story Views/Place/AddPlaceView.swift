//
//  AddPlaceView.swift
//  RPG Manager
//
//  Created by Anjali Narang  on 12/17/24.
//


import SwiftUI

struct AddPlaceView: View {
    
    @ObservedObject var viewModel: AddPlaceViewModel = AddPlaceViewModel()
    @EnvironmentObject var appState: AppState

    var body: some View {
                
        VStack {
            
            Spacer()
            
            TextField(
                "place name",
                text: $viewModel.placeName
            )
            TextField(
                "place description",
                text: $viewModel.placeDescription
            )
            
            Spacer()
                    
            Button ("Add") {
                viewModel.addPlace()
            }.disabled(viewModel.placeName == "")
            
        }
        
        .navigationBarTitle("Add Place")
        
    }
    
}
    
