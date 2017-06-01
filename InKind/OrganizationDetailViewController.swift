//
//  OrganizationDetailViewController.swift
//  InKind
//
//  Created by Rohit Singh on 30/04/17.
//  Copyright © 2017 InKind. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import AlamofireObjectMapper

class OrganizationDetailViewController:UIViewController , UITableViewDelegate,UITableViewDataSource{

    let loadingView: UIView = UIView()
    let actInd: UIActivityIndicatorView = UIActivityIndicatorView()
    
    var rightAddCaseButtonItem:UIBarButtonItem?
    
    @IBOutlet weak var favouriteImage: UIImageView!
    
    @IBOutlet weak var ngoBannerImage: UIImageView!
    
    @IBOutlet weak var ngoLogoImage: UIImageView!
    
    var ngoName = ""
    var ngoDetailModel : NgoDetailModel?
   
    let contentArray = ["About", "Needs", "Contact"]
    
    @IBOutlet weak var tableView: UITableView!
    
    let cellIdentifier = "ngoDetailItemsCell"
    
    var isFavourite = false
    var ngoId = -1
    
    override func viewDidLoad() {
        // change selected bar color
    
        super.viewDidLoad()
        self.tableView.isScrollEnabled = false
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.tableFooterView = UIView()
        
        
        ngoLogoImage.image = UIImage(named: "\(ngoName)")
        InKindHelper().showProgressIndicator(loadingView: loadingView, actInd: actInd, view: self.view)
        getNgoDetail()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if(tableView.indexPathForSelectedRow != nil){
            tableView.deselectRow(at: tableView.indexPathForSelectedRow!, animated: true)
        }
        
        
        if Singleton.favouritesArray.contains(ngoId){
          favouriteImage.image = UIImage(named: "favourite_filled")
          isFavourite = true
        }
        else{
         favouriteImage.image = UIImage(named: "favourite_empty")
            isFavourite = false
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contentArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        cell.accessoryType = .disclosureIndicator
        let order = contentArray[indexPath.row]
        cell.textLabel?.font = UIFont.init(name: "SF-UI-Text-Regular", size: 16.0)
        cell.textLabel?.text = order
     
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
               performSegue(withIdentifier: "ngoDetailToAboutSegue", sender: self)
            break
            
        case 1:
               performSegue(withIdentifier: "ngoDetailToNeedsSegue", sender: self)
            break
            
        case 2:
               performSegue(withIdentifier: "ngoDetailToContactSegue", sender: self)
            break
        default:
            break
        }
    }
  
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let indexPath: IndexPath = self.tableView.indexPathForSelectedRow!
       
        
        let content = contentArray[indexPath.row]
        
        if content == "About" {
             let contentlVC = segue.destination as! AboutViewController
            
            contentlVC.ngoName = (self.ngoDetailModel?.ngoName)!
            contentlVC.ngoAbout = (self.ngoDetailModel?.about)!
            contentlVC.ngoMission = (self.ngoDetailModel?.mission)!
            
        }
        
        if content == "Contact" {
             let contentlVC = segue.destination as! ContactViewController
            contentlVC.ngoDetailModel  = self.ngoDetailModel
        }
    }
    
    func getNgoDetail(){
        
        let headers = ["Content-Type" : "application/json",
                       "Accept" : "application/json"]
        
        print(ngoId)
        let params = ["id" : ngoId] as [String : Any]
        
        print(params)
        Alamofire.request(BASE_URL + NGO_DETAIL,method:.post, parameters: params,encoding: JSONEncoding.default,headers: headers).responseObject { (response: DataResponse<NgoDetailModel>) in
            
            
            switch response.result {
            case .success:
                
                let ngoDetailModel = response.result.value
                if let ngoDetailModel = ngoDetailModel{
                    guard ngoDetailModel.id != nil else{
                        InKindHelper.showErrorMessageAboveNav(title: nil, body: "Invalid Response")
                        return
                    }
                    
                    self.ngoDetailModel = ngoDetailModel
                    print(ngoDetailModel.toJSON())
                    self.removeProgressDialog()
                }
                break
            case .failure(let error):
                print(error)
                self.removeProgressDialog()
                InKindHelper.showErrorMessageBelowNav(title: nil, body: "Unable to getNgo Detail right now. Please try again after some time.")
                break
            }
        }
    }
    
    @IBAction func markNgoFavourite(_ sender: Any) {
   
        if isFavourite{
          unDoneAsFavourite()
        }
        else{
         markNgoFavourite()
        }
    }
    
    func markNgoFavourite(){
        
        favouriteImage.image = UIImage(named: "favourite_filled")
        
        let headers = ["Content-Type" : "application/json",
                       "Accept" : "application/json"]
        
        let donorId =  UserDefaults.standard.value(forKey: "DonorId") as? Int
        
        
        let params = ["donorId" : donorId,"ngoId": ngoId] as [String : Any]
        
        print(params)
        Alamofire.request(BASE_URL + ADD_FAVOURITE,method:.post, parameters: params,encoding: JSONEncoding.default,headers: headers).responseObject { (response: DataResponse<FavouriteNgoResponseModel>) in
            
            
            switch response.result {
            case .success:
                
                let favouriteNgoResponseModel = response.result.value
                if let favouriteNgoResponseModel = favouriteNgoResponseModel{
                
                    if favouriteNgoResponseModel.status == "SUCCESS"{
                        self.isFavourite = true
                        Singleton.favouritesArray.append(self.ngoId)
                        InKindHelper.showSuccessMessage(title: nil, body: "Added to favourite.")
                    }
                   
                }
                break
            case .failure(let error):
                print(error)
                self.removeProgressDialog()
                InKindHelper.showErrorMessageBelowNav(title: nil, body: "Unable to mark favourite.")
                break
            }
        }
    }
    
   
    func unDoneAsFavourite(){
    
    favouriteImage.image = UIImage(named: "favourite_empty")
        
        let headers = ["Content-Type" : "application/json",
                       "Accept" : "application/json"]
        
        let donorId =  UserDefaults.standard.value(forKey: "DonorId") as? Int
        
        
        let params = ["donorId" : donorId,"ngoId": ngoId] as [String : Any]
        
        
        print(params)
        Alamofire.request(BASE_URL + REMOVE_FAVOURITE,method:.post, parameters: params,encoding: JSONEncoding.default,headers: headers).responseObject { (response: DataResponse<FavouriteNgoResponseModel>) in
            
            
            switch response.result {
            case .success:
                
                let favouriteNgoResponseModel = response.result.value
                if let favouriteNgoResponseModel = favouriteNgoResponseModel{
                    
                    if favouriteNgoResponseModel.status == "FAILURE"{
                    
                        self.isFavourite = false
                    let index = Singleton.favouritesArray.index(of: self.ngoId)
                        
                    Singleton.favouritesArray.remove(at: index!)
                      InKindHelper.showSuccessMessage(title: nil, body: "Removed from favourites.")
                    
                    }
                }
                break
            case .failure(let error):
                print(error)
                self.removeProgressDialog()
                InKindHelper.showErrorMessageBelowNav(title: nil, body: "Unable to unmark favourite.")
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
    
    
    

}
