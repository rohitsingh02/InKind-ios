//
//  FavouritesViewController.swift
//  InKind
//
//  Created by Rohit Singh on 07/05/17.
//  Copyright © 2017 InKind. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper

class FavouritesViewController: UIViewController , UITableViewDelegate,UITableViewDataSource {

    let loadingView: UIView = UIView()
    let actInd: UIActivityIndicatorView = UIActivityIndicatorView()
    
    let cellIdentifier = "ngoListingCell"
    var favouritesNgo : [NgoListingModel] = []
    var ngoId = -1
    var containerView = UIView()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        InKindHelper().initErrorPage(imageName:"sad", labelText: "Sorry, No Favourite Ngo's Found",view : self.view,containerView: containerView, isCentered: true)
         containerView.isHidden = true
        
        tableView.tableFooterView = UIView()
        InKindHelper().showProgressIndicator(loadingView: loadingView, actInd: actInd, view: self.view)
        
        let rightAddCaseButtonItem:UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "reload"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(getNgos))
        
        navigationItem.rightBarButtonItem = rightAddCaseButtonItem
        getFavouriteNgos()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favouritesNgo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! NgoListingTableViewCell
        cell.ngoLogo.image =  UIImage(named:"\(favouritesNgo[indexPath.row].ngoName!)")
        
        cell.ngoNameTv.text = favouritesNgo[indexPath.row].ngoName
        cell.ngoLocationTv.text = (favouritesNgo[indexPath.row].ngoCity?.name)! + "(" + (favouritesNgo[indexPath.row].ngoState?.name)! + ")"
        cell.ngoDescriptionTv.text = favouritesNgo[indexPath.row].about
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        performSegue(withIdentifier: "favouriteNgoToDetailSegue", sender: self)
            
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "favouriteNgoToDetailSegue"{
            
            if let indexPath = tableView.indexPathForSelectedRow{
                let selectedRow = indexPath.row
                let targetController = segue.destination as! OrganizationDetailViewController
                targetController.ngoId = favouritesNgo[selectedRow].id!
                targetController.ngoName = favouritesNgo[selectedRow].ngoName!
            }
        }
    }

    
    func getNgos(){
        InKindHelper().showProgressIndicator(loadingView: loadingView, actInd: actInd, view: self.view)
        getFavouriteNgos()
    }
    
    
    func getFavouriteNgos(){
        
        
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
                   
                    self.favouritesNgo = donorDetailModel.donorFavoriteNgos!
                    
                    if self.favouritesNgo.count == 0{
                      self.tableView.separatorStyle = .none
                      self.containerView.isHidden = false
                    }
                    else{
                     self.tableView.separatorStyle = .singleLine
                     self.containerView.isHidden = true
                    }
                    
                    self.removeProgressDialog()
                    self.tableView.reloadData()
                }
                break
            case .failure(let error):
                print(error)
                self.removeProgressDialog()
                self.tableView.separatorStyle = .none
                self.containerView.isHidden = false
                InKindHelper.showErrorMessageAboveNav(title: nil, body: "Unable to fetch Favourite ngo's list.")
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 129
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if(tableView.indexPathForSelectedRow != nil){
            tableView.deselectRow(at: tableView.indexPathForSelectedRow!, animated: true)
        }
    }
    

}
