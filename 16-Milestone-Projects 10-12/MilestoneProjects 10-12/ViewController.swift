//
//  ViewController.swift
//  ProjectChallenge3
//
//  Created by Yakup Aybars Bal on 17.01.2024.
//

import UIKit

class ViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate {
    
    var captions = [String]()
    var images = [Image]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addImage))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(clearDefaults))
        
        let defaults = UserDefaults.standard
        
        if let savedImages = defaults.object(forKey: "savedImages") as? Data {
            let decoder = JSONDecoder()
            
            do {
                images = try decoder.decode([Image].self, from: savedImages)
            } catch {
                print("Image loading error")
            }
        }
        
        if let savedCaptions = defaults.object(forKey: "savedCaptions") as? Data {
            let decoder = JSONDecoder()
            
            do {
                captions = try decoder.decode([String].self, from: savedCaptions)
            } catch {
                print("Image loading error")
            }
        }
        
        let lpgr = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        lpgr.minimumPressDuration = 0.5
        lpgr.delaysTouchesBegan = true
        lpgr.delegate = self
        self.tableView.addGestureRecognizer(lpgr)
    }
    
    @objc func handleLongPress(gestureReconizer: UILongPressGestureRecognizer) {
        
        if gestureReconizer.state == UILongPressGestureRecognizer.State.began {
            let p = gestureReconizer.location(in: self.tableView)
            let indexPath = self.tableView.indexPathForRow(at: p)
            
            if let index = indexPath {
                print("gesture tapped")
                
                let ac = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                ac.addAction(UIAlertAction(title: "Delete Photo", style: .default, handler: { [weak self] _ in
                    self?.captions.remove(at: index.row)
                    self?.images.remove(at: index.row)
                    self?.save()
                    self?.tableView.reloadData()
                }))
                present(ac, animated: true)
            } else {
                print("Could not find index path")
            }
        }
        
    }
    
    @objc func clearDefaults() {
        let ac = UIAlertController(title: nil, message: "Your photos will delete, are you sure?", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.addAction(UIAlertAction(title: "Delete", style: .default, handler: { [weak self] _ in
            self?.captions.removeAll()
            self?.images.removeAll()
            self?.save()
            self?.tableView.reloadData()
        }))
        present(ac, animated: true)
    }
    
    @objc func addImage() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.sourceType = .camera
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.editedImage] as? UIImage else { return }
        
        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        
        let saveImage = Image(caption: "", image: imageName)
        images.append(saveImage)
        save()
        
        dismiss(animated: true) {
            let ac = UIAlertController(title: "Caption for Image", message: nil, preferredStyle: .alert)
            ac.addTextField()
            ac.addAction(UIAlertAction(title: "Submit", style: .default, handler: { [weak self] _ in
                guard let caption = ac.textFields?[0].text else { return }
                self?.captions.append(caption)
                self?.save()
                self?.tableView.reloadData()
            }))
            self.present(ac, animated: true)
        }
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return captions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MainViewTableViewCell
        
        var currentImage = images[indexPath.row]
        currentImage.caption = captions[indexPath.row]
        
        cell.mainCellLabel.text = currentImage.caption
        
        let path = getDocumentsDirectory().appendingPathComponent(currentImage.image)
        cell.mainCellImage.image = UIImage(contentsOfFile: path.path)
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let vc = storyboard?.instantiateViewController(identifier: "Detail") as? ImageViewController {
            
            var currentImage = images[indexPath.row]
            currentImage.caption = captions[indexPath.row]
            
            vc.title = currentImage.caption
            
            let path = getDocumentsDirectory().appendingPathComponent(currentImage.image)
            vc.selectedImage = UIImage(contentsOfFile: path.path)
            
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func deleteImage(indexpath: IndexPath) {
        
    }
    
    func save() {
        let encoder = JSONEncoder()
        
        if let savedData = try? encoder.encode(images) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "savedImages")
        }
        
        if let savedData = try? encoder.encode(captions) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "savedCaptions")
        }
    }
    
}

