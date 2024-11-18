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

    var body: some View {
        
        NavigationView {
                        
            List {
                
                ForEach(viewModel.stories.indices, id: \.self) { index in
                                        
                    VStack(alignment: .leading) {
                        
                        Text(viewModel.stories[index].creator)
                        Text(viewModel.stories[index].storyID)
                            .font(.subheadline)
                            .foregroundColor(.gray)
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
