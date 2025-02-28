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
                    
        VStack {
            
            Spacer()
            
            TextField(
                "story name",
                text: $viewModel.storyName
            )
            .padding(.top)
            TextField(
                "story description",
                text: $viewModel.storyDescription
            )
            .padding(.top)
            
            Spacer()
            
            Button ("Add") {
                viewModel.addStory()
            }.disabled (viewModel.storyName == "")
            
            Spacer()
            
        }
            
        .navigationBarTitle("Add Story")
        
    }
    
}
    
