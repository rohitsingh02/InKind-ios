//
//  ViewController.swift
//  InKind
//
//  Created by Rohit Singh on 29/04/17.
//  Copyright © 2017 InKind. All rights reserved.
//

import UIKit

class LandingPageViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
   
    }
    
    override func viewWillAppear(_ animated: Bool) {
      
        guard UserDefaults.standard.value(forKey: isUserLoggedIn) != nil else{
            
            self.view.isHidden = false
            return
        }
        
        if (UserDefaults.standard.value(forKey: isUserLoggedIn) as? Bool)!{
          self.view.isHidden = true
        }
         else {
            self.view.isHidden = false
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        
        guard UserDefaults.standard.value(forKey: isUserLoggedIn) != nil else{
            
            return
        }
        
        if (UserDefaults.standard.value(forKey: isUserLoggedIn) as? Bool)!{
          performSegue(withIdentifier: "landingPageToHomeSegue", sender: self)
        }
    }
  
}

