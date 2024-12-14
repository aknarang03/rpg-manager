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
    
    // watch for updates from Story realtime database table
    func observeStories() {
        print("observe stories")
        storyObserverHandle = storyDBRef.observe(.value, with: {snapshot in
            var tempStories:[Story] = []
            let dispatchGroup = DispatchGroup()
            for child in snapshot.children {
                if let data = child as? DataSnapshot {
                    dispatchGroup.enter()
                    
                    if let story = Story(snapshot: data) {
                        
                        print("story = story")
                        
                        self.observeStoryCollaborators(story: story) { collaborators in
                            
                            print("observe story collaborators")
                            
                            // add story if current user is creator or is a collaborator
                            if let uid = self.userModel.currentUser?.uid {
                                
                                print("got current uid: \(uid)")
                                
                                if story.creator == uid || collaborators.contains(uid) {
                                    print("creator or collaborator detected")
                                    tempStories.append(story)
                                    print ("temp stories: \(tempStories.count)")
                                }
                            }
                            
                            dispatchGroup.leave()
                            
                        }
                        
                    } else {
                        print("cannot append")
                        dispatchGroup.leave()
                    }
                }
            }
            dispatchGroup.notify(queue: .main) {
                self.stories.removeAll()
                self.stories = tempStories // update the list stored in this model
                print("stories in observeStories: \(self.stories.count)")

            }
        })
    }
    
    func observeStoryCollaborators(story: Story, completion: @escaping ([String]) -> Void) {
        let collaboratorsRef = storyDBRef.child(story.storyID).child("Collaborators")
        collaboratorsRef.observeSingleEvent(of: .value, with: { snapshot in
            var collaborators: [String] = []
            for child in snapshot.children {
                if let data = child as? DataSnapshot {
                    collaborators.append(data.key)
                }
            }
            completion(collaborators)
        })
    }
    
    // stop listening for updates
    func cancelStoryObserver() {
        print("cancel observer")
        if let observerHandle = storyObserverHandle {
            storyDBRef.removeObserver(withHandle: observerHandle)
        }
    }
    
    // observe collaborators for a specific story
    func observeCurrentCollaborators() {
        
        if let story: Story = currentStory {
            
            print("observing collaborators for story: \(story.storyID)")
            
            let collaboratorsRef = storyDBRef.child(story.storyID).child("Collaborators")
            
            collaboratorObserverHandle = collaboratorsRef.observe(.value, with: { snapshot in
                var tempCollaborators: [String] = []
                for child in snapshot.children {
                    if let data = child as? DataSnapshot,
                       let collaborator = data.key as? String {
                        tempCollaborators.append(collaborator)
                    }
                }
                self.currentCollaborators.removeAll()
                self.currentCollaborators = tempCollaborators
                print("collaborators in observeCurrentCollaborators: \(self.currentCollaborators.count)")
            })
        }
        
    }
    
    func cancelCurrentCollaboratorsObserver() {
        print("cancel current story collaborators observer")
        if let story: Story = currentStory {
            if let observerHandle = collaboratorObserverHandle {
                let collaboratorsRef = storyDBRef.child(story.storyID).child("Collaborators")
                collaboratorsRef.removeObserver(withHandle: observerHandle)
            }
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
