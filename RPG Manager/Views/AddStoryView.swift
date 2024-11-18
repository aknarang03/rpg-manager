//
//  AddStoryView.swift
//  RPG Manager
//
//  Created by Anjali Narang  on 11/18/24.
//

import SwiftUI

struct AddStoryView: View {
    
    @ObservedObject var viewModel: AddStoryViewModel = AddStoryViewModel()
    @EnvironmentObject var appState: AppState
    

    var body: some View {
        
        NavigationView {
            
            Button ("Test add") {
                viewModel.addStory()
            }
            
        }
        .navigationBarTitle("Add Story")
        
    }
    
}
    
