//
//  CharacterModel.swift
//  RPG Manager
//
//  Created by Anjali Narang  on 11/30/24.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import PhotosUI


class CharacterModel {
    
    static let shared = CharacterModel()
    
    var characterObserverHandle: UInt?
    @Published var currentCharacters: [Character] = []
    
    let storyModel = StoryModel.shared
    let storyDBRef = Database.database().reference(withPath: "Stories")
    
    func getCharacter(for characterID: String) -> Character? {
        return currentCharacters.first(where: { $0.characterID == characterID })
    }
    
    // observe characters for a specific story
    func observeCurrentCharacters() {
        
        if let story: Story = StoryModel.shared.currentStory {
            
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
        if let story: Story = storyModel.currentStory {
            if let observerHandle = characterObserverHandle {
                let charactersRef = storyDBRef.child(story.storyID).child("Characters")
                charactersRef.removeObserver(withHandle: observerHandle)
            }
        }
    }
    
    func consumeItem(characterID: String, itemID: String) {
        
        let characterBagRef = storyDBRef.child(storyModel.currentStoryID).child("Characters").child(characterID).child("bag")
        
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
        
        print("get truncated stats for \(characterID)")
        print("current characters count is \(currentCharacters.count)")
        
        if let character = currentCharacters.first(where: { $0.characterID == characterID }) {
            
            print("got character")
            
            var stats = character.stats
            
            if (character.stats.health > 100) {
                stats.health = 100
            }
            else if (character.stats.health < 0) {
                stats.health = 0
            }
        
            if (character.stats.attack > 100) {
                stats.attack = 100
            }
            else if (character.stats.attack < 0) {
                stats.attack = 0
            }
        
            if (character.stats.defense > 100) {
                stats.defense = 100
            }
            else if (character.stats.defense < 0) {
                stats.defense = 0
            }
        
            if (character.stats.speed > 100) {
                stats.speed = 100
            }
            else if (character.stats.speed < 0) {
                stats.speed = 0
            }
            
            if (character.stats.agility > 100) {
                stats.agility = 100
            }
            else if (character.stats.agility < 0) {
                stats.agility = 0
            }
        
            if (character.stats.hp > character.stats.health) {
                stats.hp = stats.health
            }
            else if (character.stats.hp < 0) {
                stats.hp = 0
            }
            
            return stats
            
        }
        
        print("could not get character")
        
        return Stats(health: 0, attack: 0, defense: 0, speed: 0, agility: 0, hp: 0)
        
    }
    
    func uploadCharacterIcon(image: UIImage, imageID: String, characterID: String) {
        
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
                    self.updateCharacterIcon(characterID: characterID, imageURL: url.absoluteString)
                }
            }
        }
        
    }
    
    func updateCharacterIcon(characterID: String, imageURL: String) {
        print("updating character ICON in story model")
        let storyRef = Database.database().reference().child("Stories").child(storyModel.currentStoryID)
        if var character = self.getCharacter(for: characterID) {
            character.iconURL = imageURL
            let characterRef = storyRef.child("Characters").child(character.characterID)
            characterRef.setValue(character.toAnyObject())
        }
    }
    
    func addItemToBag(characterID: String, itemID: String, addingAmt: Int) {
        
        let characterBagRef = storyDBRef.child(storyModel.currentStoryID).child("Characters").child(characterID).child("bag")
        
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
    
    func removeItemFromBag(characterID: String, itemID: String, removingAmt: Int) {
        
        let characterBagRef = storyDBRef.child(storyModel.currentStoryID).child("Characters").child(characterID).child("bag")
        
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
    
    func deleteCharacter(characterID: String) {
        let storyRef = Database.database().reference().child("Stories").child(storyModel.currentStoryID)
        let characterRef = storyRef.child("Characters").child(characterID)
        characterRef.removeValue()
    }
    
    
        
    func addCharacterToStory(character: Character) {
        let storyRef = Database.database().reference().child("Stories").child(storyModel.currentStoryID)
        let characterRef = storyRef.child("Characters").child(character.characterID)
        characterRef.setValue(character.toAnyObject())
    }
    
    func updateCharacter(character: Character) {
        print("updating character in story model")
        let storyRef = Database.database().reference().child("Stories").child(storyModel.currentStoryID)
        let characterRef = storyRef.child("Characters").child(character.characterID)
        characterRef.setValue(character.toAnyObject())
    }
    
}
