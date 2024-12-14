//
//  StoryModel.swift
//  RPG Manager
//
//  Created by Anjali Narang  on 11/18/24.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import PhotosUI

class StoryModel {
        
    static let shared = StoryModel()
    let userModel = UserModel.shared
    
    var storyObserverHandle: UInt?
    var collaboratorObserverHandle: UInt?
    var collaboratorObserverHandles: [String: UInt] = [:]
    
    let storyDBRef = Database.database().reference(withPath: "Stories")
    
    @Published var stories:[Story] = []
    
    @Published var currentStory: Story?
    @Published var currentStoryID: String = ""
    @Published var currentCollaborators: [String] = []
    
    func setCurrentStory(tappedOn: Story) {
        currentStory = tappedOn
        currentStoryID = currentStory!.storyID
    }
    
    
    func observeStories() {
        
        print("observe stories")
        
        storyObserverHandle = storyDBRef.observe(.value, with: { snapshot in
            
            var tempStories: [Story] = []
            
            for child in snapshot.children {
                if let data = child as? DataSnapshot,
                   let story = Story(snapshot: data) {
                    if let uid = self.userModel.currentUser?.uid {
                        if story.creator == uid || ((story.collaborators?.contains(uid)) != nil) {
                            tempStories.append(story)
                        }
                    }
                }
            }
            
            DispatchQueue.main.async {
                self.stories = tempStories
                print("stories in observeStories: \(self.stories.count)")
            }
        })
        
    }
    
    // stop listening for updates
    func cancelStoryObserver() {
        print("cancel observer")
        if let observerHandle = storyObserverHandle {
            storyDBRef.removeObserver(withHandle: observerHandle)
        }
    }
    
    // get Story item based on item id using this model's saved data
    func getStory(id: String) -> Story? {
        return stories.first { $0.storyID == id }
    }
    
    // post a new item to Story database table
    func postNewStory(story: Story) {
        let storyDBRef = Database.database().reference(withPath: "Stories")
        let newStoryRef = storyDBRef.child(story.storyID)
        newStoryRef.setValue(story.toAnyObject())
    }
    
    // update an item (works the same way; just replaces old item under same ID)
    func updateStory(story: Story) {
        let storyDBRef = Database.database().reference(withPath: "Stories")
        let newStoryRef = storyDBRef.child(story.storyID)
        newStoryRef.setValue(story.toAnyObject())
    }
    
    // remove a story from Story database table
    func deleteStory(storyID: String) {
        let storyDBRef = Database.database().reference(withPath: "Stories")
        let storyRef = storyDBRef.child(storyID)
        storyRef.removeValue()
    }
    
    func addCollaboratorToStory(collaboratorID: String) {
        let storyRef = Database.database().reference().child("Stories").child(currentStoryID)
        let collaboratorRef = storyRef.child("Collaborators").child(collaboratorID)
        collaboratorRef.setValue(true) // placeholder
    }
    
    func removeCollaboratorFromStory(collaboratorID: String) {
        let storyRef = Database.database().reference().child("Stories").child(currentStoryID)
        let collaboratorRef = storyRef.child("Collaborators").child(collaboratorID)
        collaboratorRef.removeValue()
    }
    
}
