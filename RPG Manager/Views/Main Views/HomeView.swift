//
//  HomeVie.swift
//  RPG Manager
//
//  Created by Anjali Narang  on 11/25/24.
//

import SwiftUI

struct HomeView: View {
    
    @ObservedObject var viewModel: HomeViewModel = HomeViewModel()
    
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
            viewModel.resetCurrent()
            viewModel.startObserving()
        }
        .onDisappear {
            viewModel.stopObserving()
        }
        
    }
    
    
}
