//
//  DetailViewController.swift
//  ProjectChallenge6
//
//  Created by Yakup Aybars Bal on 7.02.2024.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet var titleText: UITextField!
    @IBOutlet var textView: UITextView!
    
    var currentTitle = String()
    var currentText = String()
    var currentSection: Int?
    var delegate: MainViewController!
    var isDoneBtnTapped = false
    
    override func viewDidLoad() {
        navigationController?.navigationBar.tintColor = .systemYellow
        titleText.becomeFirstResponder()
        navigationController?.navigationItem.backBarButtonItem?.action = #selector(popBack)
        
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didDoneTapped))
        let trashBtn = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteNote))
        let shareBtn = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didShareTapped))
        navigationItem.rightBarButtonItems = [doneBtn, trashBtn, shareBtn]
        titleText.text = currentTitle
        textView.text = currentText
    }
    
    @objc func didDoneTapped() {
        guard !textView.text.isEmpty else { return }
        if titleText.text == nil { currentTitle = "" }
        currentTitle = titleText.text!
        currentText = textView.text
        
        let note = Note(title: currentTitle, text: currentText)
        
        if currentSection == nil && !isDoneBtnTapped {
            delegate.notes.insert(note, at: 0)
            delegate.save()
            isDoneBtnTapped = true
            delegate.tableView.reloadData()
        } else {
            guard let section = currentSection else { return }
            delegate.notes[section].title = currentTitle
            delegate.notes[section].text = currentText
            delegate.save()
            delegate.tableView.reloadData()
        }
    }
   
    @objc func popBack() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func deleteNote() {
        guard let section = currentSection else { return }
        delegate.notes.remove(at: section)
        delegate.tableView.reloadData()
        navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func didShareTapped() {
        let note = "\(currentTitle) \n \(currentTitle)"
        let avc = UIActivityViewController(activityItems: [note], applicationActivities: [])
        present(avc, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}
