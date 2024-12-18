//
//  PlaceModel.swift
//  RPG Manager
//
//  Created by Anjali Narang  on 12/17/24.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import PhotosUI

class PlaceModel {
    
    static let shared = PlaceModel()
    
    var placeObserverHandle: UInt?
    @Published var currentPlaces: [Place] = []

    let storyModel = StoryModel.shared
    let storyDBRef = Database.database().reference(withPath: "Stories")
    
    func getPlaceName(for placeID: String) -> String? {
        return currentPlaces.first(where: { $0.placeID == placeID })?.placeName
    }
    
    func getPlace(for placeID: String) -> Place? {
        return currentPlaces.first(where: { $0.placeID == placeID })
    }
    
    func addPlaceToStory(place: Place) {
        let storyRef = Database.database().reference().child("Stories").child(storyModel.currentStoryID)
        let placeRef = storyRef.child("Places").child(place.placeID)
        placeRef.setValue(place.toAnyObject())
    }
    
    func deletePlace(placeID: String) {
        let storyRef = Database.database().reference().child("Stories").child(storyModel.currentStoryID)
        let placeRef = storyRef.child("Places").child(placeID)
        placeRef.removeValue()
    }
    
    func observeCurrentPlaces() {
        
        if let story: Story = storyModel.currentStory {
            
            print("observing places for story: \(story.storyID)")
            
            let placesRef = storyDBRef.child(story.storyID).child("Places")
            
            placeObserverHandle = placesRef.observe(.value, with: { snapshot in
                
                print("places snapshot: \(snapshot.value ?? "No data")")
                
                var tempPlaces: [Place] = []
                for child in snapshot.children {
                    if let data = child as? DataSnapshot,
                       let place = Place(snapshot: data) {
                        tempPlaces.append(place)
                    } else {
                        print("could not append")
                    }
                }
                self.currentPlaces.removeAll()
                self.currentPlaces = tempPlaces
                print("places in observeCurrentPlaces: \(self.currentPlaces.count)")
            })
        }
        
    }
    
    func cancelCurrentPlacesObserver() {
        print("cancel current story place observer")
        if let story: Story = storyModel.currentStory {
            if let observerHandle = placeObserverHandle {
                let placesRef = storyDBRef.child(story.storyID).child("Places")
                placesRef.removeObserver(withHandle: observerHandle)
            }
        }
    }
    
    func uploadPlaceIcon(image: UIImage, imageID: String, placeID: String) {
        
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

            imageRef.downloadURL { url, error in
                if let error = error {
                    print("cannot get download URL; \(error.localizedDescription)")
                } else if let url = url {
                    print("got download URL; \(url.absoluteString)")
                    self.updatePlaceIcon(placeID: placeID, imageURL: url.absoluteString)
                }
            }
        }
        
    }
    
    func updatePlaceIcon(placeID: String, imageURL: String) {
        let storyRef = Database.database().reference().child("Stories").child(storyModel.currentStoryID)
        if var place = self.getPlace(for: placeID) {
            place.iconURL = imageURL
            let placeRef = storyRef.child("Places").child(place.placeID)
            placeRef.setValue(place.toAnyObject())
        }
    }
    
}
