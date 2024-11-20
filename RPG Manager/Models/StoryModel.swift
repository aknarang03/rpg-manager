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
    
    var storyObserverHandle: UInt?
    var characterObserverHandle: UInt?
    var collaboratorObserverHandle: UInt?
    var collaboratorObserverHandles: [String: UInt] = [:]
    
    let storyDBRef = Database.database().reference(withPath: "Stories")
    
    @Published var stories:[Story] = []
    
    @Published var currentStory: Story?
    @Published var currentCharacters: [Character] = []
    @Published var currentCollaborators: [String] = []
    
    // watch for updates from Story realtime database table
    func observeStories() {
        print("observe items")
        storyObserverHandle = storyDBRef.observe(.value, with: {snapshot in
            var tempStories:[Story] = []
            for child in snapshot.children {
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
    func cancelStoryObserver() {
        print("cancel observer")
        if let observerHandle = storyObserverHandle {
            storyDBRef.removeObserver(withHandle: observerHandle)
        }
    }
    
    // observe characters for a specific story
    func observeCurrentCharacters() {
        
        if let story: Story = currentStory {
            
            print("Observing characters for story: \(story.storyID)")
            
            let charactersRef = storyDBRef.child(story.storyID).child("Characters")
            
            characterObserverHandle = charactersRef.observe(.value, with: { snapshot in
                var tempCharacters: [Character] = []
                for child in snapshot.children {
                    if let data = child as? DataSnapshot,
                       let character = Character(snapshot: data) {
                        tempCharacters.append(character)
                    }
                }
                self.currentCharacters.removeAll()
                self.currentCharacters = tempCharacters
            })
        }
        
    }
    
    // observe collaborators for a specific story
    func observeCurrentCollaborators() {
        
        if let story: Story = currentStory {
            
            print("Observing collaborators for story: \(story.storyID)")
            
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
            })
        }
        
    }
    
    // func observeAllCollaborators() {}

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
        
    func addCharacterToStory(storyID: String, character: Character) {
        
        let storyRef = Database.database().reference().child("Stories").child(storyID)
        let characterRef = storyRef.child("Characters").child(character.characterID)
        
        let characterData: [String: Any] = [
            "creatorID": character.creatorID,
            "name": character.characterName,
            "stats": [
                "attack": character.stats.attack,
                "defense": character.stats.defense,
                "speed": character.stats.speed,
                "agility": character.stats.agility
            ]
        ]
        
        characterRef.setValue(characterData)
         
    }
    
    func addCollaboratorToStory(storyID: String, collaboratorID: String) {
        
        let storyRef = Database.database().reference().child("Stories").child(storyID)
        let collaboratorRef = storyRef.child("Collaborators").child(collaboratorID)
        collaboratorRef.setValue(true) // placeholder

    }
    
}
