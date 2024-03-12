//
//  ViewController.swift
//  ProjectChallenge8
//
//  Created by Yakup Aybars Bal on 26.02.2024.
//

import UIKit

class ViewController: UICollectionViewController {
    
    var cards = CardController.loadCards()
    
    var firstCardIndexPath: IndexPath?
    var isGameOver = false
    var cells = [CardCell]()
    
    var countDownTimer: Timer!
    var countDownLabel: UIBarButtonItem!
    var remainingTime = 5 {
        didSet {
            countDownLabel.title = "\(remainingTime)"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Pairs"
        
        navigationController?.isToolbarHidden = false
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        countDownLabel = UIBarButtonItem(title: "60", style: .plain, target: self, action: nil)
        countDownLabel.tintColor = .white
        toolbarItems = [spacer, countDownLabel, spacer]
        
        countDownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countdown), userInfo: nil, repeats: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cards.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? CardCell else { fatalError() }
        
        cell.cardImage.isHidden = true
        cells.append(cell)
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard cards[indexPath.row].didTapped == false else { return }
        
        let cell = collectionView.cellForItem(at: indexPath) as! CardCell
        let imageName = cards[indexPath.row].name
        cell.setVisibility()
        cell.flip()
        cell.setImage(imageName: imageName)
        cards[indexPath.row].didTapped = true
        
        if firstCardIndexPath != nil {
            checkAnswers(secondIndexPath: indexPath)
        } else {
            firstCardIndexPath = indexPath
        }
    }
    
    func checkAnswers(secondIndexPath: IndexPath) {
        let cell1 = collectionView.cellForItem(at: firstCardIndexPath!) as! CardCell
        let cell2 = collectionView.cellForItem(at: secondIndexPath) as! CardCell
        let firstCard = cards[firstCardIndexPath!.row]
        let secondCard = cards[secondIndexPath.row]
        
        if firstCard.name == secondCard.name {
            print("Checked")
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                UIView.animate(withDuration: 0.25) {
                    cell1.cardImage.alpha = 0
                    cell2.cardImage.alpha = 0
                }
                cell1.isUserInteractionEnabled = false
                cell2.isUserInteractionEnabled = false
                var count = 0
                for card in self!.cards {
                    if card.isActive == false { count += 1 }
                    if count == (self?.cards.count) { self?.gameOver() }
                }
            }
            cards[firstCardIndexPath!.row].isActive = false
            cards[secondIndexPath.row].isActive = false
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                cell1.setVisibility()
                cell2.setVisibility()
                cell1.backFlip()
                cell2.backFlip()
            }
        }
        cards[firstCardIndexPath!.row].didTapped = false
        cards[secondIndexPath.row].didTapped = false
        firstCardIndexPath = nil
    }
    
    func gameOver() {
        let ac = UIAlertController(title: "Game Finished", message: "All cards has matched", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Play Again", style: .default, handler: { _ in
            self.playAgain()
        }))
        ac.addAction(UIAlertAction(title: "OK", style: .cancel))
        present(ac, animated: true)
    }
    
    func playAgain() {
        cards = CardController.loadCards()
        for cell in cells {
            cell.setVisibility()
            cell.isUserInteractionEnabled = true
        }
        
        collectionView.reloadData()
    }
    
    @objc func countdown() {
        remainingTime -= 1
        if remainingTime == 0 {
            countDownTimer.invalidate()
            
            
        }
    }
}


// MARK: - Set Card Size

extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cardSize = CGSize(width: 120, height: 110)
        return cardSize
    }
}
