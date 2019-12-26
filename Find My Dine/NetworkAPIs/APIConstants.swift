//
//  APIConstants.swift
//  Find My Dine
//
//  Created by Manan Sheth on 19/12/19.
//  Copyright © 2019 Manan Sheth. All rights reserved.
//

import UIKit

struct APIServerConstants {
    
    static let serverBaseURL = URL(string: "https://developers.zomato.com/api/v2.1/")!
    static let serverKey = "7743aea88c2d4f753465c610ef1cf5a8"
    static let serverTimeout = 30.0
}

protocol Endpoint {
    
    var path: String { get }
    var reqType: String { get }
}

enum APIConstants {
    
    case restaurantsList(reqParams: String)
    case citiesList(reqParams: String)
}

extension APIConstants: Endpoint {
    
    var path: String {
        
        switch self {
        case .restaurantsList(let params):
            return "/search?\(params)"
            
        case .citiesList(let params):
            return "/locations?\(params)"
        }
    }
    
    var reqType: String {
        
        switch self {
        case .restaurantsList( _), .citiesList( _):
            return "GET"
        }
    }
}
