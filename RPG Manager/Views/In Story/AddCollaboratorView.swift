//
//  AddCollaboratorView.swift
//  RPG Manager
//
//  Created by Anjali Narang  on 11/20/24.
//

import SwiftUI

struct AddCollaboratorView: View {
    
    @ObservedObject var viewModel: AddCollaboratorViewModel = AddCollaboratorViewModel()
    @EnvironmentObject var appState: AppState

    var body: some View {
        
        NavigationView {
            
            VStack {
                TextField(
                    "username",
                    text: $viewModel.username
                )
                .padding(.top)
                
                Button ("Add") {
                    viewModel.addCollaborator()
                }
                
                Spacer()
                
            }
            
        }
        .navigationBarTitle("Add Collaborator")
        
    }
    
}
    
