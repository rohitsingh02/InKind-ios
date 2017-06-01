//
//  AboutSignupViewController.swift
//  InKind
//
//  Created by Rohit Singh on 03/05/17.
//  Copyright © 2017 InKind. All rights reserved.
//

import UIKit

class AboutSignupViewController: UIViewController {
    
    @IBOutlet var aboutTextField: KMPlaceholderTextView!
    @IBOutlet var missionTextField: KMPlaceholderTextView!
    
    
    var addNgoModel : AddNgoModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    
    @IBAction func saveAndNextClickListener(_ sender: Any) {
        
        
        self.view.endEditing(true)
        
        if checkForEmptyFields(text: aboutTextField.text!)  && checkForEmptyFields(text: missionTextField.text!) {
            
            addNgoModel?.about = aboutTextField.text
            addNgoModel?.mission = missionTextField.text
            
            performSegue(withIdentifier: "AboutSignupToNeedsSegue", sender: self)
        }else{
            InKindHelper.showErrorMessageAboveNav(title: nil, body: "Some fields are empty. Please try again.")
        }
        
    }

    func checkForEmptyFields(text : String) -> Bool{
        
        guard !text.isEmpty else{
            return false
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "AboutSignupToNeedsSegue" {
            let destinationVc = segue.destination as! NeedsSignupViewController
            
            destinationVc.addNgoModel = self.addNgoModel
        }
    }
   

}
