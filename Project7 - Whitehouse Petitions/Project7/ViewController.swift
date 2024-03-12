//
//  ViewController.swift
//  Project7
//
//  Created by Yakup Aybars Bal on 5.01.2024.
//

import UIKit

class ViewController: UITableViewController {
    var petitions = [Petition]()
    var filteredResults = [Petition]() // Challenge 2
    var screenedPetitions = [Petition]() // Challenge 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Challenge 1
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Credits", style: .plain, target: self, action: #selector(showCredits))
        
        // Challenge 2
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self , action:#selector(filterResults))
        
        let urlString: String
        
        if navigationController?.tabBarItem.tag == 0 {
            // urlString = "https://api.whitehouse.gov/v1/petitions.json?limit=100"
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            // urlString = "https://api.whitehouse.gov/v1/petitions.json?signatureCountFloor=10000&limit=100"
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            if let url = URL(string: urlString) {
                if let data = try? Data(contentsOf: url) {
                    self.parse(json: data)
                    return
                }
            }
            self.showError()
        }
        
    }
    
    // Challenge 2
    @objc func filterResults() {
        let ac = UIAlertController(title: "Please type for filter", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.addAction(UIAlertAction(title: "Filter", style: .default, handler: { _ in
            self.filteredResults.removeAll()
            if let filter = ac.textFields?[0].text {
                for petition in self.petitions {
                    if  petition.body.lowercased().contains("\(filter.lowercased())") ||
                            petition.title.lowercased().contains("\(filter.lowercased())") {
                        self.filteredResults.append(petition)
                    }
                }
                self.screenedPetitions = self.filteredResults
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }))
        ac.addAction(UIAlertAction(title: "Remove Filter", style: .default, handler: { _ in
            self.screenedPetitions = self.petitions
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }))
        present(ac, animated: true)
    }
    
    // Challenge 1
    @objc func showCredits() {
        let ac = UIAlertController(title: "Credits", message: "All the datas come from the We The People API of the Whitehouse", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .cancel))
        present(ac, animated: true)
    }
    
    func showError() {
        DispatchQueue.main.async {
            let ac = UIAlertController(title: "Loading error", message: "Please check your internet connection and try again later.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .cancel))
            self.present(ac, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return screenedPetitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let petition = screenedPetitions[indexPath.row]
        
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        
        return cell
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            screenedPetitions = petitions
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = petitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}

