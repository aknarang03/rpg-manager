//
//  StoryModel.swift
//  RPG Manager
//
//  Created by Anjali Narang  on 11/18/24.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

class StoryModel {
    
    static let shared = StoryModel()
    
    var msgObserverHandle: UInt?
    
    let storyDBRef = Database.database().reference(withPath: "Stories")
    
    @Published var currentStory: Story?
    @Published var stories:[Story] = []
    
    // watch for updates from Story realtime database table
    func observeItems() {
        print("observe items")
        msgObserverHandle = storyDBRef.observe(.value, with: {snapshot in
            var tempStories:[Story] = []
            for child in snapshot.children {
                print("in for loop")
                if let data = child as? DataSnapshot {
                    if let story = Story(snapshot: data) {
                        tempStories.append(story)
                    } else {
                        print("cannot append")
                    }
                }
            }
            self.stories.removeAll()
            self.stories = tempStories // update the list stored in this model
            print("stories in observeItems: \(self.stories.count)")
        })
    }
    
    // stop listening for updates
    func cancelObserver() {
        print("cancel observer")
        if let observerHandle = msgObserverHandle {
            storyDBRef.removeObserver(withHandle: observerHandle)
        }
    }
    
    // get Story item based on item id using this model's saved data
    func getItem(id: String) -> Story? {
        return stories.first { $0.storyID == id }
    }
    
    // post a new item to Story database table
    func postNewItem(story: Story) {
        let storyDBRef = Database.database().reference(withPath: "Stories")
        let newStoryRef = storyDBRef.child(story.storyID)
        newStoryRef.setValue(story.toAnyObject())
    }
    
    // update an item (works the same way; just replaces old item under same ID)
    func updateItem(story: Story) {
        let storyDBRef = Database.database().reference(withPath: "Stories")
        let newStoryRef = storyDBRef.child(story.storyID)
        newStoryRef.setValue(story.toAnyObject())
    }
    
    // remove an item from Story database table
    func deleteItem(story: Story) {
        let storyDBRef = Database.database().reference(withPath: "Stories")
        let storyRef = storyDBRef.child(story.storyID)
        storyRef.removeValue()
    }
    
}
