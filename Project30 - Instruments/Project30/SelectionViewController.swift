//
//  SelectionViewController.swift
//  Project30
//
//  Created by TwoStraws on 20/08/2016.
//  Copyright (c) 2016 TwoStraws. All rights reserved.
//

import UIKit

class SelectionViewController: UITableViewController {
	var items = [String]() // this is the array that will store the filenames to load
//	var viewControllers = [UIViewController]() // create a cache of the detail view controllers for faster loading
	var dirty = false
    
    // challenge 3
    var smallItems = [String]()
    var didSmallItemsSaved = false

    override func viewDidLoad() {
        super.viewDidLoad()

		title = "Reactionist"

		tableView.rowHeight = 90
		tableView.separatorStyle = .none
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell") //

		// load all the JPEGs into our array
		let fm = FileManager.default
        
        if let path = Bundle.main.resourcePath { // challenge 1
            if let tempItems = try? fm.contentsOfDirectory(atPath: path) {
                for item in tempItems {
                    if item.range(of: "Large") != nil {
                        items.append(item)
                    }
                }
            }
        }
        
        //challenge 3
		addSmallImages()
        let defaults = UserDefaults.standard
        
        if let didSavedData = defaults.value(forKey: "didSaved") as? Data {
            let decoder = JSONDecoder()
            do {
                didSmallItemsSaved = try decoder.decode(Bool.self, from: didSavedData)
            } catch {
                print("didSaved loadding error")
            }
        }
        
        if !didSmallItemsSaved {
            for item in smallItems {
                guard let path = Bundle.main.path(forResource: item, ofType: nil) else { return } // challenge 1
                guard let image = UIImage(contentsOfFile: path) else { return } // challenge 1
                saveSmallImages(image: image, imageName: item)
            }
            didSmallItemsSaved = true
            save()
        }
    }

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		if dirty {
			// we've been marked as needing a counter reload, so reload the whole table
			tableView.reloadData()
		}
	}

    // MARK: - Table view data source

	override func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return items.count * 10
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//		let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

		// find the image for this cell, and load its thumbnail
//		let currentImage = items[indexPath.row % items.count]
//		let imageRootName = currentImage.replacingOccurrences(of: "Large", with: "Thumb")
//       let path = Bundle.main.path(forResource: imageRootName, ofType: nil)!
//		let original = UIImage(contentsOfFile: path)!
        
        //challenge 3
        let currentImage = smallItems[indexPath.row % items.count]
        let path = getDocumentsDirectory().appendingPathComponent(currentImage)
        guard let original = UIImage(contentsOfFile: path.path) else { fatalError() } //challenge 1
        

        let renderRect = CGRect(origin: .zero, size: CGSize(width: 90, height: 90)) // scaled down to the size it needs to be for actual usage
//		let renderer = UIGraphicsImageRenderer(size: original.size)
        let renderer = UIGraphicsImageRenderer(size: renderRect.size)

		let rounded = renderer.image { ctx in
//			ctx.cgContext.addEllipse(in: CGRect(origin: CGPoint.zero, size: original.size))
            ctx.cgContext.addEllipse(in: renderRect)
			ctx.cgContext.clip()

//			original.draw(at: CGPoint.zero)
            original.draw(in: renderRect)
		}

		cell.imageView?.image = rounded

		// give the images a nice shadow to make them look a bit more dramatic
		cell.imageView?.layer.shadowColor = UIColor.black.cgColor
		cell.imageView?.layer.shadowOpacity = 1
		cell.imageView?.layer.shadowRadius = 10
		cell.imageView?.layer.shadowOffset = CGSize.zero
        cell.imageView?.layer.shadowPath = UIBezierPath(ovalIn: renderRect).cgPath // to eliminated the second render pass

		// each image stores how often it's been tapped
		let defaults = UserDefaults.standard
		cell.textLabel?.text = "\(defaults.integer(forKey: currentImage))"

		return cell
    }

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let vc = ImageViewController()
		vc.image = smallItems[indexPath.row % items.count] // challenge 3
		vc.owner = self

		// mark us as not needing a counter reload when we return
		dirty = false

		// add to our view controller cache and show
//		viewControllers.append(vc) // the cache never be used anywhere so we deleted it
        navigationController?.pushViewController(vc, animated: true)
	}
    
    
    // challenge 3
    func addSmallImages() {
        for item in items {
            let imageRootName = item.replacingOccurrences(of: "Large", with: "Thumb")
            smallItems.append(imageRootName)
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func saveSmallImages(image: UIImage, imageName: String) {
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
       
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
    }
    
    func save() {
        let encoder = JSONEncoder()
        
        if let savedData = try? encoder.encode(didSmallItemsSaved) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "didSaved")
        }
    }
    
    // Challenge 2: Project1 DetailViewController
}
