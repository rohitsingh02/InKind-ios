//
//  NgoListingModel.swift
//  InKind
//
//  Created by Rohit Singh on 05/05/17.
//  Copyright © 2017 InKind. All rights reserved.
//

import Foundation

import ObjectMapper
class NgoListingModel : Mappable {
    
    var id: Int?
    var ngoName: String?
    var about: String?
    var status: String?
    var ngoState : StateModel?
    var ngoCity : CityModel?


    required convenience init?(map: Map){
      self.init()
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        ngoName <- map["ngoName"]
        about <- map["about"]
        status <- map["status"]
        ngoState <- map["ngoState"]
        ngoCity <- map["ngoCity"]
    }
    
}


