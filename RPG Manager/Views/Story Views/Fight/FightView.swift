//
//  FightView.swift
//  RPG Manager
//
//  Created by Anjali Narang  on 11/25/24.
//


import SwiftUI

struct FightView: View {
    
    //@ObservedObject var viewModel: FightViewModel = FightViewModel()
    
    @EnvironmentObject var appState: AppState
    @State var fightStarted = false
    
    // should move the logic used with these to view model..
    let userModel = UserModel.shared
    let storyModel = StoryModel.shared

    var body: some View {
        
        NavigationView {
            
            VStack {
                
                Spacer()
                
                if (!fightStarted) { // SETUP SCREEN CONTENT
                    Text("fight not started")
                }
                
                else { // FIGHT SCREEN CONTENT
                    Text("fight started")
                }
                
                Spacer()
                
                Button("toggle fight started") { fightStarted = !fightStarted }
                
                Spacer()
                
            }
            .navigationBarTitle("Fight")
            .navigationBarItems(
                trailing: Button("Fights") { }
            )
            
        }
            
    }
    
}
