//
//  HomeViewController.swift
//  InKind
//
//  Created by Rohit Singh on 30/04/17.
//  Copyright © 2017 InKind. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper

class HomeViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    
    let loadingView: UIView = UIView()
    let actInd: UIActivityIndicatorView = UIActivityIndicatorView()
    
    
    let cellIdentifier = "homeCell"
    let titlesArray = ["See List of Organizations registered with InKind","Donate to any cause from the comfort of your house.","Find an ngo near your house.","Refer an organization.","Pickup from your own home."]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        getFavouriteNgos()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if(tableView.indexPathForSelectedRow != nil){
            tableView.deselectRow(at: tableView.indexPathForSelectedRow!, animated: true)
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! HomeTableViewCell
        cell.backgroundImage.image = UIImage(named:"image\(indexPath.row)")
        cell.titleLabel.text = titlesArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0{
            
            performSegue(withIdentifier: "listingSegue", sender: self)
            
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
                    
                    for var i in (0..<(donorDetailModel.donorFavoriteNgos?.count)!)
                    {
                        
                        Singleton.favouritesArray.append(donorDetailModel.donorFavoriteNgos![i].id!)
                   
                    }
                }
                break
            case .failure(let error):
                print(error)
               
                break
                
            }
        }
    }
    
    
}
