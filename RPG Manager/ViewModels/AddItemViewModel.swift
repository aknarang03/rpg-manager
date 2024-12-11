//
//  AddItemViewModel.swift
//  RPG Manager
//
//  Created by Anjali Narang  on 11/20/24.
//

import Foundation

class AddItemViewModel: ObservableObject {
    
    let userModel = UserModel.shared
    let itemModel = ItemModel.shared
    
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
        
        let newItem = Item(itemID: idWithTimeInterval(), creatorID: userModel.currentUser!.uid, itemName: itemName, itemDescription: itemDescription, impactsWhat: impactsWhat.rawValue, impact: impactVal, type: type.rawValue, iconURL: "")
        itemModel.addItemToStory(item: newItem)

    }

}
