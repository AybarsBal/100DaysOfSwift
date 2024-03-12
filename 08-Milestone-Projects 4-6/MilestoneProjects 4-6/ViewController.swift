//
//  ViewController.swift
//  ProjectChallge1
//
//  Created by Yakup Aybars Bal on 5.01.2024.
//

import UIKit

class ViewController: UITableViewController {
    
    var shoppingList = [String]()
    var sharedList = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Shopping List"
        
        let shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareList))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addShoppingItem))
        navigationItem.rightBarButtonItems?.append(shareButton)
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(clearList))
        
        let defaults = UserDefaults.standard
        
        if let savedData = defaults.object(forKey: "savedList") as? Data {
            let decoder = JSONDecoder()
            
            do {
                shoppingList = try decoder.decode([String].self, from: savedData)
            } catch {
                print("Loading error")
            }
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoppingList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = shoppingList[indexPath.row]
        
        return cell
    }
    
    @objc func addShoppingItem() {
        let ac = UIAlertController(title: "New Item", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Submit", style: .default, handler: { _ in
            if let newItem = ac.textFields?[0].text {
                self.shoppingList.insert(newItem, at: 0)
                self.save()
                let indexPath = IndexPath(row: 0, section: 0)
                self.tableView.insertRows(at: [indexPath], with: .automatic)
            }
        }))
        present(ac, animated: true)
    }
    
    @objc func clearList() {
        let ac = UIAlertController(title: "Warning", message: "List will be clear, are you sure?", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Delete", style: .default, handler: { _ in
            self.shoppingList.removeAll()
            self.save()
            self.tableView.reloadData()
        }))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    @objc func shareList() {
        sharedList = shoppingList.joined(separator: "\n")
        let avc = UIActivityViewController(activityItems: [sharedList], applicationActivities: [])
        
        present(avc, animated: true)
    }
    
    func save() {
        let encoder = JSONEncoder()
        
        if let savedData = try? encoder.encode(shoppingList) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "savedList")
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            shoppingList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
}

