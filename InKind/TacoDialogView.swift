//
//  TacoDialogView.swift
//  Demo
//
//  Created by Tim Moose on 8/12/16.
//  Copyright © 2016 SwiftKick Mobile. All rights reserved.
//

import UIKit
import SwiftMessages

class TacoDialogView: MessageView {

    var name = ""
    var email = ""
    var contactNo = ""
    
    
    @IBOutlet weak var nameLabel: UILabel!
  
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var contactLabel: UILabel!
    var cancelAction: (() -> Void)?
    
    fileprivate var count = 1 {
        didSet {
            nameLabel?.text = name
            emailLabel.text = email
            contactLabel.text = contactNo
        }
    }
    
   

    @IBAction func cancel() {
        cancelAction?()
    }
    
    
    
}
