//
//  ViewController.swift
//  ProjectChallenge2
//
//  Created by Yakup Aybars Bal on 11.01.2024.
//

import UIKit

var scoreLabel: UILabel!
var tryLabel: UILabel!
var clueLabel: UILabel!
var answerLabel: UILabel!
var letterButtons = [UIButton]()
var usedLetters = [String]()

var currentAnswer = String()
var questionArray = [String]()
var answerArray = [String]()
var qNumber = 0
var alphabethArray = [String]()

var tryCount = 7 {
    didSet {
        tryLabel.text = "\(tryCount) Try Left!"
    }
}
var score = 0 {
    didSet {
        scoreLabel.text = "Score: \(score)"
    }
}

var clues = [String]()
var answers = [String]()

class ViewController: UIViewController {
    
    override func loadView() {
        // MARK: - UI coding
        view = UIView()
        view.backgroundColor = .white
        
        scoreLabel = UILabel()
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.textAlignment = .right
        scoreLabel.text = "Score: 0"
        scoreLabel.textColor = .black
        view.addSubview(scoreLabel)
        
        tryLabel = UILabel()
        tryLabel.translatesAutoresizingMaskIntoConstraints = false
        tryLabel.textAlignment = .left
        tryLabel.text = "7 Try left!"
        tryLabel.textColor = .black
        view.addSubview(tryLabel)
        
        clueLabel = UILabel()
        clueLabel.translatesAutoresizingMaskIntoConstraints = false
        clueLabel.textAlignment = .center
        clueLabel.numberOfLines = 0
        clueLabel.font = UIFont.systemFont(ofSize: 20)
        clueLabel.text = "Question Here"
        clueLabel.textColor = .black
        view.addSubview(clueLabel)
        
        answerLabel = UILabel()
        answerLabel.translatesAutoresizingMaskIntoConstraints = false
        answerLabel.font = UIFont.systemFont(ofSize: 40)
        answerLabel.text = ""
        answerLabel.textAlignment = .center
        answerLabel.textColor = .black
        view.addSubview(answerLabel)
        
        let buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonsView)
        
        // MARK: - Constrains
        NSLayoutConstraint.activate([
            scoreLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            scoreLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            
            tryLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            tryLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: -10),
            
            clueLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor, constant: 10),
            clueLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            clueLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            
            answerLabel.topAnchor.constraint(equalTo: clueLabel.bottomAnchor, constant: 10),
            answerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            answerLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            
            buttonsView.topAnchor.constraint(equalTo: answerLabel.bottomAnchor, constant: 10),
            buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsView.widthAnchor.constraint(equalToConstant: 720),
            buttonsView.heightAnchor.constraint(equalToConstant: 216)
            
            
        ])
    // MARK: - Buttons section
        let width = 90
        let height = 54
        var alph = 0
        
        if let alphTextURL = Bundle.main.url(forResource: "alphabeth", withExtension: "txt") {
            if let alphString = try? String(contentsOf: alphTextURL) {
                let alphArray = alphString.components(separatedBy: "\n")
                alphabethArray = alphArray
            }
        }
        
        for row in 0..<4 {
            for col in 0..<8 {
                let letterButton = UIButton(type: .system)
                letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 25)
                letterButton.tintColor = .black
                
                letterButton.layer.borderWidth = 0.5
                letterButton.layer.borderColor = UIColor.lightGray.cgColor
                
                letterButton.setTitle("\(alphabethArray[alph])", for: .normal)
                alph += 1
                
                // calculate the frame of this button using its column and row
                let frame = CGRect(x: col * width, y: row * height, width: width, height: height)
                letterButton.frame = frame
                
                buttonsView.addSubview(letterButton)
                
                letterButtons.append(letterButton)
                
                letterButton.addTarget(self, action: #selector(letterButtonTapped), for: .touchUpInside)
            }
        }
        // MARK: - answer & clue section
        
        for _ in 0..<currentAnswer.count {
            answerLabel.text?.append("?")
        }
        
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        startGame()
    }
    
    func startGame() {
        if let textFileURL = Bundle.main.url(forResource: "text", withExtension: "txt") {
            if let textString = try? String(contentsOf: textFileURL) {
                let lines = textString.components(separatedBy: ("\n"))
                
                for (_, line) in lines.enumerated() {
                    let parts = line.components(separatedBy: ": ")
                    let answer = parts[0]
                    let question = parts [1]
                    
                    questionArray.append(question)
                    answerArray.append(answer)
                }
                currentAnswer = answerArray[qNumber]
                clueLabel.text = questionArray[qNumber]
                
                for _ in 0..<currentAnswer.count {
                    answerLabel.text?.append("?")
                }
            }
        }
    }
    
    func levelUp() {
        if qNumber == 6 {
            qNumber = 0
            let ac = UIAlertController(title: "End of the road", message: "We have no more questions", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Let's play again", style: .default, handler: { _ in
                score = 0
                tryCount = 7
            }))
            present(ac, animated: true)
        } else {
            qNumber += 1
        }
        
        usedLetters.removeAll()
        
        for btn in letterButtons {
            btn.isHidden = false
            btn.backgroundColor = .white
            btn.isUserInteractionEnabled = true
        }
        
        startGame()
    }
    
    @objc func letterButtonTapped(_ sender: UIButton) {
        
        usedLetters.append((sender.titleLabel?.text)!)
        var promptWord = ""
        
        if !currentAnswer.uppercased().contains("\((sender.titleLabel?.text)!)") {
            tryCount -= 1
            sender.backgroundColor = UIColor(red: 1.0, green: 0.5, blue: 0.5, alpha: 0.5)
            sender.isUserInteractionEnabled = false
            if tryCount == 0 {
                let ac = UIAlertController(title: "Ooops..", message: "The answer is \(currentAnswer.uppercased())", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Next Game", style: .default, handler: { _ in
                    tryCount = 7
                    answerLabel.text = ""
                    self.levelUp()
                }))
                
                present(ac, animated: true)
            }
        } else {
            sender.isHidden = true
        }
        for letter in currentAnswer.uppercased() {
            let strLetter = String(letter)

            if usedLetters.contains(strLetter) {
                promptWord += strLetter
            } else {
                promptWord += "?"
            }
        }
        
        answerLabel.text = promptWord
        
        if promptWord == currentAnswer.uppercased() {
            usedLetters.removeAll()
            score += 1
            
                let ac = UIAlertController(title: "Well Done", message: "Your answer is correct", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Let's move!", style: .default, handler: { _ in
                    tryCount = 7
                    answerLabel.text = ""
                    self.levelUp()
                }))
                present(ac, animated: true)
        }
    }
}

