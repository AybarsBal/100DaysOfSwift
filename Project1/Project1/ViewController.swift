//
//  ViewController.swift
//  Project1
//
//  Created by Yakup Aybars Bal on 20.12.2023.
//

import UIKit

class ViewController: UITableViewController {
    
    var pictures = [String]()
    var counts = [String: Int]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Storm Viewer"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        loadData()
        
        
        let defaults = UserDefaults.standard
        
        if let countsData = defaults.value(forKey: "savedCounts") as? Data {
            let decoder = JSONDecoder()
            
            do {
                counts = try decoder.decode([String: Int].self, from: countsData)
            } catch {
                print("Count loadding error")
            }
        }
        
        print(pictures)
    }
    
    func loadData() {
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        
        for item in items {
            if item.hasPrefix("nssl") {
                pictures.append(item)
            }
        }
        
        pictures.sort()
        
        for i in 0..<pictures.count {
            counts[pictures[i]] = 0
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        cell.textLabel?.text = pictures[indexPath.row]
        cell.textLabel?.font = .boldSystemFont(ofSize: 20)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(identifier: "Detail") as? DetailViewController {
            vc.selectedImage = pictures[indexPath.row]
            vc.selectedImageNumber = indexPath.row + 1
            counts[pictures[indexPath.row]]! += 1
            save()
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func save() {
        let encoder = JSONEncoder()
        
        if let savedData = try? encoder.encode(counts) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "savedCounts")
        }
    }
}

