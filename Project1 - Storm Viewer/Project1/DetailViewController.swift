//
//  DetailViewController.swift
//  Project1
//
//  Created by Yakup Aybars Bal on 20.12.2023.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    var selectedImage: String?
    var selectedImageNumber: Int = 0 // Challenge 3
    let totalImages: Int = 10 // Challenge 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Picture \(selectedImageNumber) of \(totalImages)" // Challenge 3
        navigationItem.largeTitleDisplayMode = .never

        if let imageToLoad = selectedImage {
            // day98 - Challenge 2
            let path = Bundle.main.path(forResource: imageToLoad, ofType: nil)!
            imageView.image  = UIImage(contentsOfFile: path)
        }
        
        // Day65 - Challenge 2
        assert(selectedImage != nil, "selected image is nil")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }


}
