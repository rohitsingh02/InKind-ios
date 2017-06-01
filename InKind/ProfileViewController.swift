//
//  ProfileViewController.swift
//  InKind
//
//  Created by Rohit Singh on 07/05/17.
//  Copyright © 2017 InKind. All rights reserved.
//

import UIKit
import SCLAlertView
import Alamofire
import AlamofireObjectMapper

class ProfileViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {

    let cellIdentifier = "logoutCell"
    var donorDetail: DonorDetailModel?
    let loadingView: UIView = UIView()
    let actInd: UIActivityIndicatorView = UIActivityIndicatorView()
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var numDonationLabel: UILabel!
    @IBOutlet weak var favouriteNgoLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        InKindHelper().showProgressIndicator(loadingView: loadingView, actInd: actInd, view: self.view)
        self.tableView.tableFooterView = UIView()
        getDonorDetails()

    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! LogoutTableViewCell
       
        cell.titleLabel.text = "Logout"
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0{
            
           logoutAction()
            
        }
    }
    
    
    func getDonorDetails(){
        
        
        let headers = ["Content-Type" : "application/json",
                       "Accept" : "application/json"]
        let donorId =  UserDefaults.standard.value(forKey: "DonorId") as? Int
        
        let params = ["id" : "\(String(describing: donorId!))"]
        
        Alamofire.request(BASE_URL + DONOR_DETAILS,method:.post, parameters: params,encoding: JSONEncoding.default, headers: headers).responseObject { (response: DataResponse<DonorDetailModel>) in
            
            print(response)
            print(response.result)
            
            switch response.result {
            case .success:
                
                let donorDetailModel = response.result.value
                
                if let donorDetailModel = donorDetailModel{
                    
                    self.donorDetail = donorDetailModel
                    self.emailLabel.text = self.donorDetail?.email
                    self.nameLabel.text = self.donorDetail?.name
                    
                    let noFav = self.donorDetail?.donorFavoriteNgos!.count as? Int
                    
                    self.favouriteNgoLabel.text =  "\(String(describing: noFav!)) Favourites, "
                    
                    let noDonations = self.donorDetail?.donationCount
                    
                    if noDonations == nil{
                     self.numDonationLabel.text = "0 Donations"
                    }
                    else{
                     self.numDonationLabel.text = self.donorDetail!.donationCount
                    }
                    
                    self.removeProgressDialog()
                    self.tableView.reloadData()
                }
                break
            case .failure(let error):
                print(error)
                self.removeProgressDialog()
            
                InKindHelper.showErrorMessageAboveNav(title: nil, body: "Unable to fetch donor details")
                break
                
            }
        }
    }
    
    
    func logoutAction() {
        
        let appearance = SCLAlertView.SCLAppearance(
            kDefaultShadowOpacity:  0.7, kCircleTopPosition: 0.0, kCircleBackgroundTopPosition: 6.0, kCircleHeight: 60.0, kCircleIconHeight: 50.0, kTitleTop: 30.0, kTitleHeight: 29.0, kWindowWidth: 240.0, kWindowHeight: 178.0, kTextHeight: 90.0, kTextFieldHeight: 45.0, kTextViewdHeight: 80.0, kButtonHeight: 45.0, kTitleFont: UIFont.systemFont(ofSize: 19, weight: UIFontWeightHeavy), kTextFont: UIFont.init(name: "Helvetica Neue", size: 16)!, kButtonFont: UIFont.systemFont(ofSize: 14,weight: UIFontWeightBold), showCloseButton: false, showCircularIcon: true, shouldAutoDismiss: true, contentViewCornerRadius: 5.0, fieldCornerRadius: 3.0, buttonCornerRadius: 3.0, hideWhenBackgroundViewIsTapped: true, circleBackgroundColor: UIColor.white, contentViewColor: UIColor(rgb: 0xFFFFFF), contentViewBorderColor: UIColor(rgb: 0xCCCCCC), titleColor: UIColor(rgb: 0x666666), dynamicAnimatorActive: false, disableTapGesture: false
        )
        let alertView = SCLAlertView(appearance: appearance)
        let alertViewIcon = UIImage(named: "logout")
        // Add Button with Duration Status and custom Colors
        alertView.addButton("YES, LOGOUT", backgroundColor: UIColor(rgb: 0xef5b5b), textColor: UIColor.white) {
            print("Duration Button tapped")
            self.userLogout()
        }
        
        alertView.addButton("CANCEL", backgroundColor: UIColor(rgb: 0x23b674), textColor: UIColor.white) {
        }
        
        alertView.showCustom("LOGOUT", subTitle: "Are you sure you want to logout?", color: UIColor.white, icon: alertViewIcon!)
        
    }
    
    func userLogout() {
       // do postlogout cleanup
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: isUserLoggedIn)
        defaults.removeObject(forKey: "DonorId")
                
        performSegue(withIdentifier: "logoutSegue", sender: self)

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
