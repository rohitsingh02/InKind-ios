//
//  SignupResponseModel.swift
//  InKind
//
//  Created by Rohit Singh on 04/05/17.
//  Copyright © 2017 InKind. All rights reserved.
//

import Foundation
import ObjectMapper

class SignupResponseModel : Mappable {
    
    var status: String?
    var errorMsg: String?
    var donorId: Int?
    
    required convenience init?(map: Map){
        self.init()
    }
    
    func mapping(map: Map) {
        status <- map["status"]
        errorMsg <- map["errorMsg"]
        donorId <- map["donorId"]
    }
    
}
