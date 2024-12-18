//
//  MapModel.swift
//  RPG Manager
//
//  Created by Anjali Narang  on 12/18/24.
//


import Foundation
import FirebaseAuth
import FirebaseDatabase

class MapItemModel {
    
    static let shared = MapItemModel()
    
    var mapItemObserverHandle: UInt?
    @Published var currentMapItems: [MapItem] = []

    let storyModel = StoryModel.shared
    let storyDBRef = Database.database().reference(withPath: "Stories")
    
    func getMapItem(for iconID: String) -> MapItem? {
        return currentMapItems.first(where: { $0.iconID == iconID })
    }
    
    func addMapItemToStory(mapItem: MapItem) {
        let storyRef = Database.database().reference().child("Stories").child(storyModel.currentStoryID)
        let mapItemRef = storyRef.child("MapItems").child(mapItem.iconID)
        mapItemRef.setValue(mapItem.toAnyObject())
    }
    
    func deleteMapItem(iconID: String) {
        let storyRef = Database.database().reference().child("Stories").child(storyModel.currentStoryID)
        let mapItemRef = storyRef.child("MapItems").child(iconID)
        mapItemRef.removeValue()
    }
    
    func observeCurrentMapItems() {
        
        if let story: Story = storyModel.currentStory {
            
            print("observing map items for story: \(story.storyID)")
            
            let mapItemsRef = storyDBRef.child(story.storyID).child("MapItems")
            
            mapItemObserverHandle = mapItemsRef.observe(.value, with: { snapshot in
                
                print("map items snapshot: \(snapshot.value ?? "No data")")
                
                var tempMapItems: [MapItem] = []
                for child in snapshot.children {
                    if let data = child as? DataSnapshot,
                       let mapItem = MapItem(snapshot: data) {
                        tempMapItems.append(mapItem)
                    } else {
                        print("could not append")
                    }
                }
                self.currentMapItems.removeAll()
                self.currentMapItems = tempMapItems
                print("items in observeCurrentMapItems: \(self.currentMapItems.count)")
            })
        }
        
    }
    
    func cancelCurrentMapItemsObserver() {
        print("cancel current story map item observer")
        if let story: Story = storyModel.currentStory {
            if let observerHandle = mapItemObserverHandle {
                let mapItemsRef = storyDBRef.child(story.storyID).child("MapItems")
                mapItemsRef.removeObserver(withHandle: observerHandle)
            }
        }
    }
    
}
