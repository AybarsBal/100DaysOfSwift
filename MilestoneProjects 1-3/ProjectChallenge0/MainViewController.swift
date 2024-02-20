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
        
        countries.append("UK")
        countries.append("Germany")
        countries.append("Netherlands")
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = countries[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = storyboard?.instantiateViewController(identifier: "detail") as? DetailViewController else { return }
        vc.currentTitle = countries[indexPath.row]
        
        navigationController?.pushViewController(vc, animated: true)
    }
}

