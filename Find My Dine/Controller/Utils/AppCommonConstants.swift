//
//  AppCommonConstants.swift
//  Find My Dine
//
//  Created by Apple Customer on 13/12/19.
//  Copyright © 2019 Manan Sheth. All rights reserved.
//

import UIKit

struct AppCommonConstants {
    
    struct AppConstantValues {
        static let constAppDBName = "FindMyDine"
        static let constLocationChanged = "LocationChanged"
    }
}

struct APIConstants {
    
    struct APIServer {
        static let serverBaseURL = "https://developers.zomato.com/api/v2.1/"
        static let serverKey = "7743aea88c2d4f753465c610ef1cf5a8"
        static let serverTimeout = 30.0
    }
    
    struct RestaurantAPI {
        static let apiGetRestaurantList = "search"
        static let apiGetLocationList = "locations"
    }
}
