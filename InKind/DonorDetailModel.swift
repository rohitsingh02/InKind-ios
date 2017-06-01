//
//  DonorDetailModel.swift
//  InKind
//
//  Created by Rohit Singh on 11/05/17.
//  Copyright © 2017 InKind. All rights reserved.
//

import Foundation

import ObjectMapper

class DonorDetailModel : Mappable {
    
    var id: Int?
    var name: String?
    var email: String?
    var password: String?
    var address: AddressModel?
    var score: Int?
    var donationCount: String?
    var donorFavoriteNgos: [NgoListingModel]? = []

    
    required convenience init?(map: Map){
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        email <- map["email"]
        password <- map["password"]
        address <- map["address"]
        score <- map["score"]
        donationCount <- map["donationCount"]
        donorFavoriteNgos <- map["donorFavoriteNgos"]
    }
}

