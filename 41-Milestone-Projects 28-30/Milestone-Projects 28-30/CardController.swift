//
//  CardController.swift
//  ProjectChallenge8
//
//  Created by Yakup Aybars Bal on 26.02.2024.
//

import Foundation

class CardController {
    
    static func loadCards(total: Int) -> [Card]{
        var cards = [Card]()
        
        for i in 1...total/2 {
            let card = Card(name: "animal\(i)", didTapped: false, isActive: true)
            cards.append(card)
            cards.append(card)
        }
        
        cards.shuffle()
        return cards
    }
    
}
