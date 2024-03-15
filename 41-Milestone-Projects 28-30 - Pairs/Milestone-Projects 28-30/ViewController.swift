//
//  ViewController.swift
//  ProjectChallenge8
//
//  Created by Yakup Aybars Bal on 26.02.2024.
//

import UIKit

class ViewController: UICollectionViewController {
    
    var cards = CardController.loadCards(total: 20)
    
    var firstCardIndexPath: IndexPath?
    var cells = [CardCell]()
    
    var totalCard = 20
    var cardWidth = 75
    var cardHeight = 120
    
    var countDownTimer: Timer!
    var countDownLabel: UIBarButtonItem!
    var isGameOver = false
    var levelTime = 75
    var remainingTime = 75 {
        didSet {
            countDownLabel.title = "\(remainingTime)"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Pairs"
        
        navigationController?.isToolbarHidden = false
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        countDownLabel = UIBarButtonItem(title: "75", style: .plain, target: self, action: nil)
        countDownLabel.tintColor = .white
        toolbarItems = [spacer, countDownLabel, spacer]
        
        countDownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countdown), userInfo: nil, repeats: true)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Play Again", style: .plain, target: self, action: #selector(playAgain))
        let pauseBtn = UIBarButtonItem(barButtonSystemItem: .pause, target: self, action: #selector(didPauseTapped))
        let continueBtn = UIBarButtonItem(barButtonSystemItem: .play, target: self, action: #selector(didContinueTapped))
        let settingsBtn = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(didEditTapped))
        navigationItem.rightBarButtonItems = [pauseBtn, continueBtn, settingsBtn]
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
        isGameOver = true
        for cell in cells {
            cell.isUserInteractionEnabled = false
        }
        countDownTimer.invalidate()
        
        if remainingTime == 0 {
            let ac = UIAlertController(title: "Times Up!", message: "Try to be faster next time", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Play Again", style: .default, handler: { [weak self] _ in
                let time = self?.remainingTime
                self?.countDownTimer.invalidate()
                self?.playAgain()
            }))
            ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Game Finished", message: "All cards has matched", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Play Again", style: .default, handler: { [weak self] _ in
                let time = self?.remainingTime
                self?.countDownTimer.invalidate()
                self?.playAgain()
            }))
            ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            present(ac, animated: true)
        }
    }
    
    @objc func playAgain() {
        isGameOver = false
        firstCardIndexPath = nil
        cards = CardController.loadCards(total: totalCard)
        for cell in cells {
            cell.setVisibility()
            cell.isUserInteractionEnabled = true
        }
        remainingTime = levelTime
        countDownTimer.invalidate()
        countDownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countdown), userInfo: nil, repeats: true)
        collectionView.reloadData()
    }
    
    @objc func countdown() {
        remainingTime -= 1
        if remainingTime == 0 {
            countDownTimer.invalidate()
            gameOver()
        }
    }
    
    @objc func didPauseTapped() {
        guard remainingTime > 0, isGameOver == false else { return }
        countDownTimer.invalidate()
        title = "GAME PAUSED"
        
        for cell in cells {
            cell.isUserInteractionEnabled = false
        }
    }
    
    @objc func didContinueTapped() {
        guard remainingTime > 0, isGameOver == false else { return }
        countDownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countdown), userInfo: nil, repeats: true)
        title = "Pairs"
        
        for cell in cells {
            cell.isUserInteractionEnabled = true
        }
    }
    
    @objc func didEditTapped() {
        self.didPauseTapped()
        let vc = UIAlertController(title: "Settings", message: nil, preferredStyle: .actionSheet)
        vc.addAction(UIAlertAction(title: "6 x 5", style: .default, handler: { [weak self] _ in
            self?.setLevel(height: 110, width: 65, total: 30, time: 120)
        }))
        vc.addAction(UIAlertAction(title: "5 x 4", style: .default, handler: { [weak self] _ in
            self?.setLevel(height: 125, width: 75, total: 20, time: 75)
        }))
        vc.addAction(UIAlertAction(title: "4 x 4", style: .default, handler: { [weak self] _ in
            self?.setLevel(height: 150, width: 90, total: 16, time: 45)
        }))
        vc.addAction(UIAlertAction(title: "4 x 3", style: .default, handler: { [weak self] _ in
            self?.setLevel(height: 167, width: 100, total: 12, time: 45)
        }))
        vc.addAction(UIAlertAction(title: "2 x 2", style: .default, handler: { [weak self] _ in
            self?.setLevel(height: 290, width: 175, total: 4, time: 15)
        }))
        vc.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { [weak self] _ in
            self?.didContinueTapped()
        }))
        present(vc, animated: true)
    }
    
    func setLevel(height: Int, width: Int, total: Int, time: Int) {
        cardHeight = height
        cardWidth = width
        totalCard = total
        didContinueTapped()
        levelTime = time
        playAgain()
    }
    
    func setCardSize(width: Int, height: Int) -> CGSize {
        let cardSize = CGSize(width: width, height: height)
        return cardSize
    }
}


// MARK: - Set Card Size

extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        setCardSize(width: cardWidth, height: cardHeight)
    }
}
