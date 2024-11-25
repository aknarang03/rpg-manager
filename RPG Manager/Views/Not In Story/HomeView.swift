//
//  HomeVie.swift
//  RPG Manager
//
//  Created by Anjali Narang  on 11/25/24.
//

import SwiftUI

struct HomeView: View {
    
    @ObservedObject var viewModel: HomeViewModel = HomeViewModel()
    
    // should move the logic used with these to view model..
    let storyModel = StoryModel.shared
    
    var body: some View {
        
        TabView {
            StoryListView()
                .tabItem {
                    Label("Stories", systemImage: "books.vertical.fill")
                }
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.crop.circle")
                }
        }
        
        .onAppear {
            storyModel.currentStory = nil
            viewModel.startObserving()
        }
        .onDisappear {
            viewModel.stopObserving()
        }
        
    }
    
    
}
