//
//  CharacterDetailView.swift
//  RPG Manager
//
//  Created by Anjali Narang  on 11/20/24.
//


import SwiftUI

struct CharacterDetailView: View {
    
    @ObservedObject var viewModel: CharacterDetailViewModel = CharacterDetailViewModel()
    @EnvironmentObject var appState: AppState
    
    var character: Character
    
    var body: some View {
        
        NavigationView {
            
            VStack {
                
                Text(character.characterName)
                    .font(.largeTitle)
                    .padding()
                Text("attack: \(character.stats.attack)")
                Text("defense: \(character.stats.defense)")
                Text("speed: \(character.stats.speed)")
                Text("agility: \(character.stats.agility)")

                Spacer()
                
                Text("created by: \(viewModel.uidToUsername(uid: character.creatorID))")

                
            }
            
        }
            
    }
    
}
