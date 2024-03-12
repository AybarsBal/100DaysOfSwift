//
//  CardController.swift
//  ProjectChallenge8
//
//  Created by Yakup Aybars Bal on 26.02.2024.
//

import Foundation

class CardController {
    
    static func loadCards() -> [Card]{
        var cards = [Card]()
        
        for i in 1...9 {
            let card = Card(name: "flag\(i)", didTapped: false, isActive: true)
            cards.append(card)
            cards.append(card)
        }
        
        cards.shuffle()
        return cards
    }
    
}
