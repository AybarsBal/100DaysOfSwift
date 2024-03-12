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
        
        title = "\(currentCountry)"
        
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
        cell.backgroundColor = UIColor(white: 0.7, alpha: 0.6)

        return cell
    }
    
    @objc func shareTapped() {
        let sharedData = details.joined(separator: "\n")
        let title = title
        let shareString = "\(title ?? "") \n \(sharedData)"
        let avc = UIActivityViewController(activityItems: [shareString], applicationActivities: [])
        
        present(avc, animated: true)
    }
    
    @objc func changeBgImg() {
        tableView.backgroundView = UIImageView(image: UIImage(named: "\(currentCountry.lowercased())\(count).jpeg"))
        tableView.backgroundView?.alpha = 1
        
        count += 1
        if count > 3 { count = 1}
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}
