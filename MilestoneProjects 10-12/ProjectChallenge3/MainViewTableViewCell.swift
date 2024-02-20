//
//  MainViewTableViewCell.swift
//  ProjectChallenge3
//
//  Created by Yakup Aybars Bal on 17.01.2024.
//

import UIKit

class MainViewTableViewCell: UITableViewCell {
    
    @IBOutlet var mainCellImage: UIImageView!
    @IBOutlet var mainCellLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
