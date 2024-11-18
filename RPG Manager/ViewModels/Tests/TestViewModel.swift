//
//  TestViewModel.swift
//  RPG Manager
//
//  Created by Anjali Narang  on 11/17/24.
//

import SwiftUI

class TestViewModel: ObservableObject {
    
    @Published var inputText: String = ""
    
    func handleSubmit() {
        print(inputText)
        inputText = ""
    }
    
}
