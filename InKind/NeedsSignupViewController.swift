//
//  NeedsSignupViewController.swift
//  InKind
//
//  Created by Rohit Singh on 03/05/17.
//  Copyright © 2017 InKind. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper

class NeedsSignupViewController: UIViewController, MultipleSelectionControllerDelegate {

    @IBOutlet weak var showCausesView: DesignableView!
    var addNgoModel : AddNgoModel?
    
    let loadingView: UIView = UIView()
    let actInd: UIActivityIndicatorView = UIActivityIndicatorView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showCausesView.isHidden = true
        InKindHelper().showProgressIndicator(loadingView: loadingView, actInd: actInd, view: self.view)
        getCausesList()

    }

    var causesList : [CausesModel] = []
    var selectedCauseList : [CausesModel] = []
    
    @IBOutlet weak var causesTv: KMPlaceholderTextView!
    //MARK: SelectControllerDelegate
    
    
    func selectedCausesArray(selectedArray: [CausesModel]){
        self.selectedCauseList = selectedArray
        setCausesToTextView()
    }
    
    func setCausesToTextView(){
    
      causesTv.text = getCausesString(causesList: selectedCauseList)
      showCausesView.isHidden = false
    }
    
    
    func getCausesString(causesList : [CausesModel]) -> String{
      
      var causeString = ""
       

        for var i in (0..<causesList.count)
        {
            if (i != causesList.count - 1){
                causeString += causesList[i].name! + ", "
            }
            else{
              causeString += causesList[i].name!
            }
        }
        
     return causeString
    
    }
    
    
    @IBAction func saveAndNextBtnListener(_ sender: Any) {
       
        if self.selectedCauseList.count != 0{
          addNgoModel?.categoriesSupported = selectedCauseList

          InKindHelper().showProgressIndicator(loadingView: loadingView, actInd: actInd, view: self.view)
          addNewNgo(addNgoModel: addNgoModel!)
        }
        else{
          InKindHelper.showErrorMessageAboveNav(title: nil, body: "Some fields are empty. Please try again.")
        }
    }
    
    
    func addNewNgo(addNgoModel: AddNgoModel){
        
        let headers = ["Content-Type" : "application/json",
                       "Accept" : "application/json"]
        
        let params = addNgoModel.toJSON() as [String : AnyObject]
        
        
        print(addNgoModel.toJSON())
        
        Alamofire.request(BASE_URL + ADD_NGO,method:.post, parameters: params,encoding: JSONEncoding.default, headers: headers).responseObject { (response: DataResponse<OrganizationSignupSuccessModel>) in
            

            switch response.result {
            case .success:
                
                let organizationSignupSuccessModel = response.result.value
                
                if let organizationModel = organizationSignupSuccessModel{
                    guard organizationModel.status == "SUCCESS" else{
                        InKindHelper.showErrorMessageAboveNav(title: nil, body: "Invalid Credentials!!!")
                        return
                    }
                    
                    //UserDefaults.standard.set(true, forKey: isUserLoggedIn)
                    
                    
                    self.removeProgressDialog()
                    
                    InKindHelper.showErrorMessageAboveNav(title: nil, body: "NGO Added Successfully!!!")
                    
                    
                    self.performSegue(withIdentifier: "needsToLandingSegue", sender: self)
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
    
    
    @IBAction func selectCausesListener(_ sender: Any) {
        
        let selectController = MultipleSelectionController(style: .plain)
        selectController.type = .cause
        selectController.causesList = self.causesList
        selectController.currentValue = causesTv.text
       
        self.view.endEditing(true)
        selectController.delegate = self
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(selectController, animated: true)
        }
    }
    
    
    func getCausesList(){
        
        Alamofire.request(BASE_URL + CAUSES).responseArray { (response: DataResponse<[CausesModel]>) in
            
            print(response)
            
            switch response.result {
            case .success:
                let causesList = response.result.value
                
                
                if let causesList = causesList{
                    self.causesList = causesList
                }
                
                self.removeProgressDialog()
                break
                
            case .failure(let error):
                print(error)
                
                self.removeProgressDialog()
                InKindHelper.showErrorMessageAboveNav(title: nil, body: "Unable to fetch causes list right now. Please try again later")
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
    
    
    func removeProgressDialog(){
        
        DispatchQueue.main.async {
            if self.actInd.isAnimating{
                self.actInd.stopAnimating()
                self.loadingView.removeFromSuperview()
            }
        }
    }
    
}
