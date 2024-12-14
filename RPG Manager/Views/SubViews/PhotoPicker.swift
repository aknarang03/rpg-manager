//
//  PhotoPicker.swift
//  RPG Manager
//
//  Created by Anjali Narang  on 12/14/24.
//


import SwiftUI
import PhotosUI

@available(iOS 16.0, *)
struct PhotoPicker: View {
    
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
