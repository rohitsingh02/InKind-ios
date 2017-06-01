//
//  NgoDetailModel.swift
//  InKind
//
//  Created by Rohit Singh on 08/05/17.
//  Copyright © 2017 InKind. All rights reserved.
//

import Foundation
import ObjectMapper

class NgoDetailModel : Mappable {
    
    var about: String?
    var acceptPickup: Bool?
    var address: AddressModel?
    var admin: AdminModel?
    var categoriesSupported: [CausesModel]?
    var email: String?
    var fax: String?
    var id: Int?
    var mission: String?
    var ngoCity : CityModel?
    var ngoState : StateModel?
    var ngoCountry : CountryModel?
    var ngoName: String?
    var profile : String?
    var registeredAddress : AddressModel?
    var registrationNumber: String?
    var score: Int?
    var status: String?
    var website: String?
    
    
    
    
    required convenience init?(map: Map){
        self.init()
    }
    
    func mapping(map: Map) {
        about <- map["about"]
        acceptPickup <- map["acceptPickup"]
        address <- map["address"]
        admin <- map["admin"]
        categoriesSupported <- map["categoriesSupported"]
        id <- map["id"]
        email <- map["email"]
        fax <- map["fax"]
        mission <- map["mission"]
        ngoCity <- map["ngoCity"]
        ngoState <- map["ngoState"]
        ngoCountry <- map["ngoCountry"]
        ngoName <- map["ngoName"]
        profile <- map["profile"]
        registrationNumber <- map["registrationNumber"]
        registeredAddress <- map["registeredAddress"]
        score <- map["score"]
        status <- map["status"]
        website <- map["website"]
    }
}
