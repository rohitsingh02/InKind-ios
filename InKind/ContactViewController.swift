//
//  ContactViewController.swift
//  InKind
//
//  Created by Rohit Singh on 30/04/17.
//  Copyright © 2017 InKind. All rights reserved.
//

import UIKit
import MessageUI
import SafariServices
import SwiftMessages


class ContactViewController: UIViewController , UITableViewDelegate,UITableViewDataSource,MFMailComposeViewControllerDelegate {
  
    let loadingView: UIView = UIView()
    let actInd: UIActivityIndicatorView = UIActivityIndicatorView()
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var ngoDetailModel : NgoDetailModel?
    
    let cell1Identifier = "contactCell1"
    let cell2Identifier = "contactCell2"
    var titleArray = ["Call","Integrity Check", "Email", "Visit Website","Share with a friend", "Contact Person"]
    var iconImage = ["call","integrity_check","email","visit_website","share","contact_person"]
    
    
    var mobile_no = "9990212137"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.rowHeight = 57
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       let cell = UITableViewCell()
        
        if indexPath.row == 0{
            
           let cell = tableView.dequeueReusableCell(withIdentifier: cell1Identifier, for: indexPath) as! Contact1TableViewCell
            
            if (ngoDetailModel?.acceptPickup)!{
              cell.pickUpImage.image = UIImage(named: "tick")
            }else{
              cell.pickUpImage.image = UIImage(named: "cross")
            }
            

            return cell
            
        }
        else{
            
            let cell  = tableView.dequeueReusableCell(withIdentifier: cell2Identifier, for: indexPath) as! Contact2TableViewCell
            
            cell.titleLabel.text = titleArray[indexPath.row - 1]
            cell.iconImage.image = UIImage(named: "\(iconImage[indexPath.row - 1] )")
            
            return cell
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 1{
           // call
            showCallAlertAction()
           
        }else if indexPath.row == 2{
        
            performSegue(withIdentifier: "ContactToIntegrityCheckSegue", sender: self)
            // open integrity check page
        }
        else if indexPath.row == 3{
            // open email
            sendEmail()
        }
        else if indexPath.row == 4{
            // open webpage
            
            
            let url = URL(string: String((ngoDetailModel?.website)!)!)
            
            if url != nil{
                let svc = SFSafariViewController(url: url!)
                svc.view.tintColor = UIColor(hex: "\(inKindColor)")
                self.present(svc, animated: true, completion: nil)
            }
        }
        else if indexPath.row == 5{
            // share with friend
            
            let shareText = "Hey, check out InKind. New Way to donate your InKinds. \(String((ngoDetailModel?.website!)!)!)"
            let activityViewController = UIActivityViewController(activityItems: [shareText], applicationActivities: nil)
            present(activityViewController, animated: true, completion: nil)
            // DeSelect Row
            tableView.deselectRow(at: tableView.indexPathForSelectedRow!, animated: true)
            
        }
        else if indexPath.row == 6{
            //
            
            let view: TacoDialogView = try! SwiftMessages.viewFromNib()
            view.emailLabel.text = ngoDetailModel?.admin?.name
            view.nameLabel.text = ngoDetailModel?.admin?.email
            view.contactLabel.text = String(describing: String((self.ngoDetailModel?.address?.contact1!)!))
            view.configureDropShadow()
            view.cancelAction = { SwiftMessages.hide() }
            var config = SwiftMessages.defaultConfig
            config.presentationContext = .window(windowLevel: UIWindowLevelStatusBar)
            config.duration = .forever
            config.presentationStyle = .bottom
            config.dimMode = .gray(interactive: true)
            SwiftMessages.show(config: config, view: view)
        }
       
    }
    
    
    func sendEmail() {
        
        if MFMailComposeViewController.canSendMail()  {
            
            let mailComposer = MFMailComposeViewController()
            mailComposer.mailComposeDelegate = self
            
            mailComposer.setToRecipients([""])
            mailComposer.setSubject("")
            mailComposer.setMessageBody("", isHTML: false)
            
            present(mailComposer, animated: true)
        }
        else{
            //show erroe message
            
        }
    }
    
    func mailComposeController(controller: MFMailComposeViewController,
                               didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        // Check the result or perform other tasks.
        // Dismiss the mail compose view controller.
        controller.dismiss(animated: true, completion: nil)
    }
    
    
    fileprivate func showCallAlertAction() {
        
        
        let alertController = UIAlertController(title: "\(String(describing: String((ngoDetailModel?.address?.contact1!)!)))", message: nil, preferredStyle: .actionSheet)
        
        let callAction = UIAlertAction(title: "Call", style: .default, handler: { (UIAlertAction)in
            
      //  UIApplication.shared.openURL(NSURL(string:"tel://"+"\(String(describing: String((self.ngoDetailModel?.address?.contact1!)!)))") as! URL)
            
        let tempNumber = String(describing: String((self.ngoDetailModel?.address?.contact1!)!))
         
        let phoneNumber = tempNumber.substring(from:tempNumber.index(tempNumber.endIndex, offsetBy: -10))
        let nsurl =  URL(string: "tel://\(phoneNumber)")
         
        print(phoneNumber)
            
        print(nsurl)
            
            
        UIApplication.shared.openURL(nsurl!)
        
        })
        alertController.addAction(callAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func removeProgressDialog(){
        
        DispatchQueue.main.async {
            if self.actInd.isAnimating{
                self.actInd.stopAnimating()
                self.loadingView.removeFromSuperview()
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
