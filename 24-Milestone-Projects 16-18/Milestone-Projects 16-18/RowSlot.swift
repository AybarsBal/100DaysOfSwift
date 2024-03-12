//
//  RowSlot.swift
//  ProjectChallange5
//
//  Created by Yakup Aybars Bal on 26.01.2024.
//

import UIKit
import SpriteKit

class RowSlot: SKNode {
    
    func configure(at position: CGPoint) {
        self.position = position
        
        let row = SKSpriteNode(imageNamed: "shelf")
        row.size = CGSize(width: 1024, height: 200)
        row.zPosition = -1
        addChild(row)
    }
    
    
}
