//
//  FightListView.swift
//  RPG Manager
//
//  Created by Anjali Narang  on 11/26/24.
//


import SwiftUI

struct FightListView: View {
    
    @ObservedObject var viewModel: FightListViewModel = FightListViewModel()
    
    var body: some View {
        
        NavigationView {
                
            List {
                
                ForEach(viewModel.fights, id: \.fightID) { fight in
                    
                    HStack {
                        
                        if let iconURLString = viewModel.getCharacter(characterID: fight.character1ID).iconURL, let url = URL(string: iconURLString) {
                            AsyncImage(url: url) { image in
                                image.resizable()
                                    .scaledToFit()
                                    .frame(width: 30, height: 30)
                            } placeholder: {
                                ProgressView()
                            }
                        } else {
                            Image(systemName: "questionmark.app.fill")
                                .foregroundColor(.gray)
                        }
                        
                        Image(systemName: "flame.fill")
                            .foregroundColor(.gray)
                        
                        if let iconURLString = viewModel.getCharacter(characterID: fight.character2ID).iconURL, let url = URL(string: iconURLString) {
                            AsyncImage(url: url) { image in
                                image.resizable()
                                    .scaledToFit()
                                    .frame(width: 30, height: 30)
                            } placeholder: {
                                ProgressView()
                            }
                        } else {
                            Image(systemName: "questionmark.app.fill")
                                .foregroundColor(.gray)
                        }
                        
                        NavigationLink(destination: FightDetailView(fight: fight)) {
                            VStack(alignment: .leading) {
                                Text("\(viewModel.getCharacterName(characterID: fight.character1ID)) vs \(viewModel.getCharacterName(characterID: fight.character2ID))")
                            }
                        }
                        
                        Spacer()
                        
                        Image(systemName: fight.complete ? "checkmark.circle" : "circle")               .foregroundColor(.gray)
                        
                    } //hstack
                    
                    .swipeActions {
                        
                        if youAreCurrentStoryCreator() {
                            
                            Button() {
                                viewModel.removeFight(fightID: fight.fightID)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                    }
                    
                    
                    .padding()
                }
                
            }
            
            .navigationBarTitle("Fights")
            
        }
        
    }
    
    
}
