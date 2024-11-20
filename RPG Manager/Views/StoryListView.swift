//
//  StoryListView.swift
//  RPG Manager
//
//  Created by Anjali Narang  on 11/18/24.
//

import SwiftUI

struct StoryListView: View {
    
    @ObservedObject var viewModel: StoryListViewModel = StoryListViewModel()
    @EnvironmentObject var appState: AppState
    
    let storyModel = StoryModel.shared
    let userModel = UserModel.shared
    
    @State private var selectedStory: Story?

    var body: some View {
        
        NavigationView {
                        
            List {
                
                ForEach(viewModel.stories, id: \.storyID) { story in
                                                            
                    VStack(alignment: .leading) {
                        Text(story.storyName)
                        Text(story.storyDescription)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        Text("created by \(story.creator)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        Button("go") {
                            viewModel.tappedStory(story: story,
                                onSuccess: {
                                    appState.isInStory = true
                                },
                                onFailure: { errorMessage in
                                    print(errorMessage)
                                }
                            )
                        }
                    }
                    
                    
                    .padding()
                }
                
            }
            .navigationBarTitle("Stories")
            .navigationBarItems(
                leading: Button("Logout") { userModel.signOut(); appState.isLoggedIn = false },
                trailing: Button(action: {}, label: {
                    NavigationLink(destination: AddStoryView()) {
                         Text("Add Story")
                    }
                }
                                )
                )
            .onAppear {
                viewModel.startObserving()
            }
            .onDisappear {
                viewModel.stopObserving()
            }
            
        }
        
    }
    
}
