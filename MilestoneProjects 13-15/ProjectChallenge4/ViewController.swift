//
//  ViewController.swift
//  ProjectChallenge4
//
//  Created by Yakup Aybars Bal on 24.01.2024.
//

import UIKit

class ViewController: UITableViewController {
    
    var countries = [String]()
    var facts = [[String]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "TravelMate"
        
        loadText()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        countries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mainCell", for: indexPath)
        
        cell.textLabel?.text = countries[indexPath.row]
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "detail") as? DetailViewController {
            vc.details = facts[indexPath.row]
            vc.currentCountry = countries[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func loadText() {
        if let textFileURL = Bundle.main.url(forResource: "text", withExtension: "txt") {
            if let textContents = try? String(contentsOf: textFileURL) {
                let lines = textContents.components(separatedBy: "\n-\n")
        
                for (_, line) in lines.enumerated() {
                    let parts = line.components(separatedBy: ":\n")
                    countries.append(parts[0])
                    
                    let fact = parts[1].components(separatedBy: "\n")
                    facts.append(fact)
                }
            }
        }
    }
    
    
}

