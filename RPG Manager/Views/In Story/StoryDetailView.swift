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
        
    // should move the logic used with these to view model..
    let userModel = UserModel.shared
    let storyModel = StoryModel.shared

    
    var body: some View {
        
        NavigationView {
            
            VStack {
                
                Text(viewModel.currentStory.storyName)
                    .font(.largeTitle)
                    .padding()
                Text("amount of characters is \(viewModel.currentCharacters.count)")
                Text("amount of items is \(viewModel.currentItems.count)")
                Text("amount of collaborators is \(viewModel.currentCollaborators.count)")
                
                Spacer()
                
                if let userid = userModel.currentUser?.uid {
                    if userid == storyModel.currentStory?.creator {
                        Button("Delete Story") {
                            viewModel.deleteStory()
                            appState.isInStory = false
                        }
                    }
                }
                
            }
            
            .navigationBarItems(
                leading: Button("List") { appState.isInStory = false }
            )
            
        }
            
    }
    
}
