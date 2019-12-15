//
//  RestaurantData.swift
//  Find My Dine
//
//  Created by Apple Customer on 13/12/19.
//  Copyright © 2019 Manan Sheth. All rights reserved.
//

import UIKit
import RealmSwift

class RestaurantLocationData: Object {
    
    @objc dynamic var restaurant_id: String = ""
    @objc dynamic var address: String = ""
    @objc dynamic var city: String = ""
    @objc dynamic var locality_verbose: String = ""
    
    var _safecopy: RestaurantLocationData?
    
    override class func primaryKey() -> String {
        return "restaurant_id"
    }
    
    override class func ignoredProperties() -> [String] {
        return ["_safecopy"]
    }
    
    convenience init(resId: String, dictionary: NSDictionary) {
        self.init()
        self.restaurant_id = resId
        mapWithDictionary(dictionary: dictionary)
    }
    
    func mapWithDictionary(dictionary: NSDictionary) {
        
        if dictionary["address"] != nil && !(dictionary["address"] is NSNull) {
            address = dictionary["address"] as! String
        }
        
        if dictionary["city"] != nil && !(dictionary["city"] is NSNull) {
            city = dictionary["city"] as! String
        }
        
        if dictionary["locality_verbose"] != nil && !(dictionary["locality_verbose"] is NSNull) {
            locality_verbose = dictionary["locality_verbose"] as! String
        }
    }
    
    var safecopy: RestaurantLocationData {
        
        if _safecopy == nil {
            _safecopy = RestaurantLocationData(value: self)
        }
        return _safecopy!
    }
}

class UserRatingData: Object {
    
    @objc dynamic var restaurant_id: String = ""
    @objc dynamic var aggregate_rating: String = ""
    @objc dynamic var rating_text: String = ""
    @objc dynamic var rating_color: String = ""
    @objc dynamic var votes: String = ""
    
    var _safecopy: UserRatingData?
    
    override class func primaryKey() -> String {
        return "restaurant_id"
    }
    
    override class func ignoredProperties() -> [String] {
        return ["_safecopy"]
    }
    
    convenience init(resId: String, dictionary: NSDictionary) {
        self.init()
        self.restaurant_id = resId
        mapWithDictionary(dictionary: dictionary)
    }
    
    func mapWithDictionary(dictionary: NSDictionary) {
        
        if dictionary["aggregate_rating"] != nil && !(dictionary["aggregate_rating"] is NSNull) {
            aggregate_rating = dictionary["aggregate_rating"] as! String
        }
        
        if dictionary["rating_text"] != nil && !(dictionary["rating_text"] is NSNull) {
            rating_text = dictionary["rating_text"] as! String
        }
        
        if dictionary["rating_color"] != nil && !(dictionary["rating_color"] is NSNull) {
            rating_color = dictionary["rating_color"] as! String
        }
        
        if dictionary["votes"] != nil && !(dictionary["votes"] is NSNull) {
            votes = "\(dictionary["votes"] ?? 0)"
        }
    }
    
    var safecopy: UserRatingData {
        
        if _safecopy == nil {
            _safecopy = UserRatingData(value: self)
        }
        return _safecopy!
    }
}

class RestaurantData: Object {
    
    @objc dynamic var restaurant_id: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var location: RestaurantLocationData?
    @objc dynamic var cuisines: String = ""
    @objc dynamic var timings: String = ""
    @objc dynamic var average_cost_for_two: Int = 0
    @objc dynamic var currency: String = ""
    @objc dynamic var thumb: String = ""
    @objc dynamic var user_rating: UserRatingData?
    @objc dynamic var featured_image: String = ""
    @objc dynamic var phone_numbers: String = ""
    
    var _safecopy: RestaurantData?
    
    override class func primaryKey() -> String {
        return "restaurant_id"
    }
    
    override class func ignoredProperties() -> [String] {
        return ["_safecopy"]
    }
    
    convenience init(dictionary: NSDictionary) {
        self.init()
        mapWithDictionary(dictionary: dictionary)
    }
    
    func mapWithDictionary(dictionary: NSDictionary) {
        
        if dictionary["id"] != nil && !(dictionary["id"] is NSNull) {
            restaurant_id = dictionary["id"] as! String
        }
        
        if dictionary["name"] != nil && !(dictionary["name"] is NSNull) {
            name = dictionary["name"] as! String
        }
        
        if dictionary["location"] != nil && !(dictionary["location"] is NSNull) {
            location = RestaurantLocationData.init(resId: self.restaurant_id, dictionary: (dictionary["location"] as! NSDictionary))
        }
        
        if dictionary["cuisines"] != nil && !(dictionary["cuisines"] is NSNull) {
            cuisines = dictionary["cuisines"] as! String
        }
        
        if dictionary["timings"] != nil && !(dictionary["timings"] is NSNull) {
            timings = dictionary["timings"] as! String
        }
        
        if dictionary["average_cost_for_two"] != nil && !(dictionary["average_cost_for_two"] is NSNull) {
            average_cost_for_two = dictionary["average_cost_for_two"] as! Int
        }
        
        if dictionary["currency"] != nil && !(dictionary["currency"] is NSNull) {
            currency = dictionary["currency"] as! String
        }
        
        if dictionary["thumb"] != nil && !(dictionary["thumb"] is NSNull) {
            thumb = dictionary["thumb"] as! String
        }
        
        if dictionary["user_rating"] != nil && !(dictionary["user_rating"] is NSNull) {
            user_rating = UserRatingData.init(resId: self.restaurant_id, dictionary: (dictionary["user_rating"] as! NSDictionary))
        }
        
        if dictionary["featured_image"] != nil && !(dictionary["featured_image"] is NSNull) {
            featured_image = dictionary["featured_image"] as! String
        }
        
        if dictionary["phone_numbers"] != nil && !(dictionary["phone_numbers"] is NSNull) {
            phone_numbers = dictionary["phone_numbers"] as! String
        }
    }
    
    var safecopy: RestaurantData {
        
        if _safecopy == nil {
            _safecopy = RestaurantData(value: self)
            _safecopy?.user_rating = user_rating?.safecopy
            _safecopy?.location = location?.safecopy
        }
        return _safecopy!
    }
}
