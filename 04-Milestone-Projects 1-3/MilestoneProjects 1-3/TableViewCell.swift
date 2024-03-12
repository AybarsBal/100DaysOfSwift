//
//  TableViewCell.swift
//  MilestoneProjects 1-3
//
//  Created by Yakup Aybars Bal on 6.03.2024.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet var counrtyImage: UIImageView!
    @IBOutlet var countryLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
