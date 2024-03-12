//
//  MainViewController.swift
//  Project4
//
//  Created by Yakup Aybars Bal on 3.01.2024.
//

import UIKit
// Challenge 3
class MainViewController: UITableViewController {
    
    let webSites = ["nba.com", "apple.com", "hackingwithswift.com"]

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Web Pages"
        navigationController?.navigationBar.prefersLargeTitles = true
        
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return webSites.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath)
        cell.textLabel?.text = webSites[indexPath.row]
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(identifier: "Page") as? ViewController {
            vc.currentWebSite = webSites[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
    }

}
