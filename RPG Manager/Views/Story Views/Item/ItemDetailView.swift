//
//  ItemDetailView.swift
//  RPG Manager
//
//  Created by Anjali Narang  on 11/20/24.
//


import SwiftUI
import PhotosUI


struct ItemDetailView: View {
    
    @ObservedObject var viewModel: ItemDetailViewModel
    @EnvironmentObject var appState: AppState
    
    @Environment(\.dismiss) private var dismiss
    
    var item: Item
    
    // pass item to view model
    init(item: Item) {
        _viewModel = ObservedObject(wrappedValue: ItemDetailViewModel(item: item))
        self.item = item
    }
    
    let userModel = UserModel.shared

    var body: some View {
        
        NavigationView {
            
            VStack {
                
                Text(item.itemName)
                    .font(.largeTitle)
                    .padding()
                Text(item.itemDescription)
                
                Spacer()
                
                if let iconURLString = item.iconURL, let url = URL(string: iconURLString) {
                    AsyncImage(url: url) { image in
                        image.resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                    } placeholder: {
                        ProgressView()
                    }
                }
                
                Spacer()
                
                if item.impact > 0 {
                    Text("impact: +\(item.impact) \(item.impactsWhat)")
                } else {
                    Text("impact: \(item.impact) \(item.impactsWhat)")
                }
                Text("type: \(item.type)")

                Spacer()
                
                Text("created by: \(viewModel.uidToUsername(uid: item.creatorID))")
                
                Spacer()
                Divider()
                Spacer()
                                
                // Dropdown to select character
                Picker("Character", selection: $viewModel.characterID) {
                    ForEach(viewModel.characters, id: \.characterID) { character in
                        Text(character.characterName).tag(character.characterID)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .padding()

                Button("Give Item to Character") {
                    viewModel.addItemToBag()
                    if (viewModel.item.type == "passive") {
                        viewModel.applyPassiveStatChanges()
                    }
                }
                .padding()
                .disabled(viewModel.characterID.isEmpty || !viewModel.selectedCharIsAlive())

                Spacer()
                
                HStack {
                    
                    Spacer()
                    
                    ItemPhotoPicker(viewModel: viewModel)
                    
                    if (userModel.currentUser?.uid) != nil {
                        if youAreCurrentStoryCreator() || youAreItemCreator(item: item) {
                            Spacer()
                            Button("Delete") {
                                viewModel.deleteItem()
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


@available(iOS 16.0, *)
struct ItemPhotoPicker: View {
    
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImageData: Data? = nil
    
    @ObservedObject var viewModel: ItemDetailViewModel

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
                            viewModel.updateItemIcon(image: uiImage)
                        }
                    }
                    
                    
                }
                
            }
        
    }
    
}
