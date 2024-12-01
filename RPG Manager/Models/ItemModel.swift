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
    
    func getItem(for itemID: String) -> Item? {
        return currentItems.first(where: { $0.itemID == itemID })
    }
    
    func addItemToStory(storyID: String, item: Item) {
        let storyRef = Database.database().reference().child("Stories").child(storyID)
        let itemRef = storyRef.child("Items").child(item.itemID)
        itemRef.setValue(item.toAnyObject())
    }
    
    func deleteItem(storyID: String, itemID: String) {
        let storyRef = Database.database().reference().child("Stories").child(storyID)
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
    
}
