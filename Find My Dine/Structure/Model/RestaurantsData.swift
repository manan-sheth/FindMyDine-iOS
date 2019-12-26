//
//  RestaurantsData.swift
//  Find My Dine
//
//  Created by Manan Sheth on 16/12/19.
//  Copyright © 2019 Manan Sheth. All rights reserved.
//

import UIKit

struct LocationData: Codable {
    
    var address: String?
    var city: String?
    var locality_verbose: String?
}

struct UserRatingData: Codable {
    
    var aggregate_rating: Any
    var rating_text: String
    var rating_color: String
    var votes: Any
}

struct RestaurantData: Codable {
    
    var id: String
    var name: String?
    var location: LocationData?
    var cuisines: String?
    var average_cost_for_two: Int?
    var currency: String?
    var thumb: String?
    var user_rating: UserRatingData?
    var featured_image: String?
    var phone_numbers: String?
}

struct RestaurantsMainData: Codable {
    
    var restaurant: RestaurantData
}

struct AllRestaurantsData: Codable {
    
    var restaurants: [RestaurantsMainData]
    var results_found: Int
}

extension UserRatingData {
    
    enum CodingKeys: String, CodingKey {
        case aggregate_rating
        case rating_text
        case rating_color
        case votes
    }
    
    func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode("\(aggregate_rating)", forKey: .aggregate_rating)
        try container.encode(rating_text, forKey: .rating_text)
        try container.encode(rating_color, forKey: .rating_color)
        try container.encode("\(votes)", forKey: .votes)
    }
    
    init(from decoder: Decoder) throws {
        
        do {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            if let stringProperty = try? container.decode(String.self, forKey: .aggregate_rating) {
                aggregate_rating = stringProperty
            }
            else if let intProperty = try? container.decode(Int.self, forKey: .aggregate_rating) {
                aggregate_rating = intProperty
            }
            else {
                throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: container.codingPath, debugDescription: "Not a JSON"))
            }
            
            if let stringProperty = try? container.decode(String.self, forKey: .rating_text) {
                rating_text = stringProperty
            }
            else {
                throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: container.codingPath, debugDescription: "Not a JSON"))
            }
            
            if let stringProperty = try? container.decode(String.self, forKey: .rating_color) {
                rating_color = stringProperty
            }
            else {
                throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: container.codingPath, debugDescription: "Not a JSON"))
            }
            
            if let stringProperty = try? container.decode(String.self, forKey: .votes) {
                votes = stringProperty
            }
            else if let intProperty = try? container.decode(Int.self, forKey: .votes) {
                votes = intProperty
            }
            else {
                throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: container.codingPath, debugDescription: "Not a JSON"))
            }
        }
    }
}
