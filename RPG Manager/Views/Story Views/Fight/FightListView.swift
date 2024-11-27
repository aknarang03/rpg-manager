//
//  FightListView.swift
//  RPG Manager
//
//  Created by Anjali Narang  on 11/26/24.
//


import SwiftUI

struct FightListView: View {
    
    @ObservedObject var viewModel: FightListViewModel = FightListViewModel()
    //@EnvironmentObject var appState: AppState
    
    // should move the logic used with these to view model..
    let userModel = UserModel.shared
    let storyModel = StoryModel.shared

    var body: some View {
        
        NavigationView {
                
            List {
                
                ForEach(viewModel.fights, id: \.fightID) { fight in
                    
                    NavigationLink(destination: FightDetailView(fight: fight)) {
                        VStack(alignment: .leading) {
                            Text("\(viewModel.getCharacterName(characterID: fight.character1ID)) vs \(viewModel.getCharacterName(characterID: fight.character2ID))")
                        }
                        .padding()
                    }
                    
                    
                    
//                    .swipeActions {
//                        
//                        if userModel.currentUser?.uid == storyModel.currentStory?.creator {
//                            
//                            Button() {
//                                viewModel.removeFight(fightID: fight.fightID)
//                            } label: {
//                                Label("Delete", systemImage: "trash")
//                            }
//                        }
//                    }
                    
                    
                    .padding()
                }
                
            }
            
            .navigationBarTitle("Fights")
            
        }
        
    }
    
    
}
