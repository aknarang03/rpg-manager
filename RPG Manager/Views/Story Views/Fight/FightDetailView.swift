//
//  FightDetailView.swift
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
                Spacer()
                
            } // complete view condition
            
            else {
                
                Button("Resume Fight") {
                    NavigationUtil.popToRootView()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        NotificationCenter.default.post(name: Notification.Name("resumeFight"), object: fight)
                    }
                }
                
            } // incomplete view condition
            
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
        
            
        .navigationBarTitle("\(viewModel.getCharacterName(characterID: fight.character1ID)) vs \(viewModel.getCharacterName(characterID: fight.character2ID))")
        
    }
    
    
}
