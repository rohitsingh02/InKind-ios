//
//  AboutDetailTableViewCell.swift
//  InKind
//
//  Created by Rohit Singh on 06/05/17.
//  Copyright © 2017 InKind. All rights reserved.
//

import UIKit

class AboutDetailTableViewCell: UITableViewCell {

    
    
    @IBOutlet weak var titleLabel: UILabel!
    
    
    @IBOutlet weak var descriptionLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
