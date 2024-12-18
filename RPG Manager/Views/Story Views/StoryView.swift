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
            CharacterListView()
                .tabItem {
                    Label("Characters", systemImage: "figure.2")
                }
            ItemListView()
                .tabItem {
                    Label("Items", systemImage: "cross.vial.fill")
                }
            FightView()
                .tabItem {
                    Label("Fight", systemImage: "flame.fill")
                }
            MapView()
                .tabItem {
                    Label("Map", systemImage: "map.fill")
                }
            InfoView()
                .tabItem {
                    Label("Info", systemImage: "info.circle.fill")
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
