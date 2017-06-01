//
//  HomeTableViewCell.swift
//  InKind
//
//  Created by Rohit Singh on 30/04/17.
//  Copyright © 2017 InKind. All rights reserved.
//

import UIKit

class HomeTableViewCell: UITableViewCell {

    @IBOutlet var backgroundImage: UIImageView!
    
    @IBOutlet var titleLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
