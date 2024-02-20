//
//  DetailViewController.swift
//  ProjectChallenge6
//
//  Created by Yakup Aybars Bal on 7.02.2024.
//

import UIKit

class DetailViewController: UIViewController, UITextViewDelegate {
    @IBOutlet var textView: UITextView!
    @IBOutlet var titleText: UITextField!
    
    public var completion: ((String, String) -> Void)?
    var doneTapCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneTapped))
        navigationItem.backAction = UIAction { _ in
            self.navigationController?.popToRootViewController(animated: true) }
        
    }
    
    @objc func doneTapped() {
        if let text = textView.text, !textView.text.isEmpty, titleText.text != nil {
            completion?(text, titleText.text!)
            doneTapCount += 1
        } else { return }
        view.endEditing(true)
    }

    @objc func printTapped() {
        guard let vc = storyboard?.instantiateViewController(identifier: "main") as? MainViewController else { return }
        print(vc.notes)
    }
    
    @objc func didBackBtnTapped() {
        navigationController?.popToRootViewController(animated: true)
        doneTapCount = 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}
