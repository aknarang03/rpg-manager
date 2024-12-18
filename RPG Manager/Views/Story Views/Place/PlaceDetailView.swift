//
//  PlaceDetailView.swift
//  RPG Manager
//
//  Created by Anjali Narang  on 12/17/24.
//


import SwiftUI
import PhotosUI


struct PlaceDetailView: View {
    
    @ObservedObject var viewModel: PlaceDetailViewModel
    @EnvironmentObject var appState: AppState
    
    @Environment(\.dismiss) private var dismiss
    
    var place: Place
    
    // pass place to view model
    init(place: Place) {
        _viewModel = ObservedObject(wrappedValue: PlaceDetailViewModel(place: place))
        self.place = place
    }
    
    let userModel = UserModel.shared

    var body: some View {
        
        NavigationView {
            
            VStack {
                
                Text(place.placeName)
                    .font(.largeTitle)
                    .padding()
                Text(place.placeDescription)
                
                Spacer()
                
                if let iconURLString = place.iconURL, let url = URL(string: iconURLString) {
                    IconView(url: url)
                }
                
                Spacer()
                
                Text("created by: \(viewModel.uidToUsername(uid: place.creator))")
                
                Spacer()
                Divider()
                Spacer()
                          
                HStack {
                    
                    Spacer()
                    
                    IconPicker { image in
                        viewModel.updatePlaceIcon(image: image)
                    }
                    
                    if (userModel.currentUser?.uid) != nil {
                        if youAreCurrentStoryCreator() || youArePlaceCreator(place: place) {
                            Spacer()
                            Button("Delete") {
                                viewModel.deletePlace()
                                dismiss()
                            }
                        }
                    }
                    
                    Spacer()
                    
                }
                
                Spacer()
                
            }
            
        }
            
    }
    
}
