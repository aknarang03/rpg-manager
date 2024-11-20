//
//  AddItemViewModel.swift
//  RPG Manager
//
//  Created by Anjali Narang  on 11/20/24.
//

import Foundation

class AddItemViewModel: ObservableObject {
    
    let storyModel = StoryModel.shared
    let userModel = UserModel.shared
    
    @Published var itemName: String = ""
    @Published var itemDescription: String = ""
    @Published var impactsWhat: String = ""
    @Published var impact: String = ""

    func timeInterval() -> String {
        let timeNow = Date()
        var timeStr = String(timeNow.timeIntervalSince1970)
        timeStr = timeStr.replacingOccurrences(of: ".", with: "")
        return timeStr
    }
    
    func addItem() {
        
        let impacts : ImpactsWhat = ImpactsWhat(rawValue: impactsWhat) ?? ImpactsWhat.none
        let impactVal = Int(impact) ?? 0
        
        let newItem = Item(itemID: timeInterval(), creatorID: userModel.currentUser!.uid, itemName: itemName, itemDescription: itemDescription, impactsWhat: impacts.rawValue, impact: impactVal)
        storyModel.addItemToStory(storyID: storyModel.currentStory!.storyID, item: newItem)

    }

}
