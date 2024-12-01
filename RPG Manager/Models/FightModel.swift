//
//  FightModel.swift
//  RPG Manager
//
//  Created by Anjali Narang  on 11/30/24.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class FightModel {
    
    static let shared = FightModel()
    
    var fightObserverHandle: UInt?
    @Published var currentFights: [Fight] = []

    let storyModel = StoryModel.shared
    let storyDBRef = Database.database().reference(withPath: "Stories")
    
    func observeCurrentFights() {
        
        if let story: Story = storyModel.currentStory {
            
            print("observing fights for story: \(story.storyID)")
            
            let fightsRef = storyDBRef.child(story.storyID).child("Fights")
            
            fightObserverHandle = fightsRef.observe(.value, with: { snapshot in
                
                print("fights snapshot: \(snapshot.value ?? "No data")")
                
                var tempFights: [Fight] = []
                for child in snapshot.children {
                    if let data = child as? DataSnapshot,
                       let fight = Fight(snapshot: data) {
                        tempFights.append(fight)
                    } else {
                        print("could not append fight")
                    }
                }
                self.currentFights.removeAll()
                self.currentFights = tempFights
                print("fights in observeCurrentFights: \(self.currentFights.count)")
            })
        }
        
    }
    
    func cancelCurrentFightsObserver() {
        print("cancel current story fights observer")
        if let story: Story = storyModel.currentStory {
            if let observerHandle = fightObserverHandle {
                let fightsRef = storyDBRef.child(story.storyID).child("Fights")
                fightsRef.removeObserver(withHandle: observerHandle)
            }
        }
    }
    
    func deleteFight(fightID: String) {
        let storyRef = Database.database().reference().child("Stories").child(storyModel.currentStoryID)
        let fightRef = storyRef.child("Fights").child(fightID)
        fightRef.removeValue()
    }
    
    func addOutcomesToFight(fightID: String, outcome1: String, outcome2: String) {
        
        let fightOutcomesRef = storyDBRef.child(storyModel.currentStoryID).child("Fights").child(fightID).child("outcomes")
        
        fightOutcomesRef.observeSingleEvent(of: .value) { snapshot in
            
            var outcomes = snapshot.value as? [String] ?? []
            
            outcomes.append("\(outcome1)\n\(outcome2)")
            fightOutcomesRef.setValue(outcomes)
            
            print("updated outcomes: \(outcomes)")
            
        }
        
    }
    
    
    
    
    
    func getOutcomeString(type: OutcomeType, attackerName: String, defenderName: String, impact: String, itemName: String) -> String {
        
        switch type {
        case .attackerAttack:
            return "\(attackerName) attacks \(defenderName) for \(impact) damage."
        case .attackerUsesItem:
            return "\(attackerName) uses \(itemName) for \(impact)."
        case .attackerPass:
            return "\(attackerName) does nothing."
        case .attackerLose:
            return "\(attackerName) loses."
        case .attackerFlee:
            return "\(attackerName) flees."
        case .defenderAvoid:
            return "\(defenderName) avoids the attack."
        case .defenderGetHit:
            return "\(defenderName) loses \(impact) HP."
        case .defenderIdle:
            return "\(defenderName) idles."
        case .defenderLose:
            return "\(defenderName) loses."
        case .defenderFlee:
            return "\(defenderName) flees."
        default:
            return "Unknown outcome."
        }
        
    }
    
    func startFight(fight: Fight) {
        let storyRef = Database.database().reference().child("Stories").child(storyModel.currentStoryID)
        let fightRef = storyRef.child("Fights").child(fight.fightID)
        fightRef.setValue(fight.toAnyObject())
    }
    
    func updateFight(fight: Fight) {
        let storyRef = Database.database().reference().child("Stories").child(storyModel.currentStoryID)
        let fightRef = storyRef.child("Fights").child(fight.fightID)
        fightRef.setValue(fight.toAnyObject())
    }
    
    
//    func endFight(storyID: String, fight: Fight) { // would pass in fight with outcomes array this time
//        let storyRef = Database.database().reference().child("Stories").child(storyID)
//        let fightRef = storyRef.child("Fights").child(fight.fightID)
//        fightRef.setValue(fight.toAnyObject())
//    }
    
}
