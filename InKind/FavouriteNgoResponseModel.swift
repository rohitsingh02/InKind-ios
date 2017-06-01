//
//  FavouriteNgoResponseModel.swift
//  InKind
//
//  Created by Rohit Singh on 13/05/17.
//  Copyright © 2017 InKind. All rights reserved.
//

import Foundation

import ObjectMapper

class FavouriteNgoResponseModel : Mappable {
    
   
    var status: String?
    var data: String?
    var errorMsg: String?
    var errorCode: String?
 
    required convenience init?(map: Map){
        self.init()
    }
    
    func mapping(map: Map) {
        status <- map["status"]
        data <- map["data"]
        errorMsg <- map["errorMsg"]
        errorCode <- map["errorCode"]
    }
}
