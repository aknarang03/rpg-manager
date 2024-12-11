//
//  OtherFightView.swift
//  RPG Manager
//
//  Created by Anjali Narang  on 11/26/24.
//


import SwiftUI

struct FightDetailView: View {
    
    @ObservedObject var viewModel: FightDetailViewModel
    
    var fight: Fight
    
    // pass character to view model
    init(fight: Fight) {
        _viewModel = ObservedObject(wrappedValue: FightDetailViewModel(fight: fight))
        self.fight = fight
    }

    var body: some View {
        
        NavigationView {
            
            VStack {
                
                if (fight.complete) {
                    
                    if !(fight.winner == nil || fight.winner == "") {
                        
                        VStack {
                            
                            Text("Winner")
                                .font(.largeTitle)
                                .padding()
                            
                            Image(systemName: "crown.fill")
                                .foregroundColor(.gray)
                            
                            if let iconURLString = viewModel.getWinner().iconURL, let url = URL(string: iconURLString) {
                                AsyncImage(url: url) { image in
                                    image.resizable()
                                        .scaledToFit()
                                        .frame(width: 30, height: 30)
                                } placeholder: {
                                    ProgressView()
                                }
                            }
                            
                            Text(viewModel.getWinner().characterName)
                                .font(.title3)
                            
                        } // winner stack
                        
                    } // show winner condition
                    
                    else { // complete but no winner
                        
                        Text("ended with no winner")
                            .font(.title3)
                        
                    }
                    
                    Divider()
                    
                } // complete view condition
                
                Spacer()
                
                ScrollView {
                    
                    if let outcomes = viewModel.fight.outcomes {
                        
                        VStack() {
                            
                            ForEach(Array(outcomes.enumerated()), id: \.offset) { index, outcome in
                                Text(outcome)
                            }
                            
                        }
                        
                        
                    }
                    
                } // scroll view
                
            } // vstack
            
            
        }
        .navigationBarTitle("\(viewModel.getCharacterName(characterID: fight.character1ID)) vs \(viewModel.getCharacterName(characterID: fight.character2ID))")
        
    }
    
    
}
