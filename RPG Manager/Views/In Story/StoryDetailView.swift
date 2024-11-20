//
//  StoryDetailView.swift
//  RPG Manager
//
//  Created by Anjali Narang  on 11/20/24.
//


import SwiftUI

struct StoryDetailView: View {
    
    @ObservedObject var viewModel: StoryDetailViewModel = StoryDetailViewModel()
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        
        NavigationView {
            
            VStack {
                
                Text(viewModel.currentStory.storyName)
                    .font(.largeTitle)
                    .padding()
                Text("amount of characters is \(viewModel.currentCharacters.count)")
                Text("amount of collaborators is \(viewModel.currentCollaborators.count)")
                
                Spacer()
                
            }
            
            .navigationBarItems(
                leading: Button("List") { appState.isInStory = false }
            )
            
        }
            
    }
    
}
