//
//  DetailViewController.swift
//  ProjectChallenge0
//
//  Created by Yakup Aybars Bal on 12.02.2024.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    
    var currentTitle = ""
    var image = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = currentTitle
        
        let popBack = UIAction { _ in
            self.navigationController?.popToRootViewController(animated: true)
        }
        navigationController?.navigationItem.backAction = popBack
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didShareTapped))
        
        imageView.image = UIImage(systemName: "pencil")
    }
    
    @objc func didShareTapped() {
        let avc = UIActivityViewController(activityItems: [image, currentTitle], applicationActivities: [])
        present(avc, animated: true)
    }
}
