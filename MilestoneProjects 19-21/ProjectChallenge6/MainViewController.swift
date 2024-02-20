//
//  ViewController.swift
//  ProjectChallenge6
//
//  Created by Yakup Aybars Bal on 7.02.2024.
//

import UIKit

class MainViewController: UITableViewController {
    var notes = [(text: String, title: String)]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .systemYellow
        navigationController?.toolbar.tintColor = .systemYellow
        navigationController?.isToolbarHidden = false
        let newNote = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(didNewNoteTapped))
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let totalNote = UIBarButtonItem(title: "\(notes.count) notes", style: .plain, target: self, action: nil)
        totalNote.accessibilityRespondsToUserInteraction = false
        toolbarItems = [spacer, totalNote, spacer, newNote]
        
        title = "Notes"
    }

    @objc func didNewNoteTapped() {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "detail") as? DetailViewController else { return }
        vc.completion = { text, title in
            let index = 0
            if vc.doneTapCount != 0 {
                self.notes[index].text = text
                self.notes[index].title = title
            } else {
                self.notes.insert((text: text, title: title), at: index)
            }
            self.tableView.reloadData()
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = notes[indexPath.row].title
        cell.detailTextLabel?.text = notes[indexPath.row].text
        
        return cell
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "detail") as? DetailViewController else { return }
        vc.doneTapCount = 1
        
        
        
        
        navigationController?.pushViewController(vc, animated: true)
    }
}

