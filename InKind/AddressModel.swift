//
//  AddressModel.swift
//  InKind
//
//  Created by Rohit Singh on 07/05/17.
//  Copyright © 2017 InKind. All rights reserved.
//

import Foundation
import ObjectMapper

class AddressModel : Mappable {
    
    var id : Int?
    var line1: String?
    var line2: String?
    var landmark: String?
    var contact1: String?
    var contact2: String?
    var state : StateModel?
    var city : CityModel?
    var country : CountryModel?
    var status:  String?
    
    
    required convenience init?(map: Map){
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        line1 <- map["line1"]
        line2 <- map["line2"]
        landmark <- map["landmark"]
        contact1 <- map["contact1"]
        contact2 <- map["contact2"]
        state <- map["state"]
        city <- map["city"]
        country <- map["country"]
        status <- map["status"]
    }
    
}

