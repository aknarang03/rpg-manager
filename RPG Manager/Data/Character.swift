//
//  Character.swift
//  RPG Manager
//
//  Created by Anjali Narang  on 11/18/24.
//

import Foundation
import Firebase
import FirebaseDatabase

struct Character {
    var characterID: String
    var creatorID: String
    var characterName: String
    var stats: Stats
}

struct Stats {
    var attack: Int
    var defense: Int
    var speed: Int
    var agility: Int
}
