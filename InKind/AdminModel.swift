//
//  AdminModel.swift
//  InKind
//
//  Created by Rohit Singh on 07/05/17.
//  Copyright © 2017 InKind. All rights reserved.
//

import Foundation

import ObjectMapper

class AdminModel : Mappable {
    
   // var id : Int?
    var name: String?
    var email: String?
    var designation: String?
    var profilePic: String?
    var status: String?
   
    
    
    required convenience init?(map: Map){
        self.init()
    }
    
    func mapping(map: Map) {
      //  id <- map["id"]
        name <- map["name"]
        email <- map["email"]
        designation <- map["designation"]
        profilePic <- map["profilePic"]
        status <- map["status"]
    }
    
}

