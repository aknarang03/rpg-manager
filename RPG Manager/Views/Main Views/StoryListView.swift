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
    
    let userModel = UserModel.shared
    
    @State private var selectedStory: Story?

    var body: some View {
        
        NavigationView {
                        
            List {
                
                ForEach(viewModel.stories, id: \.storyID) { story in
                                                        
                    VStack(alignment: .leading) {
                        
                        HStack {
                            Text(story.storyName)
                            Spacer()
                            if let yourUid = userModel.currentUser?.uid {
                                if (story.creator == yourUid) {
                                    Image(systemName: "crown.fill")
                                        .foregroundColor(.gray)
                                }
                                else {
                                    Image(systemName: "sharedwithyou")
                                        .foregroundColor(.gray)
                                }
                            }

                        }
                        
                        Text(story.storyDescription)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        Button("") {
                            viewModel.tappedStory(story: story,
                                onSuccess: {
                                    appState.isInStory = true
                                },
                                onFailure: { errorMessage in
                                    print(errorMessage)
                                }
                            )
                        }.frame(width: 0, height: 0)
                    }
                    
                    .padding(5)
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
            
        }
        
    }
    
}
