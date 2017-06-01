//
//  SelectTableViewController.swift
//  Provakil
//
//  Created by Poonia on 9/22/16.
//  Copyright © 2016 Provakil Technologies, LLP. All rights reserved.
//

import UIKit

public enum SelectControllerType : Int {
    case none
    case state
    case city
    case cause
    case other
}

protocol SelectControllerDelegate: class{
    func didSelectValueInController(_ text:String, index:Int, type:SelectControllerType)
}

class SelectTableViewController: UITableViewController {
    
    var searchController: UISearchController!
    var dataSource: [String] = []
    
    var stateList : [StateModel] = []
    var cityList : [CityModel] = []
    var causeList : [CausesModel] = []
    
    var selectedStateIndex = -1
    var selectedCityIndex = -1
    

    var filterdataSource: [String] = []
    var currentValue: String = ""
    var type: SelectControllerType = .none
    var currentCell : UITableViewCell? = nil
    var othersText = ""
    weak var delegate: SelectControllerDelegate! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
       
        if(type == .state){
            self.title = "Select State"
        } else if(type == .city){
            self.title = "Select City"
        } else if(type == .state){
            self.title = "Select Causes"
        } else {
            self.title = ""
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return filterdataSource.count
        }
        
        if type == .state{
         return stateList.count
        }
        
        if type == .city{
         return cityList.count
        }
        
        if type == .cause{
        
         return causeList.count
        }
        
       
        return dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "SelectCell")
        
        if(cell == nil){
            cell = UITableViewCell(style: .default, reuseIdentifier:"SelectCell")
            cell?.textLabel?.font = UIFont.systemFont(ofSize: 16.0)
        }
        
        var rowValue = ""
        if searchController.isActive && searchController.searchBar.text != "" {
            rowValue = filterdataSource[indexPath.row]
        } else {
            if type == .state{
                rowValue = stateList[indexPath.row].name!
            }
            else if type == .city{
             rowValue = cityList[indexPath.row].name!
            }
            
            else if type == .cause{
              rowValue = causeList[indexPath.row].name!
            }
        }
        
        cell!.textLabel?.text = rowValue
        cell?.textLabel?.numberOfLines = 0;
        cell?.textLabel?.lineBreakMode = .byWordWrapping;
        
        
        if(rowValue == currentValue){
            cell?.accessoryType = .checkmark
        }else {
            cell!.accessoryType = .none
        }
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var selectedValue : String = ""
        var selectedDataSourceIndex = 0
        if searchController.isActive && searchController.searchBar.text != "" {
            selectedValue = filterdataSource[indexPath.row]
            selectedDataSourceIndex = dataSource.index(of: filterdataSource[indexPath.row])!
        } else {
            
            if type == .state{
                selectedValue = stateList[indexPath.row].name!
                selectedDataSourceIndex = stateList[indexPath.row].id!
            }
            else if type == .city{
                selectedValue = cityList[indexPath.row].name!
                selectedDataSourceIndex = cityList[indexPath.row].id!
            }
            
            else if type == .cause{
            
              selectedValue = causeList[indexPath.row].name!
              selectedDataSourceIndex = causeList[indexPath.row].id!
            }
            
        }
        
       delegate?.didSelectValueInController(selectedValue, index: selectedDataSourceIndex, type: type)
       self.navigationController?.popViewController(animated: true)
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filterdataSource = dataSource.filter { dataf in
            return dataf.lowercased().contains(searchText.lowercased())
        }
        tableView.reloadData()
    }
}

extension SelectTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
