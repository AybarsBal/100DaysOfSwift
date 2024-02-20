//
//  ImageViewController.swift
//  ProjectChallenge3
//
//  Created by Yakup Aybars Bal on 17.01.2024.
//

import UIKit

class ImageViewController: UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    
    var selectedImage: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let imageToLoad = selectedImage {
            imageView.image = imageToLoad
        }

    }
    

}
