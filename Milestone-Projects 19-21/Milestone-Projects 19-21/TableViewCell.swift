//
//  TableViewCell.swift
//  Milestone-Projects 19-21
//
//  Created by Yakup Aybars Bal on 8.03.2024.
//

import UIKit

class TableViewCell: UITableViewCell {
    @IBOutlet var view: UIView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var noteLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
