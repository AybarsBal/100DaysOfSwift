//
//  ViewController.swift
//  Project2
//
//  Created by Yakup Aybars Bal on 21.12.2023.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    
    var countries = [String]()
    var score: Int = 0
    var correctAnswer = 0
    var currentQuestion = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
        
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1
        
        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor
        
        askQuestion()
    }
    
    func askQuestion(aciton: UIAlertAction! = nil) {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        title = "\(currentQuestion)/10  |  \(countries[correctAnswer].uppercased())"
        
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        
        currentQuestion += 1
        
        if sender.tag == correctAnswer {
            title = "Correct"
            score += 1
        } else {
            title = "Wrong"
            score -= 1
        }
        
        if currentQuestion == 11 {
            currentQuestion = 1
            let ac = UIAlertController(title: "Game Over", message: "Your final score is \(score).", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "New Game", style: .default, handler: askQuestion))
            present(ac, animated: true)
        } else {
            if sender.tag == correctAnswer {
                let ac = UIAlertController(title: title, message: "Your score is \(score).", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
                present(ac, animated: true)
            } else {
                let ac = UIAlertController(title: title,
                                           message: """
                                                        That's the flag of \(countries[sender.tag].uppercased())
                                                        Your final score is \(score).
                                                        """,
                                           preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
                present(ac, animated: true)
            }
        }
    }
    
    @IBAction func scoreButtonTapped(_ sender: UIBarButtonItem) {
        let scoreAC = UIAlertController(title: "Score", message: "Your current score is \(score)", preferredStyle: .alert)
        scoreAC.addAction(UIAlertAction(title: "Ok", style: .default))
        present(scoreAC, animated: true)
    }
    
}

