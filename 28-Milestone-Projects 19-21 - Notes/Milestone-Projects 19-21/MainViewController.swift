//
//  ViewController.swift
//  ProjectChallenge6
//
//  Created by Yakup Aybars Bal on 7.02.2024.
//

import UIKit

class MainViewController: UITableViewController {
    
    var notes = [Note]()
    var noteCount = 0 {
        didSet {
            totalNotes.title = "\(noteCount) Notes"
        }
    }
    var totalNotes: UIBarButtonItem!
    
    override func viewDidLoad() {
        title = "Notes"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.isToolbarHidden = false
        navigationController?.toolbar.tintColor = .systemYellow
        
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(didComposeTapped))
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        totalNotes = UIBarButtonItem(title: "0 Notes", style: .plain, target: self, action: nil)
        totalNotes.customView?.isUserInteractionEnabled = false
        toolbarItems = [spacer,totalNotes,spacer, doneBtn]
        
        loadNotes()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        cell.view.backgroundColor = .systemGray4
        cell.view.layer.cornerRadius = 10
        tableView.separatorStyle = .singleLine
        
        cell.titleLabel.text = notes[indexPath.section].title
        cell.noteLabel.text = notes[indexPath.section].text
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return notes.count
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let note = notes[indexPath.section]
        
        if let vc = storyboard?.instantiateViewController(withIdentifier: "detail") as? DetailViewController {
            vc.delegate = self
            vc.currentSection = indexPath.section
            vc.currentTitle = note.title
            vc.currentText = note.text
            navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    @objc func didComposeTapped() {
        if let vc = storyboard?.instantiateViewController(identifier: "detail") as? DetailViewController {
            vc.delegate = self
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func save() {
        let encoder = JSONEncoder()
        
        if let savedNote = try? encoder.encode(notes) {
            let defaults = UserDefaults.standard
            defaults.set(savedNote, forKey: "savedNotes")
        }
        
        noteCount = notes.count
    }
    
    func loadNotes() {
        let defaults = UserDefaults.standard
        
        if let savedNotes = defaults.object(forKey: "savedNotes") as? Data {
            let decoder = JSONDecoder()
            
            do {
                notes = try decoder.decode([Note].self, from: savedNotes)
            } catch {
                print("Loading error")
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        save()
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            notes.remove(at: indexPath.section)
            tableView.deleteSections([indexPath.section], with: .automatic)
            save()
        }
    }
}

