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
    
    func setCurrentStory(tappedOn: Story) { // async?
        currentStory = tappedOn
    }
    
    // watch for updates from Story realtime database table
    func observeStories() {
        print("observe stories")
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
            print("stories in observeStories: \(self.stories.count)")
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
            
            print("observing characters for story: \(story.storyID)")
            
            let charactersRef = storyDBRef.child(story.storyID).child("Characters")
            
            characterObserverHandle = charactersRef.observe(.value, with: { snapshot in
                
                print("character snapshot: \(snapshot.value ?? "No data")")
                
                var tempCharacters: [Character] = []
                for child in snapshot.children {
                    if let data = child as? DataSnapshot,
                       let character = Character(snapshot: data) {
                        tempCharacters.append(character)
                    } else {
                        print("could not append")
                    }
                }
                self.currentCharacters.removeAll()
                self.currentCharacters = tempCharacters
                print("characters in observeCurrentCharacters: \(self.currentCharacters.count)")
            })
        }
    }
    
    func cancelCurrentCharactersObserver() {
        print("cancel current story character observer")
        if let story: Story = currentStory {
            if let observerHandle = characterObserverHandle {
                let charactersRef = storyDBRef.child(story.storyID).child("Characters")
                charactersRef.removeObserver(withHandle: observerHandle)
            }
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
    
    // func observeAllCollaborators() {}

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
    
    // remove an item from Story database table
    func deleteStory(story: Story) {
        let storyDBRef = Database.database().reference(withPath: "Stories")
        let storyRef = storyDBRef.child(story.storyID)
        storyRef.removeValue()
    }
        
    func addCharacterToStory(storyID: String, character: Character) {
        
        let storyRef = Database.database().reference().child("Stories").child(storyID)
        let characterRef = storyRef.child("Characters").child(character.characterID)
        
        let characterData: [String: Any] = [
            "characterID": character.characterID,
            "creatorID": character.creatorID,
            "characterName": character.characterName,
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
