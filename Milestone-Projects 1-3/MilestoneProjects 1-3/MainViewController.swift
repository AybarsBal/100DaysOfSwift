//
//  ViewController.swift
//  ProjectChallenge0
//
//  Created by Yakup Aybars Bal on 12.02.2024.
//

import UIKit

class MainViewController: UITableViewController {
    
    var countries = [String]()
    var currentTitle = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        countries = ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "spain", "russia", "uk", "us"]
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? TableViewCell else { fatalError() }
        cell.countryLabel.text = countries[indexPath.row]
        cell.counrtyImage.image = UIImage(named: countries[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = storyboard?.instantiateViewController(identifier: "detail") as? DetailViewController else { return }
        vc.currentTitle = countries[indexPath.row]
        if let image = UIImage(named: countries[indexPath.row]) {
            vc.image = image
        }
        
        navigationController?.pushViewController(vc, animated: true)
    }
}

