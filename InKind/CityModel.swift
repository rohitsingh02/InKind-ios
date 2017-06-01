//
//  CityModel.swift
//  InKind
//
//  Created by Rohit Singh on 04/05/17.
//  Copyright © 2017 InKind. All rights reserved.
//

import Foundation
import ObjectMapper

class CityModel : Mappable {
    
    var code: String?
    var id: Int?
    var name: String?
    
    required convenience init?(map: Map){
        self.init()
    }
    
    func mapping(map: Map) {
        code <- map["code"]
        id <- map["id"]
        name <- map["name"]
    }
    
}
