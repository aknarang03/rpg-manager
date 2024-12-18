//
//  InfoView.swift
//  RPG Manager
//
//  Created by Anjali Narang  on 12/17/24.
//

import SwiftUI

struct InfoView: View {
    
    @ObservedObject var viewModel: InfoViewModel = InfoViewModel()
    @EnvironmentObject var appState: AppState
        
    let userModel = UserModel.shared
    
    var body: some View {
        
        NavigationView {
            
            VStack {
                
                Text(viewModel.currentStory.storyName)
                    .font(.largeTitle)
                    .padding()
                Text(viewModel.currentStory.storyDescription)
                
                Spacer()
                Spacer()
                                
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
                            
                            if youAreCurrentStoryCreator() {
                                
                                Button() {
                                    viewModel.removeCollaborator(uid: collaborator)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                        }
                        
                        
                        .padding()
                    }
                    
                } // list
                
                NavigationLink(destination: AddCollaboratorView()) {
                     Text("Add Collaborator")
                }
                
                Spacer()
                Spacer()
                
                if (userModel.currentUser?.uid) != nil {
                    if youAreCurrentStoryCreator() {
                        Spacer()
                        Button("Delete Story") {
                            viewModel.deleteStory()
                            appState.isInStory = false
                        }
                    }
                }
                
            }
            
            .navigationBarItems(
                leading: Button("Stories") { appState.isInStory = false }
            )
            
        }
            
    }
    
}
