//
//  ViewController.swift
//  Project5
//
//  Created by Yakup Aybars Bal on 12.02.2024.
//

import UIKit

class ViewController: UITableViewController {
    
    var allWords = [String]()
    var usedWords = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let startWordURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordURL) {
                allWords = startWords.components(separatedBy: "\n")
            }
        }
        if allWords.isEmpty {
            allWords = ["silkworm"]
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
        
        // Challenge 3
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "New Game", style: .plain, target: self, action: #selector(startGame))
        
        // Day49 - Challenge 3
        let defaults = UserDefaults.standard
        if let savedData = defaults.value(forKey: "savedWords") as? Data, let savedTitle = defaults.value(forKey: "savedTitle") as? Data {
            let decoder = JSONDecoder()
            do {
                usedWords = try decoder.decode([String].self, from: savedData)
                title = try decoder.decode(String.self, from: savedTitle)
            } catch {
                print("Loading savedData error!")
            }
        } else {
            startGame()
        }
        
    }

    @objc func startGame() {
        title = allWords.randomElement()
        usedWords.removeAll(keepingCapacity: true)
        save() // Day49 - Challenge 3
        tableView.reloadData()
    }
    
    @objc func promptForAnswer() {
        let ac = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self, weak ac] _ in
            guard let answer = ac?.textFields?[0].text else { return }
            self?.submit(answer)
            self?.save() // Day49 - Challenge 3
        }
        
        ac.addAction(submitAction)
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    func submit(_ answer: String) {
        let lowerAnswer = answer.lowercased()
        // Day65 - Challenge 3: Added conditional breakpoint
        if isPossible(word: lowerAnswer) {
            if isOriginal(word: lowerAnswer) {
                if isReal(word: lowerAnswer) {
                    usedWords.insert(answer, at: 0)
                    
                    let indexPath = IndexPath(row: 0, section: 0)
                    tableView.insertRows(at: [indexPath], with: .automatic)
                } else {
                    showErrorMessage(title: "Word not recognised", message: "You can't just make them up, you know!") // Challenge 2
                }
            } else {
                showErrorMessage(title: "Word used already", message: "Be more original!") // Challenge 2
            }
        } else {
            showErrorMessage(title: "Word not possible", message: "You can't spell that word from \(title!)") // Challenge 2
        }
    }
    
    func isPossible(word: String) -> Bool {
        guard var tempWord = title?.lowercased() else { return false }
        
        for letter in word {
            if let position = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: position)
            } else {
                return false
            }
        }
        
        return true
    }
    
    func isOriginal(word: String) -> Bool {
        return !usedWords.contains(word)
    }
    
    func isReal(word: String) -> Bool {
        if word.utf16.count < 3 { // Challenge 1
            showErrorMessage(title: "Oops..", message: "Answer can't be shorter then three letters") // Challenge 2
            return false
        }
        
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        if misspelledRange.location == NSNotFound {
            // Challenge 1
            guard let tempWord = title?.lowercased() else { return false }
            if tempWord.hasPrefix(word) {
                showErrorMessage(title: "Nice try!", message: "Answer can't be the start word") // Challenge 2
                return false
            }
            return true
        } else { return false }
    }
    
    // Challenge 2
    func showErrorMessage(title: String, message: String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usedWords.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
        cell.textLabel?.text = usedWords[indexPath.row]
        return cell
    }
    
    // Day49 - Challenge 3
    func save() {
        let encoder = JSONEncoder()
        
        if let wordsData = try? encoder.encode(usedWords) {
            let defaults = UserDefaults.standard
            defaults.set(wordsData, forKey: "savedWords")
        }
        
        if let titleData = try? encoder.encode(title) {
            let defaults = UserDefaults.standard
            defaults.set(titleData, forKey: "savedTitle")
        }
    }
}

