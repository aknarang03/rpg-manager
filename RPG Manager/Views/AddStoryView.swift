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
            
            VStack {
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
                
                Button ("Add") {
                    viewModel.addStory()
                }
                
                Spacer()
                
                Button ("Add Collaborator Test") {
                    viewModel.addCollaboratorTest()
                }
                Button ("Add Character Test") {
                    viewModel.addCharacterTest()
                }
                
            }
            
        }
        .navigationBarTitle("Add Story")
        
    }
    
}
    
