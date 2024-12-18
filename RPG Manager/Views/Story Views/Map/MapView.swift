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
    @State private var isPhotoPickerPresented = false
    
    var body: some View {
        
        NavigationView {
            
            VStack {
                
                if let mapImage {
                    
                    ZStack {
                        
                        Image(uiImage: mapImage)
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color.gray.opacity(0.2))
                        
                        ForEach(icons) { icon in
                            icon.view
                                .position(icon.position)
                                .gesture(
                                    
                                    DragGesture()
                                        .onChanged { value in
                                            if let index = icons.firstIndex(where: { $0.id == icon.id }) {
                                                icons[index].position = value.location
                                            }
                                        } // gesture onchange
                                    
                                ) // gesture
                            
                        } // foreach
                        
                    } // zstack
                    
                    .overlay(
                        
                        Button("Add Icon") {
                            let newIcon = DraggableIcon(view: AnyView(Circle().fill(Color.red).frame(width: 40, height: 40)), position: CGPoint(x: 100, y: 100))
                            icons.append(newIcon)
                        }
                            .padding(), alignment: .topTrailing
                        
                    ) // overlay
                    
                } // map img already there condition
                
                else {
                    
                    Button("Upload Map") {
                        isPhotoPickerPresented = true
                    }
                    .padding()
                    
                }
                
            } // vstack
            .navigationBarItems(
                
                leading: Button(action: {
                    showInfo = true
                }
                               ) {
                                   Image(systemName: "info.circle")
                               }
            )
            .sheet(isPresented: $isPhotoPickerPresented) {
                PhotoPicker { mapimg in
                    mapImage = mapimg
                }
            }
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
