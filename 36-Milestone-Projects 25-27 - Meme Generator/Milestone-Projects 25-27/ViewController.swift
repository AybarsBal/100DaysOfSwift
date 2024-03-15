//
//  ViewController.swift
//  ProjectChallenge7
//
//  Created by Yakup Aybars Bal on 16.02.2024.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    @IBOutlet var imageView: UIImageView!
    
    var currentImage: UIImage?
    var topText: String?
    var bottomText: String?
    
    enum Position {
        case top
        case bottom
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Meme Generator"
        
        navigationController?.isToolbarHidden = false
        let importPictureBtn = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(importPicture))
        let setTopTextBtn = UIBarButtonItem(title: "Top Text", style: .plain, target: self, action: #selector(setTopText))
        let setBottomTextBtn = UIBarButtonItem(title: "Bottom Text", style: .plain, target: self, action: #selector(setBottomText))
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        toolbarItems = [setTopTextBtn,spacer, importPictureBtn,spacer ,setBottomTextBtn]
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didactbtnTapped))
    }

    @objc func importPicture() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        dismiss(animated: true)
        
        imageView.image = image
        currentImage = image
    }
    
    @objc func didactbtnTapped() {
        guard let image = imageView.image else { return }
        let avc = UIActivityViewController(activityItems: [image], applicationActivities: [])
        present(avc, animated: true)
    }
    
    @objc func setTopText() {
        setText(to: .top)
    }
    
    @objc func setBottomText() {
        setText(to: .bottom)
    }
    
    func setText(to position: Position) {
        let ac = UIAlertController(title: "Enter Text", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.addAction(UIAlertAction(title: "Submit", style: .default, handler: { [weak self, weak ac] _ in
            guard let text = ac?.textFields?[0].text else { return }
            if position == .top { self?.topText = text }
            if position == .bottom { self?.bottomText = text }
            
            self?.generateMeme(to: position)
        }))
        present(ac, animated: true)
    }
    
    func generateMeme(to position: Position) {
        guard let image = currentImage else { return }
        
        let renderer = UIGraphicsImageRenderer(size: image.size)
        
        let img = renderer.image { [weak self] ctx in
            image.draw(at: CGPoint(x: 0, y: 0))
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            
            let attrs: [NSAttributedString.Key : Any] = [
                .font: UIFont(name: "Helvetica", size: CGFloat(image.size.height) / 10)!,
                .foregroundColor: UIColor.white,
                .paragraphStyle: paragraphStyle
            ]
                      
            let margin = 24
            let textHeight = Int(image.size.height / 5)
            
            if let text = self?.topText {
                let attributedString = NSAttributedString(string: text, attributes: attrs)
                attributedString.draw(with: CGRect(x: 24, y: 24, width: Int(image.size.width) - margin, height: Int(image.size.height) / 5), options: .usesLineFragmentOrigin, context: nil)
            }
            if let text = self?.bottomText {
                let attributedString = NSAttributedString(string: text, attributes: attrs)
                attributedString.draw(with: CGRect(x: 24, y: Int(image.size.height) - textHeight + margin, width: Int(image.size.width) - margin, height: Int(image.size.height) / 5), options: .usesLineFragmentOrigin, context: nil)
            }
        }
        imageView.image = img
    }
}

