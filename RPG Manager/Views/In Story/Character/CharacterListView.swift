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
    
    // should move the logic used with these to view model..
    let userModel = UserModel.shared

    var body: some View {
        
        NavigationView {
                        
            List {
                
                ForEach(viewModel.characters, id: \.characterID) { character in
                    NavigationLink(destination: CharacterDetailView(character: character)) {
                        VStack(alignment: .leading) {
                            HStack {
                                Text(character.characterName)
                                Spacer()
                                if let yourUid = userModel.currentUser?.uid {
                                    if (character.creatorID == yourUid) {
                                        Image(systemName: "star.circle.fill")
                                            .foregroundColor(.gray)
                                    }
                                }
                            }
                            Text(character.characterDescription)
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
    

