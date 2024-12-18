//
//  IconView.swift
//  RPG Manager
//
//  Created by Anjali Narang  on 12/14/24.
//

import SwiftUI

struct IconView: View {
    
    let url: URL
    
    var body: some View {
        
        AsyncImage(url: url) { image in
            image.resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
        } placeholder: {
            ProgressView()
        }
        
    }
    
}

struct MapImageView: View {
    
    let url: URL
    
    var body: some View {
        
        AsyncImage(url: url) { image in
            image.resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        } placeholder: {
            ProgressView()
        }
        
    }
    
}
