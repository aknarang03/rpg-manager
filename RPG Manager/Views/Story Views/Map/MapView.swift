//
//  MapView.swift
//  RPG Manager
//
//  Created by Anjali Narang  on 12/15/24.
//

import SwiftUI

struct MapView: View {
    
    @ObservedObject var viewModel: MapViewModel = MapViewModel()
    // I need to change it so that story is referenced in view model I think... so that updates happen right away
    
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
                        

//                        Image(uiImage: mapImage)
//                            .resizable()
//                            .scaledToFit()
//                            .frame(maxWidth: .infinity, maxHeight: .infinity)
//                            .background(Color.gray.opacity(0.2))
                        
                        ForEach(icons) { icon in
                            icon.view
                                .position(icon.position)
                                .gesture(
                                    
                                    DragGesture()
                                        .onChanged { value in
                                            if let index = icons.firstIndex(where: { $0.id == icon.id }) {
                                                icons[index].position = value.location
                                                // would update coordinates here.
                                            }
                                        } // gesture onchange
                                    
                                ) // gesture
                            
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
                            viewModel.updateStoryMapImg(image: mapImg)
                            //mapImage = mapImg
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
