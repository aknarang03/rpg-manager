//
//  timeInterval.swift
//  RPG Manager
//
//  Created by Anjali Narang  on 11/30/24.
//

import Foundation

func idWithTimeInterval() -> String {
    let timeNow = Date()
    var timeStr = String(timeNow.timeIntervalSince1970)
    timeStr = timeStr.replacingOccurrences(of: ".", with: "")
    return timeStr
}
