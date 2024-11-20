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

    var body: some View {
        
        NavigationView {
            
            VStack {
                
                Text("Creator: \(viewModel.uidToUsername(uid: viewModel.getCreator()))")
                    .font(.headline)
                    .padding(.top)
                    .padding(.horizontal)
                
                List {
                    
                    ForEach(viewModel.collaborators, id: \.self) { collaborator in
                        
                        VStack(alignment: .leading) {
                            Text(viewModel.uidToUsername(uid: collaborator))
                            //                        Button("go") {
                            //                            viewModel.tappedCollaborator(collaborator: collaborator,
                            //                                onSuccess: {
                            //                                    // nav to collaborator
                            //                                },
                            //                                onFailure: { errorMessage in
                            //                                    print(errorMessage)
                            //                                }
                            //                            )
                            //                        }
                        }
                        
                        
                        .padding()
                    }
                    
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
