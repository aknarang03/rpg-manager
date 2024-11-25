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
    let userModel = UserModel.shared
    
    var storyObserverHandle: UInt?
    var characterObserverHandle: UInt?
    var itemObserverHandle: UInt?
    var collaboratorObserverHandle: UInt?
    var collaboratorObserverHandles: [String: UInt] = [:]
    
    let storyDBRef = Database.database().reference(withPath: "Stories")
    
    @Published var stories:[Story] = []
    
    @Published var currentStory: Story?
    @Published var currentCharacters: [Character] = []
    @Published var currentItems: [Item] = []
    @Published var currentCollaborators: [String] = []
    
    func setCurrentStory(tappedOn: Story) { // async?
        currentStory = tappedOn
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
    
    func observeCurrentItems() {
        
        if let story: Story = currentStory {
            
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
        if let story: Story = currentStory {
            if let observerHandle = itemObserverHandle {
                let itemsRef = storyDBRef.child(story.storyID).child("Items")
                itemsRef.removeObserver(withHandle: observerHandle)
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
    
    func deleteCharacter(storyID: String, characterID: String) {
        let storyRef = Database.database().reference().child("Stories").child(storyID)
        let characterRef = storyRef.child("Characters").child(characterID)
        storyRef.removeValue()
    }
    
    func deleteItem(storyID: String, itemID: String) {
        let storyRef = Database.database().reference().child("Stories").child(storyID)
        let itemRef = storyRef.child("Items").child(itemID)
        itemRef.removeValue()
    }
        
    func addCharacterToStory(storyID: String, character: Character) {
        let storyRef = Database.database().reference().child("Stories").child(storyID)
        let characterRef = storyRef.child("Characters").child(character.characterID)
        characterRef.setValue(character.toAnyObject())
    }
    
    func updateCharacter(storyID: String, character: Character) {
        let storyRef = Database.database().reference().child("Stories").child(storyID)
        let characterRef = storyRef.child("Characters").child(character.characterID)
        characterRef.setValue(character.toAnyObject())
    }
    
    func addItemToStory(storyID: String, item: Item) {
        let storyRef = Database.database().reference().child("Stories").child(storyID)
        let itemRef = storyRef.child("Items").child(item.itemID)
        itemRef.setValue(item.toAnyObject())
    }
    
    func addCollaboratorToStory(storyID: String, collaboratorID: String) {
        let storyRef = Database.database().reference().child("Stories").child(storyID)
        let collaboratorRef = storyRef.child("Collaborators").child(collaboratorID)
        collaboratorRef.setValue(true) // placeholder
    }
    
    func addItemToBag(storyID: String, characterID: String, itemID: String, addingAmt: Int) {
        
        let characterBagRef = storyDBRef.child(storyID).child("Characters").child(characterID).child("bag")
        
        characterBagRef.observeSingleEvent(of: .value) { snapshot in
            
            var bag = snapshot.value as? [String: Int] ?? [:]
            
            if let currentQuantity = bag[itemID] {
                bag[itemID] = currentQuantity + addingAmt // adding to prev quantity
            } else {
                bag[itemID] = addingAmt // new item
            }
            
            characterBagRef.setValue(bag)
            
            print("updated bag: \(bag)")
            
        }
        
    }
    
    func removeItemFromBag(storyID: String, characterID: String, itemID: String, removingAmt: Int) {
        
        let characterBagRef = storyDBRef.child(storyID).child("Characters").child(characterID).child("bag")
        
        characterBagRef.observeSingleEvent(of: .value) { snapshot in
            
            var bag = snapshot.value as? [String: Int] ?? [:]
            
            if let currentQuantity = bag[itemID] {
                bag[itemID] = currentQuantity - removingAmt // removing from prev quantity
                if currentQuantity <= 1 {
                    bag.removeValue(forKey: itemID) // remove item reference from bag
                }
            }
            
            characterBagRef.setValue(bag)
            
            print("updated bag: \(bag)")
            
        }
        
    }
    
    func getCharacter(for characterID: String) -> Character? {
        return currentCharacters.first(where: { $0.characterID == characterID })
    }
    
    func getItemName(for itemID: String) -> String? {
        return currentItems.first(where: { $0.itemID == itemID })?.itemName
    }
    
    func getItem(for itemID: String) -> Item? {
        return currentItems.first(where: { $0.itemID == itemID })
    }
    
    func consumeItem(storyID: String, characterID: String, itemID: String) {
        
        let characterBagRef = storyDBRef.child(storyID).child("Characters").child(characterID).child("bag")
        
        characterBagRef.observeSingleEvent(of: .value) { snapshot in
            
            var bag = snapshot.value as? [String: Int] ?? [:]
            
            if let currentQuantity = bag[itemID] {
                
                if (currentQuantity == 1) {
                    bag.removeValue(forKey: itemID)
                } else {
                    bag[itemID] = currentQuantity - 1
                }
                                
            }
            
            characterBagRef.setValue(bag)
            print("updated bag: \(bag)")
            
        }
        
    }
    
    func getTruncatedStats(characterID: String) -> Stats {
        
        let character = currentCharacters.first(where: { $0.characterID == characterID })
        var stats = character!.stats
        
        if (character!.stats.health > 100) {
            stats.health = 100
        }
        else if (character!.stats.health < 0) {
            stats.health = 0
        }
    
        if (character!.stats.attack > 100) {
            stats.attack = 100
        }
        else if (character!.stats.attack < 0) {
            stats.attack = 0
        }
    
        if (character!.stats.defense > 100) {
            stats.defense = 100
        }
        else if (character!.stats.defense < 0) {
            stats.defense = 0
        }
    
        if (character!.stats.speed > 100) {
            stats.speed = 100
        }
        else if (character!.stats.speed < 0) {
            stats.speed = 0
        }
        
        if (character!.stats.agility > 100) {
            stats.agility = 100
        }
        else if (character!.stats.agility < 0) {
            stats.agility = 0
        }
    
        if (character!.stats.hp > character!.stats.health) {
            stats.hp = stats.health
        }
        else if (character!.stats.hp < 0) {
            stats.hp = 0
        }
        
        return stats
        
    }

}
