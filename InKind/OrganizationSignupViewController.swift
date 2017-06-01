//
//  OrganizationSignupViewController.swift
//  InKind
//
//  Created by Rohit Singh on 03/05/17.
//  Copyright © 2017 InKind. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper

class OrganizationSignupViewController: UIViewController, SelectControllerDelegate {

    var addNgoModel : AddNgoModel?
    let loadingView: UIView = UIView()
    let actInd: UIActivityIndicatorView = UIActivityIndicatorView()
    
    
    @IBOutlet var organizationNameField: DesignableTextField!
    
    
    @IBOutlet var pickupSwitch: UISwitch!
    
    
    @IBOutlet var websiteLink: DesignableTextField!
    
    
    @IBOutlet var emailField: DesignableTextField!
    
    
    
    @IBOutlet weak var streetField: DesignableTextField!
    
    
    @IBOutlet var registrationNumberField: DesignableTextField!
    
    
    @IBOutlet var stateTextField: UITextField!
    
    
    @IBOutlet var cityTextField: UITextField!
    
    var doesAcceptPickup = false
    
    var stateList : [StateModel] = []
    var cityList : [CityModel] = []
    var selectedStateName = ""
    var selectedStateId = 0
    var selectedCityName = ""
    var selectedCityId = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        InKindHelper().showProgressIndicator(loadingView: loadingView, actInd: actInd, view: self.view)
        getStateList()

    }
    
    
    @IBAction func saveAndNextClickListener(_ sender: Any) {
        
        
        if checkForEmptyFields(text: organizationNameField.text!)  && checkForEmptyFields(text: selectedStateName) && checkForEmptyFields(text: selectedCityName) && checkForEmptyFields(text: websiteLink.text!) && checkForEmptyFields(text: registrationNumberField.text!) && checkForEmptyFields(text: emailField.text!) && checkForEmptyFields(text: streetField.text!){
            
            self.view.endEditing(true)
            
            guard (emailField.text?.isEmail)! else{
                
                InKindHelper.showErrorMessageAboveNav(title: nil, body: "Uhoh. Please try again with a valid email ID.")
                return
            }
            
            
            if pickupSwitch.isOn{
                doesAcceptPickup = true
            }
            else{
              doesAcceptPickup = false
            }
            
            setAddNgoModel()
            performSegue(withIdentifier: "OrganizationToAccountSegue", sender: self)
            
        }
        else{
            InKindHelper.showErrorMessageAboveNav(title: nil, body: "Some fields are empty. Please try again.")
        }
        
    }

    func checkForEmptyFields(text : String) -> Bool{
        
        guard !text.isEmpty else{
            return false
        }
        return true
    }
    
    
    //MARK: SelectControllerDelegate
    
    func didSelectValueInController(_ text:String, index:Int, type:SelectControllerType) {
        
        if(type == .state){
            stateTextField.text = text
            selectedStateName = text
            selectedStateId = index
            
            InKindHelper().showProgressIndicator(loadingView: loadingView, actInd: actInd, view: self.view)
            
            self.getCityList(id: "\(selectedStateId)")
        } else if(type == .city){
            cityTextField.text = text
            selectedCityName = text
            selectedCityId = index
        }
    }
    
    
    
    @IBAction func cityButtonListener(_ sender: Any) {
        
        let selectController = SelectTableViewController(style: .plain)
        selectController.type = .city
        selectController.cityList = cityList
        selectController.currentValue = self.cityTextField.text!
        print(cityList)
        self.view.endEditing(true)
        selectController.delegate = self
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(selectController, animated: true)
        }
        
    }
    
    
    @IBAction func stateButtonListener(_ sender: Any) {
       
        let selectController = SelectTableViewController(style: .plain)
        selectController.type = .state
        selectController.stateList = self.stateList
        selectController.currentValue = self.stateTextField.text!
        
        self.view.endEditing(true)
        selectController.delegate = self
        
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(selectController, animated: true)
        }
    }
    
    
    
    func getStateList(){
        
        Alamofire.request(BASE_URL + STATE_URL).responseArray { (response: DataResponse<[StateModel]>) in
            
            switch response.result {
            case .success:
                 let stateList = response.result.value
                 
                 if let stateList = stateList{
                    self.stateList = stateList
                 }
                 
                 self.removeProgressDialog()
                 
                break
            case .failure(let error):
                print(error)
                self.removeProgressDialog()
                InKindHelper.showErrorMessageAboveNav(title: nil, body: "Unable to fetch state list right now. Please try again later")
                break
            }
        }
    }
    
    
    func removeProgressDialog(){
        
        DispatchQueue.main.async {
            if self.actInd.isAnimating{
                self.actInd.stopAnimating()
                self.loadingView.removeFromSuperview()
            }
        }
    }
    
    func getCityList(id: String){
        
        let headers = ["Content-Type" : "application/json",
                       "Accept" : "application/json"]
        
        let params = ["id" : "\(id)"]
        
        
        
        Alamofire.request(BASE_URL + CITY_URL,method:.post, parameters: params,encoding: JSONEncoding.default, headers: headers).responseArray { (response: DataResponse<[CityModel]>) in
            
            switch response.result {
            case .success:
                let cityList = response.result.value
                
                if let cityList = cityList{
                   self.cityList = cityList
                }
                
                self.removeProgressDialog()
                
                break
            case .failure(let error):
                print(error)
                self.removeProgressDialog()
                InKindHelper.showErrorMessageAboveNav(title: nil, body: "Unable to fetch state list right now. Please try again later")
                break
                
            }
        }
    }
    
    
    
    func setAddNgoModel(){
    
     addNgoModel = AddNgoModel()
     print(doesAcceptPickup)
     addNgoModel?.acceptPickup = doesAcceptPickup
     addNgoModel?.address = setAddressModel()
     addNgoModel?.email = emailField.text
     addNgoModel?.ngoName = organizationNameField.text
     addNgoModel?.registrationNumber = registrationNumberField.text
     addNgoModel?.registeredAddress = setAddressModel()
     addNgoModel?.website = websiteLink.text
     addNgoModel?.fax = randomString(length: 8)
     addNgoModel?.score = 0
     addNgoModel?.ngoCity = setCityModel()
     addNgoModel?.ngoState = setStateModel()
     addNgoModel?.ngoCountry = setCountryModel()
     addNgoModel?.status = "ACTIVE"
     addNgoModel?.profile = ""
    }
    
    func setAddressModel() -> AddressModel{
    
        let addressModel = AddressModel()
        addressModel.line1 = streetField.text
        addressModel.line2 = "line 2"
        addressModel.landmark = "kailash colony"
        addressModel.contact1 = "contact1"
        addressModel.contact2 = "contact2"
        addressModel.state = setStateModel()
        addressModel.city = setCityModel()
        addressModel.country = setCountryModel()
        addressModel.status = "ACTIVE"
    
        return addressModel
    }
    
    func setCityModel() -> CityModel{
        let cityModel = CityModel()
        cityModel.id = selectedCityId
        return cityModel
    }
    
    func setStateModel() -> StateModel{
        let stateModel = StateModel()
        stateModel.id = selectedStateId
        return stateModel
    }
    
    func setCountryModel() -> CountryModel{
        let countryModel = CountryModel()
        countryModel.id = 1
        return countryModel
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "OrganizationToAccountSegue" {
            let destinationVc = segue.destination as! AccountManagerViewController
            destinationVc.addNgoModel = self.addNgoModel
        }
        
    }
    
    
    func randomString(length: Int) -> String {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }
    
    
    @IBAction func cancelButtonListener(_ sender: Any) {
        self.view.endEditing(false)
        self.dismiss(animated: true, completion:nil)
    }
    
}
