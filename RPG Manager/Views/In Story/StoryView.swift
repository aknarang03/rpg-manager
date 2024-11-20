//
//  StoryNavigationView.swift
//  RPG Manager
//
//  Created by Anjali Narang  on 11/20/24.
//

import SwiftUI

struct StoryView: View {
    
    @ObservedObject var viewModel: StoryViewModel = StoryViewModel()
    
    var body: some View {
        
        TabView {
            StoryDetailView()
                .tabItem {
                    Label("Details", systemImage: "info.circle.fill")
                }
            CharacterListView()
                .tabItem {
                    Label("Characters", systemImage: "person.bust.fill")
                }
            CollaboratorListView()
                .tabItem {
                    Label("Collaborators", systemImage: "person.3.fill")
                }
            
        }
        .onAppear {
            viewModel.startObserving()
        }
        .onDisappear {
            viewModel.stopObserving()
        }
        
    }
    
    
}
