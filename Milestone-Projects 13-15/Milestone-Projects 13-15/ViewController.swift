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
    let flags = ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "spain", "uk", "us"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "TravelMate"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        loadText()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        countries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mainCell", for: indexPath) as! MainCell
        cell.countryFlag.image = UIImage(named: flags[indexPath.row])
        cell.countryName.text = "\(countries[indexPath.row])"
        cell.countryFlag.layer.borderColor = UIColor.lightGray.cgColor
        cell.countryFlag.layer.borderWidth = 1
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

