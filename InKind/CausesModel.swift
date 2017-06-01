//
//  CausesModel.swift
//  InKind
//
//  Created by Rohit Singh on 05/05/17.
//  Copyright © 2017 InKind. All rights reserved.
//

import Foundation

import ObjectMapper

class CausesModel : Mappable {
    
    var description: String?
    var id: Int?
    var name: String?
    var status: String?
    
    required convenience init?(map: Map){
        self.init()
    }
    
    func mapping(map: Map) {
        description <- map["description"]
        id <- map["id"]
        name <- map["name"]
        status <- map["status"]
    }
    
}
