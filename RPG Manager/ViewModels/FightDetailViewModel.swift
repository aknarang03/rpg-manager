//
//  OtherFightViewModel.swift
//  RPG Manager
//
//  Created by Anjali Narang  on 11/26/24.
//


import Foundation
import Combine

class FightDetailViewModel: ObservableObject {
    
    let fightModel = FightModel.shared
    
    @Published var fight: Fight
    
    init(fight: Fight) {
        self.fight = fight
    }

}
