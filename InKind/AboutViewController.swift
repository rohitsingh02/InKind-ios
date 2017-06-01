//
//  AboutViewController.swift
//  InKind
//
//  Created by Rohit Singh on 30/04/17.
//  Copyright © 2017 InKind. All rights reserved.
//

import UIKit



class AboutViewController: UIViewController , UITableViewDelegate,UITableViewDataSource{

    
    @IBOutlet weak var tableView: UITableView!
    
    let cellIdentifier = "aboutDetailCell"
    var titleArray = ["About", "Mission"]
    
    var ngoName = "Picture Wala"
    var ngoAbout = "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda."
    var ngoMission = "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. "
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 85
        tableView.tableFooterView = UIView()
        
        self.tableView.setNeedsLayout()
        self.tableView.layoutIfNeeded()
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! AboutDetailTableViewCell
        
        if indexPath.row == 0{
            cell.titleLabel.text = "About \(ngoName)"
            cell.descriptionLabel.text = ngoAbout
        }
        else{
            cell.titleLabel.text = "Mission"
            cell.descriptionLabel.text = ngoMission
        }
       
    
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
    

}
