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
                leading: Button("Logout") { appState.isLoggedIn = false },
                trailing: Button("Add") {
                    NavigationLink("String", destination: AddStoryView())
                }
            )
            
        }
        
    }
    
}
