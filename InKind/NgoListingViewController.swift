//
//  NgoListingViewController.swift
//  InKind
//
//  Created by Rohit Singh on 06/05/17.
//  Copyright © 2017 InKind. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper


class NgoListingViewController: UIViewController , UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate, SelectControllerDelegate {

    var searchController: UISearchController!
    let loadingView: UIView = UIView()
    let actInd: UIActivityIndicatorView = UIActivityIndicatorView()
    
     var containerView = UIView()
    let cellIdentifier = "ngoListingCell"
    var ngoListing : [NgoListingModel] = []
    var ngoId = -1
    var sortedNgoListing : [NgoListingModel] = []
    var stateList : [StateModel] = []
    var causeList : [CausesModel] = []
    var ngoName = ""
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        
        let view: UIView = searchController.searchBar.subviews[0] as UIView
        for subView: UIView in view.subviews {
            if let textView = subView as? UITextField {
                textView.tintColor = UIColor(hex: "\(inKindColor)")
            }
        }
        
        InKindHelper().initErrorPage(imageName:"sad", labelText: "Sorry, No ngo Found for this cause",view : self.view,containerView: containerView, isCentered: true)
        containerView.isHidden = true
        
        getCausesList()
        getStateList()
        
        let rightAddCaseButtonItem:UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "funnel"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(showFilteredList))
        
        navigationItem.rightBarButtonItem = rightAddCaseButtonItem
        
        
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        tableView.tableFooterView = UIView()
        
        InKindHelper().showProgressIndicator(loadingView: loadingView, actInd: actInd, view: self.view)
        getNgoList()
        
    }


    func showFilteredList(){
    
            let alertController = UIAlertController(title: "Select", message: nil, preferredStyle: .actionSheet)
            let fixedPriceAction = UIAlertAction(title: "Select Cause", style: .default, handler: { (action) -> Void in
                
                let selectController = SelectTableViewController(style: .plain)
                selectController.type = .cause
                selectController.causeList = self.causeList
                selectController.currentValue = ""
                self.view.endEditing(true)
                selectController.delegate = self
                DispatchQueue.main.async {
                    self.navigationController?.pushViewController(selectController, animated: true)
                }
            })
            
            alertController.addAction(fixedPriceAction)
            
            let negotiableAction = UIAlertAction(title: "Select State", style: .default, handler: { (action) -> Void in
                
                let selectController = SelectTableViewController(style: .plain)
                selectController.type = .state
                selectController.stateList = self.stateList
                selectController.currentValue = ""
                self.view.endEditing(true)
                selectController.delegate = self
                DispatchQueue.main.async {
                    self.navigationController?.pushViewController(selectController, animated: true)
                }
                
            })
            alertController.addAction(negotiableAction)
        
            present(alertController, animated: true, completion: nil)
    
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchController.isActive && searchController.searchBar.text != "" {
            return sortedNgoListing.count
        }
        
        return ngoListing.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! NgoListingTableViewCell
        
        if searchController.isActive && searchController.searchBar.text != "" {
            cell.ngoLogo.image = UIImage(named:"image\(indexPath.row)")
            
            self.ngoId = sortedNgoListing[indexPath.row].id!
            cell.ngoNameTv.text = sortedNgoListing[indexPath.row].ngoName
            cell.ngoLocationTv.text = "\((sortedNgoListing[indexPath.row].ngoCity?.name)!) " + "(" + (sortedNgoListing[indexPath.row].ngoState?.name)! + ")"
            cell.ngoDescriptionTv.text = sortedNgoListing[indexPath.row].about
        
        }
        else{
            cell.ngoLogo.image = UIImage(named:"\(ngoListing[indexPath.row].ngoName!)")
            
            cell.ngoNameTv.text = ngoListing[indexPath.row].ngoName
            cell.ngoLocationTv.text = "\((ngoListing[indexPath.row].ngoCity?.name)!) " + "(" + (ngoListing[indexPath.row].ngoState?.name)! + ")"
            cell.ngoDescriptionTv.text = ngoListing[indexPath.row].about
        }
       
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.ngoId = ngoListing[indexPath.row].id!
        self.ngoName = ngoListing[indexPath.row].ngoName!
        
        performSegue(withIdentifier: "ngoListingToDetailSegue", sender: self)
    
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ngoListingToDetailSegue"{
    
            if let indexPath = tableView.indexPathForSelectedRow{
                let selectedRow = indexPath.row
                let targetController = segue.destination as! OrganizationDetailViewController
                targetController.ngoId = ngoListing[selectedRow].id!
                targetController.ngoName = ngoListing[selectedRow].ngoName!
            }
        }
    }
    
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        
        searchController.searchBar.tintColor = UIColor.white
        sortedNgoListing = ngoListing.filter {
            oneNgoListing in
            
                let ngoName = oneNgoListing.ngoName!
                //let about = oneNgoListing.about!
                let ngoState = (oneNgoListing.ngoState?.name)!
                let ngoCity = (oneNgoListing.ngoCity?.name)!
            
                
                let searchString = "\(ngoName) \(ngoState) \(ngoCity)"
            
                print(searchString.lowercased())
                print(searchText.lowercased())
            
            
                return searchString.lowercased().contains(searchText.lowercased())
        
        }
        
        print(sortedNgoListing)

        tableView.reloadData()
    }
    
   
    func getNgoList(){
        
        Alamofire.request(BASE_URL + NGO_LIST).responseArray { (response: DataResponse<[NgoListingModel]>) in
            
            switch response.result {
            case .success:
                let ngoList = response.result.value
                
                if let ngoList = ngoList{
                    self.ngoListing = ngoList
                }
                
                DispatchQueue.main.async {
                 self.tableView.reloadData()
                 self.tableView.separatorStyle = .singleLine
                 self.removeProgressDialog()
                }
                
                
                break
            case .failure(let error):
                print(error)
                
                self.removeProgressDialog()
                InKindHelper.showErrorMessageAboveNav(title: nil , body: "Unable to fetch ngo list right now. Please try again later")
                break
                
            }
        
        }
    }
    
    func getNgoListStateWise(id: String){
        
        let headers = ["Content-Type" : "application/json",
                       "Accept" : "application/json"]
        
        let params = ["id" : id]
        
        Alamofire.request(BASE_URL + NGO_LIST_STATE_ID,method:.post, parameters: params,encoding: JSONEncoding.default, headers: headers).responseArray { (response: DataResponse<[NgoListingModel]>) in
            
            switch response.result {
            case .success:
                let ngoList = response.result.value
                
                if let ngoList = ngoList{
                    self.ngoListing = ngoList
                }
                
                
                DispatchQueue.main.async {
                    
                    if self.ngoListing.count == 0{
                        let subView =  self.containerView.subviews[1] as! UILabel;
                        subView.text = "Sorry, No ngo found for this state"
                        self.tableView.separatorStyle = .none
                        self.containerView.isHidden = false
                        
                    }
                    else{
                        self.tableView.separatorStyle = .singleLine
                        self.containerView.isHidden = true
                    }
                    
                    self.tableView.reloadData()
                    self.removeProgressDialog()
                }
                
                
                break
            case .failure(let error):
                print(error)
                
                self.removeProgressDialog()
                InKindHelper.showErrorMessageAboveNav(title: nil, body: "Unable to fetch ngo list right now. Please try again later")
                break
                
            }
            
        }
    }
    
    func getNgoListCauseWise(id : String){
        
        let headers = ["Content-Type" : "application/json",
                       "Accept" : "application/json"]
        
        let params = ["id" : id]
        
        Alamofire.request(BASE_URL + NGO_LIST_CAT_ID,method:.post, parameters: params,encoding: JSONEncoding.default, headers: headers).responseArray { (response: DataResponse<[NgoListingModel]>) in
            
            switch response.result {
            case .success:
                let ngoList = response.result.value
                
                if let ngoList = ngoList{
                    self.ngoListing = ngoList
                }
                
                DispatchQueue.main.async {
                    
                    if self.ngoListing.count == 0{
                        let subView =  self.containerView.subviews[1] as! UILabel;
                        subView.text = "Sorry, No ngo found for this cause"
                        self.tableView.separatorStyle = .none
                        self.containerView.isHidden = false
                    }
                    else{
                        self.tableView.separatorStyle = .singleLine
                        self.containerView.isHidden = true
                    }

                    self.tableView.reloadData()
                    self.removeProgressDialog()
                }
                
                
                break
            case .failure(let error):
                print(error)

                self.removeProgressDialog()
                InKindHelper.showErrorMessageAboveNav(title: nil, body: "Unable to fetch ngo list right now. Please try again later")
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
    
    
    
    func didSelectValueInController(_ text:String, index:Int, type:SelectControllerType) {
        if(type == .state){
            
            self.ngoListing = []
            self.tableView.separatorStyle = .none
            self.tableView.reloadData()
            
            InKindHelper().showProgressIndicator(loadingView: loadingView, actInd: actInd, view: self.view)
            print("\(index)")
            getNgoListStateWise(id: "\(index)")
        }
        else if(type == .cause){
            
            self.ngoListing = []
            self.tableView.separatorStyle = .none
            self.tableView.reloadData()
            
           InKindHelper().showProgressIndicator(loadingView: loadingView, actInd: actInd, view: self.view)
           getNgoListCauseWise(id: "\(index)")
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
    
    func getCausesList(){
        
        Alamofire.request(BASE_URL + CAUSES).responseArray { (response: DataResponse<[CausesModel]>) in
            
            print(response)
            
            switch response.result {
            case .success:
                let causesList = response.result.value
                
                
                if let causesList = causesList{
                    self.causeList = causesList
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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if(tableView.indexPathForSelectedRow != nil){
            tableView.deselectRow(at: tableView.indexPathForSelectedRow!, animated: true)
        }
    }
    
}

extension NgoListingViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}

