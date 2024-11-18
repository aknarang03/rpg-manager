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
                        
            List($viewModel.stories) { story in
                VStack(alignment: .leading) {
                    Text(story.creator)
                    Text(story.description)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding()
            }
            .navigationBarTitle("Stories")
            
        }
        
    }
    
}
