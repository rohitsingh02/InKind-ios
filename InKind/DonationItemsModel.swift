//
//  DonationItemsModel.swift
//  InKind
//
//  Created by Rohit Singh on 07/05/17.
//  Copyright © 2017 InKind. All rights reserved.
//

import Foundation

import ObjectMapper

class DonationItemsModel : Mappable {
    
    var id : Int?
    var name: String?
    var code: String?
   
    
    
    
    required convenience init?(map: Map){
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        code <- map["code"]
    }
    
}
