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
    @State private var mapImage: UIImage? = nil
    @State private var icons: [DraggableIcon] = []
    
    var body: some View {
        
        NavigationView {
            
            VStack {
                
                if let imgurl = viewModel.currentStory!.mapImageURL, let url = URL(string: imgurl) {
                    
                    ZStack {
                        
                        MapImageView(url: url)
                        
                        ForEach(viewModel.mapItems, id: \.iconID) { item in
                            
                            if let iconUrl = URL(string: viewModel.getIcon(type: item.type, id: item.iconID)) {
                                
                                IconView(url: iconUrl) // Use IconView for each icon
                                    .position(CGPoint(x: item.coordinates.x, y: item.coordinates.y))
                                    .gesture(
                                        DragGesture()
                                            .onChanged { value in
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
                    HStack {
                        Button(action: {
                            let newIcon = DraggableIcon(view: AnyView(Circle().fill(Color.red).frame(width: 40, height: 40)), position: CGPoint(x: 100, y: 100))
                            icons.append(newIcon)
                            }, label: {
                            Image(systemName: "plus")
                            }
                        )
                        MapImgPicker { mapImg in
                           mapImage = mapImg
                       }
                }
            )
            .sheet(isPresented: $showInfo) {
                InfoView()
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
