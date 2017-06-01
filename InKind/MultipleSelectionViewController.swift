//
//  MultipleSelectionViewController.swift
//  InKind
//
//  Created by Rohit Singh on 07/05/17.
//  Copyright © 2017 InKind. All rights reserved.
//

import UIKit

public enum MultipleSelectionControllerType : Int {
    
    case none
    case cause
    case other
}

protocol MultipleSelectionControllerDelegate: class{
    func selectedCausesArray(selectedArray: [CausesModel])
}

class MultipleSelectionController: UITableViewController {
   
    var causesList: [CausesModel] = []
    var selectedCauseList: [CausesModel] = []
    var currentValue: String = ""
    var type: MultipleSelectionControllerType = .none
    var currentCell : UITableViewCell? = nil
    weak var delegate: MultipleSelectionControllerDelegate! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpNotificationBarButtonItem()
        
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        
         if(type == .cause){
            self.title = "Select Causes"
            self.tableView.allowsMultipleSelection = true
        } else {
            self.title = ""
        }
    }

    
    func setUpNotificationBarButtonItem() {
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneTapped))

    }
    
   
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        
        if type == .cause{
            return causesList.count
        }
       
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "SelectCell")
        
        if(cell == nil){
            cell = UITableViewCell(style: .default, reuseIdentifier:"SelectCell")
            cell?.textLabel?.font = UIFont.systemFont(ofSize: 16.0)
        }
        
        var rowValue = ""
        
        if type == .cause{
            rowValue = causesList[indexPath.row].name!
        }
        
        // Configure the cell...
        cell?.textLabel!.text = rowValue
        
        if (cell?.isSelected)!
        {
            cell?.isSelected = false
            if cell?.accessoryType == UITableViewCellAccessoryType.none
            {
                cell?.accessoryType = UITableViewCellAccessoryType.checkmark
            }
            else
            {
                cell?.accessoryType = UITableViewCellAccessoryType.none
            }
        }
        cell?.textLabel?.lineBreakMode = .byWordWrapping;
        
        return cell!
    }

    
    func doneTapped(){
        
        let selected_indexPaths = tableView.indexPathsForSelectedRows
        for indexPath in selected_indexPaths!{
//            let cell = tableView.cellForRow(at: indexPath)
//            values.append((cell?.textLabel?.text)!)
            causesList[indexPath.row].status = "ACTIVE"
            selectedCauseList.append(causesList[indexPath.row])
        }
        
        delegate?.selectedCausesArray(selectedArray: selectedCauseList)
        self.navigationController?.popViewController(animated: true)
    }
    

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let cell = tableView.cellForRow(at: indexPath)
        if cell!.isSelected
        {
            cell!.isSelected = false
            if cell!.accessoryType == UITableViewCellAccessoryType.none
            {
                cell!.accessoryType = UITableViewCellAccessoryType.checkmark
            }
            else
            {
                cell!.accessoryType = UITableViewCellAccessoryType.none
            }
        }
    }
    
}


