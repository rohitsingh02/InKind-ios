//
//  AccountManagerViewController.swift
//  InKind
//
//  Created by Rohit Singh on 03/05/17.
//  Copyright © 2017 InKind. All rights reserved.
//

import UIKit

class AccountManagerViewController: UIViewController {

    
    @IBOutlet var contactName: DesignableTextField!
    
    @IBOutlet var designationField: DesignableTextField!
    
    
    @IBOutlet var mobileNumberField: DesignableTextField!
    
    @IBOutlet var emailField: DesignableTextField!
    
    var addNgoModel : AddNgoModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func saveAndNextClickListener(_ sender: Any) {
        
        if checkForEmptyFields(text: contactName.text!)  && checkForEmptyFields(text: designationField.text!) && checkForEmptyFields(text: mobileNumberField.text!) && checkForEmptyFields(text: emailField.text!) {
        
            
            self.view.endEditing(false)
            
            guard (emailField.text?.isEmail)! else{
                InKindHelper.showErrorMessageAboveNav(title: nil , body: "Uhoh. Please try again with a valid email ID.")
                return
            }
            
            addNgoModel?.admin = setAdminModel()
            addNgoModel?.address?.contact1 = mobileNumberField.text
            addNgoModel?.registeredAddress?.contact1 = mobileNumberField.text
            
             performSegue(withIdentifier: "AccountManagerToAboutSegue", sender: self)
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
    
    
    func setAdminModel() -> AdminModel{
    
      let adminModel = AdminModel()
      adminModel.name = contactName.text
      adminModel.email = emailField.text
      //adminModel.designation = designationField.text
      adminModel.profilePic = ""
      adminModel.status = "ACTIVE"
       
      return adminModel
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "AccountManagerToAboutSegue" {
            let destinationVc = segue.destination as! AboutSignupViewController
            
            destinationVc.addNgoModel = self.addNgoModel
        }
        
    }

}
