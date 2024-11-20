//
//  CharacterListView.swift
//  RPG Manager
//
//  Created by Anjali Narang  on 11/20/24.
//

import SwiftUI

struct CharacterListView: View {
    
    @ObservedObject var viewModel: CharacterListViewModel = CharacterListViewModel()
    @EnvironmentObject var appState: AppState
        
    @State private var selectedStory: Story?

    var body: some View {
        
        NavigationView {
                        
            List {
                
                ForEach(viewModel.characters, id: \.characterID) { character in
                    NavigationLink(destination: CharacterDetailView(character: character)) {
                        VStack(alignment: .leading) {
                            Text(character.characterName)
                            Text("created by \(viewModel.uidToUsername(uid: character.creatorID))")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        .padding()
                    }
                }
                    
                    
            }
            .navigationBarTitle("Characters")
            .navigationBarItems(
                trailing: Button(action: {}, label: {
                    NavigationLink(destination: AddCharacterView()) {
                         Text("Add")
                    }
                }
                                )
                )
                
        }
            
            
        }
        
    }
    

