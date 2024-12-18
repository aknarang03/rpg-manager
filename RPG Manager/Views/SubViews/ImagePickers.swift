//
//  PhotoPicker.swift
//  RPG Manager
//
//  Created by Anjali Narang  on 12/14/24.
//


import SwiftUI
import PhotosUI

@available(iOS 16.0, *)
struct IconPicker: View {
    
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImageData: Data? = nil
    var updateIcon: (UIImage) -> Void
    
    var body: some View {
        
        PhotosPicker(
            
            selection: $selectedItem,
            matching: .images,
            photoLibrary: .shared()) {
                Text("Upload icon")
            }
        
            .onChange(of: selectedItem) {
                
                if let img = selectedItem {
                    
                    Task {
                        if let data = try? await img.loadTransferable(type: Data.self),
                           let uiImage = UIImage(data: data) {
                            selectedImageData = data
                            updateIcon(uiImage)
                        }
                    }
                    
                    
                }
                
            }
        
    }
    
}

@available(iOS 16.0, *)
struct MapImgPicker: View {
    
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImageData: Data? = nil
    var updateImage: (UIImage) -> Void
    
    var body: some View {
        
        PhotosPicker(
            selection: $selectedItem,
            matching: .images,
            photoLibrary: .shared()
        ) {
            Image(systemName: "square.and.arrow.up")
                .font(.title2)
                .foregroundColor(.blue)
        }
        .onChange(of: selectedItem) {
            
            if let img = selectedItem {
                
                Task {
                    if let data = try? await img.loadTransferable(type: Data.self),
                       let uiImage = UIImage(data: data) {
                        selectedImageData = data
                        updateImage(uiImage)
                    }
                }
                
                
            }
            
        }
    }
    
}
