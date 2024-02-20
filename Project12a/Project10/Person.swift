//
//  Person.swift
//  Project10
//
//  Created by Yakup Aybars Bal on 12.01.2024.
//

import UIKit

class Person: NSObject, NSCoding {

    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
    
    required init?(coder: NSCoder) { // reading out of the disk
        name = coder.decodeObject(forKey: "name") as? String ?? ""
        image = coder.decodeObject(forKey: "image") as? String ?? ""
    }
    
    func encode(with coder: NSCoder) { // writing to disk
        coder.encode(name, forKey: "name")
        coder.encode(image, forKey: "image")
    }
}
