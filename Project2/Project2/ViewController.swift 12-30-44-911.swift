//
//  ViewController.swift
//  Project2
//
//  Created by Yakup Aybars Bal on 21.12.2023.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {
    
    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    
    var countries = [String]()
    var score: Int = 0
    var correctAnswer = 0
    var currentQuestion = 1
    var highestScore = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
        
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1
        
        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor
        
        let defaults = UserDefaults()
        
        if let savedScore = defaults.object(forKey: "highScore") as? Data {
            let jsonDecoder = JSONDecoder()
            
            do {
                highestScore = try jsonDecoder.decode(Int.self, from: savedScore)
            } catch {
                print("Loading error")
            }
        }
        
        askQuestion()
        
        registerLocal()
        scheduleLocal()
    }
    
    func askQuestion(aciton: UIAlertAction! = nil) {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        title = "\(currentQuestion)/10  |  \(countries[correctAnswer].uppercased())"
        
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
        
        UIView.animate(withDuration: 0.05) {
            self.button1.transform = .identity
            self.button2.transform = .identity
            self.button3.transform = .identity
        }
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
            
            if score > highestScore {
                highestScore = score
                save()
                let ac = UIAlertController(title: "High Score!!!", message: "New high score: \(highestScore)", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "New Game", style: .default, handler: askQuestion))
                present(ac, animated: true)
                score = 0
                return
            }
            
            let ac = UIAlertController(title: "Game Over", message: "Your final score is \(score).", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "New Game", style: .default, handler: askQuestion))
            present(ac, animated: true)
            score = 0
        } else {
            if sender.tag == correctAnswer {
                let ac = UIAlertController(title: title, message: "Your score is \(score).",
                                           preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
                present(ac, animated: true)
            } else {
                let ac = UIAlertController(title: title,
                                           message: """
                                                        That's the flag of \(countries[sender.tag].uppercased())
                                                        Your current score is \(score).
                                                        """,
                                           preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
                present(ac, animated: true)
            }
        }
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5) {
            sender.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }
    }
    
    @IBAction func scoreButtonTapped(_ sender: UIBarButtonItem) {
        let scoreAC = UIAlertController(title: "Score",
                                        message: """
                                                    Your current score: \(score)
                                                    Highest score: \(highestScore)
                                                    """,
                                        preferredStyle: .alert)
        scoreAC.addAction(UIAlertAction(title: "Reset HighScore", style: .default, handler: { _ in
            self.highestScore = 0
            self.save()
        }))
        scoreAC.addAction(UIAlertAction(title: "Ok", style: .default))
        present(scoreAC, animated: true)
    }
    
    func save() {
        let jsonEncoder = JSONEncoder()
        
        if let savedData = try? jsonEncoder.encode(highestScore) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "highScore")
        }
    }
    
    func registerLocal() {
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("granted")
            } else {
                print("not granted")
            }
        }
    }
    
    func scheduleLocal() {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        
        let content = UNMutableNotificationContent()
        content.title = "We miss you!"
        content.body = "Let's play and earn daily points"
        content.categoryIdentifier = "daily"
        content.sound = UNNotificationSound.default
        
        var dateComponent = DateComponents()
        dateComponent.hour = 12
        dateComponent.minute = 30
//        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: true)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
    }
    
}

