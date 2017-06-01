//
//  LoginDonorViewController.swift
//  InKind
//
//  Created by Rohit Singh on 01/05/17.
//  Copyright © 2017 InKind. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper

class LoginDonorViewController: UIViewController {

    let loadingView: UIView = UIView()
    let actInd: UIActivityIndicatorView = UIActivityIndicatorView()
    
    @IBOutlet var emailTextField: DesignableTextField!
    
    @IBOutlet var passwordTextField: DesignableTextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
    }

  
    @IBAction func loginButtonListener(_ sender: Any) {
        if checkForEmptyFields(text: emailTextField.text!)  && checkForEmptyFields(text: passwordTextField.text!){
        
            self.view.endEditing(false)

            guard (emailTextField.text?.isEmail)! else{
            
              // print wrong email error
               InKindHelper.showErrorMessageAboveNav(title: nil, body: "Uhoh. Please try again with a valid email ID.")
               return
            }
            
            guard Reachability.isConnectedToNetwork() else{
            
              InKindHelper.showNoInternetMessage()
              return
            }
            
            InKindHelper().showProgressIndicator(loadingView: loadingView, actInd: actInd, view: self.view)
  
            
            
           performLogin(email: emailTextField.text!, password: passwordTextField.text!)
            
        }
        else{
          
         InKindHelper.showErrorMessageAboveNav(title: nil, body: "Some fields are empty. Please try again.")
        }
    }
    
    func performLogin(email: String, password: String){
        
        
        let headers = ["Content-Type" : "application/json",
"Accept" : "application/json"]
        
        let params = ["email" : "\(email)", "password" : "\(password)"]
        
        Alamofire.request(BASE_URL + LOGIN_URL,method:.post, parameters: params,encoding: JSONEncoding.default, headers: headers).responseObject { (response: DataResponse<LoginResponseModel>) in
            
            print(response)
            print(response.result)
            
            switch response.result {
            case .success:
                
                let loginResponseModel = response.result.value
                
                if let loginResponseModel = loginResponseModel{
                    guard loginResponseModel.status == "SUCCESS" else{
                        
                        self.removeProgressDialog()
                        InKindHelper.showErrorMessageAboveNav(title: nil, body: "Invalid Credentials!!!")
                        return
                    }
                    
                    UserDefaults.standard.set(loginResponseModel.donorId, forKey: "DonorId")
                    UserDefaults.standard.set(true, forKey: isUserLoggedIn)
                    
                    self.removeProgressDialog()
                    
                    self.performSegue(withIdentifier: "LoginToHomeSegue", sender: nil)
                }
                break
            case .failure(let error):
                print(error)
                self.removeProgressDialog()
                InKindHelper.showErrorMessageAboveNav(title: nil, body: "Invalid Credentials!!!")
                break
                
            }
            
            
        }
    }
    
    
    func removeProgressDialog(){
        
        DispatchQueue.main.async {
           // if self.actInd.isAnimating{
                self.actInd.stopAnimating()
                self.loadingView.removeFromSuperview()
           // }
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
    
    
    //{"status":"SUCCESS","errorMsg":null,"sessionKey":"S4DECGJTp6MgbLwJwgG9vA==","donorId":2}

}
