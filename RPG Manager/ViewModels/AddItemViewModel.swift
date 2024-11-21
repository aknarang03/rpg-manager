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
    @Published var impactsWhat: ImpactsWhat = ImpactsWhat.none
    @Published var type: ItemType = ItemType.consumable
    @Published var impact: Float = 0

    func timeInterval() -> String {
        let timeNow = Date()
        var timeStr = String(timeNow.timeIntervalSince1970)
        timeStr = timeStr.replacingOccurrences(of: ".", with: "")
        return timeStr
    }
    
    func addItem() {
        
        //let impacts : ImpactsWhat = ImpactsWhat(rawValue: impactsWhat) ?? ImpactsWhat.none
        let impactVal = Int(impact)
        
        let newItem = Item(itemID: timeInterval(), creatorID: userModel.currentUser!.uid, itemName: itemName, itemDescription: itemDescription, impactsWhat: impactsWhat.rawValue, impact: impactVal, type: type.rawValue)
        storyModel.addItemToStory(storyID: storyModel.currentStory!.storyID, item: newItem)

    }

}
