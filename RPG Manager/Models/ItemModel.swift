//
//  ItemsModel.swift
//  RPG Manager
//
//  Created by Anjali Narang  on 11/30/24.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import PhotosUI

class ItemModel {
    
    static let shared = ItemModel()
    
    var itemObserverHandle: UInt?
    @Published var currentItems: [Item] = []

    let storyModel = StoryModel.shared
    let storyDBRef = Database.database().reference(withPath: "Stories")
    
    func getItemName(for itemID: String) -> String? {
        return currentItems.first(where: { $0.itemID == itemID })?.itemName
    }
    
    func getIconUrl(for itemID: String) -> String? {
        return currentItems.first(where: { $0.itemID == itemID })?.iconURL
    }
    
    func getItem(for itemID: String) -> Item? {
        return currentItems.first(where: { $0.itemID == itemID })
    }
    
    func addItemToStory(item: Item) {
        let storyRef = Database.database().reference().child("Stories").child(storyModel.currentStoryID)
        let itemRef = storyRef.child("Items").child(item.itemID)
        itemRef.setValue(item.toAnyObject())
    }
    
    func deleteItem(itemID: String) {
        let storyRef = Database.database().reference().child("Stories").child(storyModel.currentStoryID)
        let itemRef = storyRef.child("Items").child(itemID)
        itemRef.removeValue()
    }
    
    func observeCurrentItems() {
        
        if let story: Story = storyModel.currentStory {
            
            print("observing items for story: \(story.storyID)")
            
            let itemsRef = storyDBRef.child(story.storyID).child("Items")
            
            itemObserverHandle = itemsRef.observe(.value, with: { snapshot in
                
                print("items snapshot: \(snapshot.value ?? "No data")")
                
                var tempItems: [Item] = []
                for child in snapshot.children {
                    if let data = child as? DataSnapshot,
                       let item = Item(snapshot: data) {
                        tempItems.append(item)
                    } else {
                        print("could not append")
                    }
                }
                self.currentItems.removeAll()
                self.currentItems = tempItems
                print("items in observeCurrentItems: \(self.currentItems.count)")
            })
        }
        
    }
    
    func cancelCurrentItemsObserver() {
        print("cancel current story item observer")
        if let story: Story = storyModel.currentStory {
            if let observerHandle = itemObserverHandle {
                let itemsRef = storyDBRef.child(story.storyID).child("Items")
                itemsRef.removeObserver(withHandle: observerHandle)
            }
        }
    }
    
    func uploadItemIcon(image: UIImage, imageID: String, itemID: String) {
        
        let storageRef = Storage.storage().reference()
        let imageRef = storageRef.child("images/\(imageID).png")
        
        guard let imageData = image.pngData() else {
            print("failed to get image data")
            return
        }
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/png"
        
        imageRef.putData(imageData, metadata: metadata) { metadata, error in
            
            if let error = error {
                print("cannot upload; \(error.localizedDescription)")
                return
            }

            // url for character
            imageRef.downloadURL { url, error in
                if let error = error {
                    print("cannot get download URL; \(error.localizedDescription)")
                } else if let url = url {
                    print("got download URL; \(url.absoluteString)")
                    self.updateItemIcon(itemID: itemID, imageURL: url.absoluteString)
                }
            }
        }
        
    }
    
    func updateItemIcon(itemID: String, imageURL: String) {
        let storyRef = Database.database().reference().child("Stories").child(storyModel.currentStoryID)
        if var item = self.getItem(for: itemID) {
            item.iconURL = imageURL
            let itemRef = storyRef.child("Items").child(item.itemID)
            itemRef.setValue(item.toAnyObject())
        }
    }
    
}
