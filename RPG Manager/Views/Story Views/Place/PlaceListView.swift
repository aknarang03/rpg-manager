//
//  PlaceListView.swift
//  RPG Manager
//
//  Created by Anjali Narang  on 12/17/24.
//


import SwiftUI

struct PlaceListView: View {
    
    @State private var showInfo: Bool = false
    
    @ObservedObject var viewModel: PlaceListViewModel = PlaceListViewModel()
    @EnvironmentObject var appState: AppState
        
    @State private var selectedStory: Story?
    
    let userModel = UserModel.shared
    
    var body: some View {
        
        NavigationView {
                    
            List {
                
                ForEach(viewModel.places, id: \.placeID) { place in
                    NavigationLink(destination: PlaceDetailView(place: place)) {
                        VStack(alignment: .leading) {
                            
                            HStack {
                                if let iconURLString = place.iconURL, let url = URL(string: iconURLString) {
                                    IconView(url: url)
                                }
                                Text(place.placeName)
                            }
                            
                            Text(place.placeDescription)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        .padding()
                    }
                    
                }
                    
                    
            }
            .navigationBarTitle("Places")
            .navigationBarItems(
                
                leading: Button(action: {
                    showInfo = true
                }
                               ) {
                    Image(systemName: "gearshape")
                },
                
                trailing: Button(action: {}, label: {
                    NavigationLink(destination: AddPlaceView()) {
                         Text("Add Place")
                    }
                }
                                )
                )
            .sheet(isPresented: $showInfo) {
                InfoView()
            }
                
        }
            
            
        }
        
    }
