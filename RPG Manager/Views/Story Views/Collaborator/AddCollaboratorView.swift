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
                    
        VStack {
            TextField(
                "username",
                text: $viewModel.username
            )
            .autocapitalization(.none)
            .disableAutocorrection(true)
            .padding(.top)
            
            Button ("Add") {
                viewModel.addCollaborator()
            }.disabled(viewModel.username == "")
            
            Spacer()
            
        }
            
        .navigationBarTitle("Add Collaborator")
        
    }
    
}
    
