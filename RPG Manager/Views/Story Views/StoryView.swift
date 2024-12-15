//
//  StoryNavigationView.swift
//  RPG Manager
//
//  Created by Anjali Narang  on 11/20/24.
//

import SwiftUI

struct StoryView: View {
    
    @ObservedObject var viewModel: StoryViewModel = StoryViewModel()
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        
        TabView {
            StoryDetailView()
                .tabItem {
                    Label("Details", systemImage: "info.circle.fill")
                }
            CharacterListView()
                .tabItem {
                    Label("Characters", systemImage: "figure.2")
                }
            FightView()
                .tabItem {
                    Label("Fight", systemImage: "flame.fill")
                }
            ItemListView()
                .tabItem {
                    Label("Items", systemImage: "cross.vial.fill")
                }
            MapView()
                .tabItem {
                    Label("Map", systemImage: "map.fill")
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
        .onChange(of: viewModel.isStoryDeleted) { oldval, newval in
            if newval {
                appState.isInStory = false
            }
        }
        
    }
    
    
}
