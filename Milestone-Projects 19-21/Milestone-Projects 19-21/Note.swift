//
//  Notes.swift
//  Milestone-Projects 19-21
//
//  Created by Yakup Aybars Bal on 8.03.2024.
//

import Foundation

class Note: Codable {
    var title: String
    var text: String
    
    init(title: String, text: String) {
        self.title = title
        self.text = text
    }
}
