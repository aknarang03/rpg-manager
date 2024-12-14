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
    
    let userModel = UserModel.shared

    var body: some View {
        
        NavigationView {
                        
            List {
                
                ForEach(viewModel.characters, id: \.characterID) { character in
                    NavigationLink(destination: CharacterDetailView(character: character)) {
                        VStack(alignment: .leading) {
                            HStack {
                                if let iconURLString = character.iconURL, let url = URL(string: iconURLString) {
                                    IconView(url: url)
                                }
                                Text(character.characterName)
                                Spacer()
                                if (userModel.currentUser?.uid) != nil {
                                    if (youAreCharacterCreator(character: character)) {
                                        Image(systemName: "star.fill")
                                            .foregroundColor(.gray)
                                    }
                                }
                                Image(systemName: character.alive ? "heart.fill" : "heart.slash.fill")
                                    .foregroundColor(.gray)
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
    

