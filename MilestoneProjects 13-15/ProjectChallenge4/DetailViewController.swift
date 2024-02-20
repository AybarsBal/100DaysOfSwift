//
//  DetailViewController.swift
//  ProjectChallenge4
//
//  Created by Yakup Aybars Bal on 24.01.2024.
//

import UIKit

class DetailViewController: UITableViewController {
    
    var details = [String]()
    var currentCountry = String()
    var count = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Facts about \(currentCountry)"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        
        tableView.backgroundView = UIImageView(image: UIImage(named: "\(currentCountry.lowercased())\(1).jpeg"))
        
        Timer.scheduledTimer(timeInterval: 8, target: self, selector: #selector(changeBgImg), userInfo: nil, repeats: true)
        
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return details.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailCell", for: indexPath)
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = details[indexPath.row]
        cell.textLabel?.textColor = .black
        cell.backgroundColor = UIColor(white: 1, alpha: 0.4)

        return cell
    }
    
    @objc func shareTapped() {
        let sharedData = details.joined(separator: "\n")
        let avc = UIActivityViewController(activityItems: [sharedData], applicationActivities: [])
        
        present(avc, animated: true)
    }
    
    @objc func changeBgImg() {
        tableView.backgroundView = UIImageView(image: UIImage(named: "\(currentCountry.lowercased())\(count).jpeg"))
        tableView.backgroundView?.alpha = 1
        
        count += 1
        if count > 3 { count = 1}
    }
    
}
