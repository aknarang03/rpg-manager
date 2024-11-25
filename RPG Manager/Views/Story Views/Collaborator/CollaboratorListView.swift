//
//  CollaboratorListView.swift
//  RPG Manager
//
//  Created by Anjali Narang  on 11/20/24.
//

import SwiftUI

struct CollaboratorListView: View {
    
    @ObservedObject var viewModel: CollaboratorListViewModel = CollaboratorListViewModel()
    @EnvironmentObject var appState: AppState
    
    // should move the logic used with these to view model..
    let userModel = UserModel.shared
    let storyModel = StoryModel.shared

    var body: some View {
        
        NavigationView {
                
            List {
                
                VStack(alignment: .leading) {
                    HStack {
                        Text("\(viewModel.uidToUsername(uid: viewModel.getCreator()))")
                        Spacer()
                        Image(systemName: "crown.fill")
                            .foregroundColor(.gray)
                    }
                }.padding()
                
                ForEach(viewModel.collaborators, id: \.self) { collaborator in
                    
                    VStack(alignment: .leading) {
                        Text(viewModel.uidToUsername(uid: collaborator))
                    }
                    
                    .swipeActions {
                        
                        if userModel.currentUser?.uid == storyModel.currentStory?.creator {
                            
                            Button() {
                                viewModel.removeCollaborator(uid: collaborator)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                    }
                    
                    
                    .padding()
                }
                
            }
            
            .navigationBarTitle("Collaborators")
            .navigationBarItems(
                trailing: Button(action: {}, label: {
                    NavigationLink(destination: AddCollaboratorView()) {
                         Text("Add")
                    }
                }
                                )
                )
            
        }
        
    }
    
}
