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
    
    func addItem() {
        
        if (itemName == "") {
            print("cannot add empty item name")
            return;
        }
        
        //let impacts : ImpactsWhat = ImpactsWhat(rawValue: impactsWhat) ?? ImpactsWhat.none
        let impactVal = Int(impact)
        
        let newItem = Item(itemID: idWithTimeInterval(), creatorID: userModel.currentUser!.uid, itemName: itemName, itemDescription: itemDescription, impactsWhat: impactsWhat.rawValue, impact: impactVal, type: type.rawValue)
        storyModel.addItemToStory(storyID: storyModel.currentStory!.storyID, item: newItem)

    }

}
