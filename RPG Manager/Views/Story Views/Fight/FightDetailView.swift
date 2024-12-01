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
            
            ScrollView {
                
                if let outcomes = viewModel.fight.outcomes {
                    
                    VStack() {
                        
                        
                        ForEach(Array(outcomes.enumerated()), id: \.offset) { index, outcome in
                            Text(outcome)
                                .padding(index % 2 == 0 ? 16 : 0) // doesnt work

                        }
                        
                    }
                    
                    
                }
                
            }
            
            
        }
        
    }
    
    
}
