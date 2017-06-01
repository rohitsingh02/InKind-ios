//
//  DonorSignUpViewController.swift
//  InKind
//
//  Created by Rohit Singh on 01/05/17.
//  Copyright © 2017 InKind. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper

class DonorSignUpViewController: UIViewController {

    
    let loadingView: UIView = UIView()
    let actInd: UIActivityIndicatorView = UIActivityIndicatorView()
    
    @IBOutlet var nameTextField: DesignableTextField!
    
    @IBOutlet var emailTextField: DesignableTextField!

    @IBOutlet var passwordTextField: DesignableTextField!
    
    @IBOutlet var confirmPasswordTextField: DesignableTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

   
    @IBAction func signUpSubmitListener(_ sender: Any) {
        
        self.view.endEditing(false)
        
        if checkForEmptyFields(text: nameTextField.text!) &&  checkForEmptyFields(text: emailTextField.text!) && checkForEmptyFields(text: passwordTextField.text!) && checkForEmptyFields(text: confirmPasswordTextField.text!){
        
           
            guard (emailTextField.text?.isEmail)! else{
            
             InKindHelper.showErrorMessageAboveNav(title: nil, body: "Uhoh. Please try again with a valid email ID.")
                return
            }
        
            guard Reachability.isConnectedToNetwork() else{
                
                InKindHelper.showNoInternetMessage()
                return
            }
            
             InKindHelper().showProgressIndicator(loadingView: loadingView, actInd: actInd, view: self.view)
            
            performSignUp()
        }
        else{
          InKindHelper.showErrorMessageAboveNav(title: nil, body: "Some fields are empty. Please try again.")
        }
    }

    func performSignUp(){
    
        
        let headers = [
            "Accept" : "application/json"]
        
        let params = ["name": nameTextField.text!, "email" : emailTextField.text!, "password" : passwordTextField.text!] as [String : Any]
        
        Alamofire.request(BASE_URL + SIGNUP_URL,method:.post, parameters: params,encoding: JSONEncoding.default,headers: headers).responseObject { (response: DataResponse<SignupResponseModel>) in
            
        
                switch response.result {
                    case .success:
                        
                        let signupResponseModel = response.result.value
                        if let signupResponseModel = signupResponseModel{
                            guard signupResponseModel.status == "SUCCESS" else{
                                
                                self.removeProgressDialog()
                                InKindHelper.showErrorMessageAboveNav(title: nil, body:  "Invalid Credentials!!!")
                                return
                            }
                            
                            UserDefaults.standard.set(signupResponseModel.donorId, forKey: "DonorId")
                            UserDefaults.standard.set(true, forKey: isUserLoggedIn)
                            
                            self.removeProgressDialog()
                            
                            self.performSegue(withIdentifier: "SignupToHomeSegue", sender: nil)
                        }
                        break
                    case .failure(let error):
                        print(error)
                        
                        self.removeProgressDialog()
                        InKindHelper.showErrorMessageAboveNav(title: nil, body: "Unable to Signup right now. Please try again after some time.")
                        break
                    }
        }
    }
    
    
    func checkForEmptyFields(text : String) -> Bool{
        
        guard !text.isEmpty else{
            return false
        }
        return true
    }
    
  
    @IBAction func closeButtonListener(_ sender: Any) {
        
        self.view.endEditing(false)
        self.dismiss(animated: true, completion:nil)
    }
    
    
    
    func removeProgressDialog(){
        
        DispatchQueue.main.async {
            if self.actInd.isAnimating{
                self.actInd.stopAnimating()
                self.loadingView.removeFromSuperview()
            }
        }
    }

}
