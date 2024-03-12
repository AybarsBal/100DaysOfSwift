//
//  MainCell.swift
//  Milestone-Projects 13-15
//
//  Created by Yakup Aybars Bal on 8.03.2024.
//

import UIKit

class MainCell: UITableViewCell {
    @IBOutlet var countryFlag: UIImageView!
    @IBOutlet var countryName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
