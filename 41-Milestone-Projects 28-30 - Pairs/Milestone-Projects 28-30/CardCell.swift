//
//  CardCell.swift
//  ProjectChallenge8
//
//  Created by Yakup Aybars Bal on 26.02.2024.
//

import UIKit

class CardCell: UICollectionViewCell {
    let cardBack = UIImage(named: "cardBack")
    var isHidded = true {
        didSet {
            isHidded.toggle()
        }
    }
    
    @IBOutlet var backCardImage: UIImageView!
    @IBOutlet var cardImage: UIImageView!
    
    
    func setImage(imageName: String) {
        self.cardImage.image = UIImage(named: imageName)
    }
    
    func flip() {
        UIView.transition(from: backCardImage, to: cardImage, duration: 0.3, options: [.transitionFlipFromLeft, .showHideTransitionViews])
    }
    func backFlip() {
        UIView.transition(from: cardImage, to: backCardImage, duration: 0.3, options: [.transitionFlipFromLeft, .showHideTransitionViews])
    }
    
    func setVisibility() {
        cardImage.isHidden = isHidded
        backCardImage.isHidden = !isHidded
    }
    
    
}
