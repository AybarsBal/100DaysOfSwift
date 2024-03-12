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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "\(currentCountry)"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return details.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailCell", for: indexPath)
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = details[indexPath.row]

        return cell
    }
    
    @objc func shareTapped() {
        let sharedData = details.joined(separator: "\n")
        let title = title
        let shareString = "\(title ?? "") \n \(sharedData)"
        let avc = UIActivityViewController(activityItems: [shareString], applicationActivities: [])
        
        present(avc, animated: true)
    }
    
    
}
