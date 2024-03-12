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

        title = currentTitle.capitalized
        
        let popBack = UIAction { _ in
            self.navigationController?.popToRootViewController(animated: true)
        }
        navigationController?.navigationItem.backAction = popBack
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didShareTapped))
        
        imageView.image = image
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    @objc func didShareTapped() {
        let avc = UIActivityViewController(activityItems: [image], applicationActivities: [])
        present(avc, animated: true)
    }
}
