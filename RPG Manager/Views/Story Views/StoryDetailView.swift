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
        
    let userModel = UserModel.shared
    
    var body: some View {
        
        NavigationView {
            
            VStack {
                
                Text(viewModel.currentStory.storyName)
                    .font(.largeTitle)
                    .padding()
                Text(viewModel.currentStory.storyDescription)
                
                Spacer()
                Spacer()
                
                if (userModel.currentUser?.uid) != nil {
                    if youAreCurrentStoryCreator() {
                        Spacer()
                        Button("Delete Story") {
                            viewModel.deleteStory()
                            appState.isInStory = false
                        }
                    }
                }
                
                Spacer()
                
            }
            
            .navigationBarItems(
                leading: Button("List") { appState.isInStory = false }
            )
            
        }
            
    }
    
}
