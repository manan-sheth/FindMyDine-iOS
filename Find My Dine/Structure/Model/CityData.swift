//
//  CityData.swift
//  Find My Dine
//
//  Created by Manan Sheth on 16/12/19.
//  Copyright © 2019 Manan Sheth. All rights reserved.
//

import UIKit

struct LocationSuggestionsData: Codable {
    
    var location_suggestions: [CityData]
}

struct CityData: Codable {
    
    var city_id: Int
    var title: String
    var city_name: String
}
