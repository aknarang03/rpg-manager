//
//  MapView.swift
//  RPG Manager
//
//  Created by Anjali Narang  on 12/15/24.
//

import SwiftUI

struct MapView: View {
    
    @ObservedObject var viewModel: MapViewModel = MapViewModel()
    
    @State private var showInfo: Bool = false
    
    // move this stuff into view model

    var body: some View {
        
        NavigationView {
            
            VStack {
                
                if let imgurl = viewModel.currentStory!.mapImageURL, let url = URL(string: imgurl) {
                    
                    ZStack {
                        
                        MapImageView(url: url)
                        
                        ForEach(viewModel.mapItems, id: \.iconID) { item in
                            
                            if let iconUrl = URL(string: viewModel.getIcon(type: item.type, id: item.iconID)) {
                                
                                IconView(url: iconUrl) // Use IconView for each icon
                                    .id(item.iconID)
                                    .position(CGPoint(x: item.coordinates.x, y: item.coordinates.y))
                                    .gesture(
                                        DragGesture()
                                            .onChanged { value in
                                                print(iconUrl)
                                                if let index = viewModel.mapItems.firstIndex(where: { $0.iconID == item.iconID }) {
                                                    viewModel.mapItems[index].coordinates = Coordinates(x: value.location.x, y: value.location.y)
                                                    viewModel.updatePosition(item: viewModel.mapItems[index])
                                                }
                                            } // gesture onchange
                                        
                                    ) // gesture
                                
                            }
                            
                        } // foreach
                        
                    } // zstack
                    
                } // map img already there condition
                
                else {
                    
                    Text("Please upload a map image")
                    
                }
                
            } // vstack
            .navigationBarItems(
                
                leading: Button(action: {
                    showInfo = true
                }
                               ) {
                                   Image(systemName: "info.circle")
                               },
                trailing:
                    MapImgPicker { mapImg in
                        viewModel.updateStoryMapImg(image: mapImg)
                }
            )
            .sheet(isPresented: $showInfo) {
                InfoView()
            }
            .onAppear {
                //viewModel.observe()
                viewModel.refreshMapItems()
            }
            .onDisappear {
                //viewModel.stopObserve()
            }
            //.onAppear {
            //}
            
        } // nav view
        
    } // view
    
}

struct DraggableIcon: Identifiable {
    let id = UUID()
    var view: AnyView
    var position: CGPoint
}
