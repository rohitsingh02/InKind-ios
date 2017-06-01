//
//  AppConstants.swift
//  InKind
//
//  Created by Rohit Singh on 01/05/17.
//  Copyright © 2017 InKind. All rights reserved.
//

import Foundation
import UIKit

let isUserLoggedIn = "isUserLoggedIn"
let inKindColor: UInt = 0x1FA0BA

let SCREEN_WIDTH = UIScreen.main.bounds.width
let SCREEN_HEIGHT = UIScreen.main.bounds.height
let BASE_URL = "http://52.10.211.182:8080/ngo-service"
let LOGIN_URL = "/v1/donor-management/login"
let SIGNUP_URL = "/v1/donor-management/signup"
let STATE_URL = "/v1/location-management/state-list"
let CITY_URL = "/v1/location-management/city-list-from-state"
let REMOVE_FAVOURITE = "/v1/donor-management/donor/remove/favorite"
let ADD_FAVOURITE = "/v1/donor-management/donor/add/favorite"
let CAUSES = "/v1/cause-management/causes"
let ADD_NGO = "/v1/ngo-management/ngo-add"
let NGO_DETAIL = "/v1/ngo-management/ngo-detail-id"
let DONATION_ITEMS = "/v1/ngo-management/ngo-donation-items"
let NGO_LIST = "/v1/ngo-management/ngo-list"
let NGO_LIST_CAT = "/v1/ngo-management/ngo-list-cat"
let NGO_LIST_CAT_ID = "/v1/ngo-management/ngo-list-cat-id"
let NGO_LIST_CITY_ID = "/v1/ngo-management/ngo-list-city-id"
let NGO_LIST_STATE_ID = "/v1/ngo-management/ngo-list-state-id"

let NGO_LIST_SEARCH = "/v1/ngo-management/ngo-list-search"
let DONOR_DETAILS = "/v1/donor-management/donor/details"



