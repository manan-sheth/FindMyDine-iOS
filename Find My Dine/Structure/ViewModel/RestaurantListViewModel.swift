//
//  RestaurantListViewModel.swift
//  Find My Dine
//
//  Created by Manan Sheth on 16/12/19.
//  Copyright © 2019 Manan Sheth. All rights reserved.
//

import UIKit

protocol RestaurantViewModelDelegate: class {
    
    func didReceiveRestaurantData(restaurants: [RestaurantData], isFreshData: Bool, success: Bool, error: String?)
}

final class RestaurantListViewModel {
    
    weak var restaurantListDelegate: RestaurantViewModelDelegate?
    var isFreshDataRequest = true
    
    let networking = APINetworking()
    let imageCache = NSCache<NSString, UIImage>()
    
    //Fetch New Restaurant Data
    func fetchNewRestaurantData(params: String, isFreshDataRequired: Bool) {
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        self.isFreshDataRequest = isFreshDataRequired
        
        networking.performNetworkRequest(reqEndpoint: APIConstants.restaurantsList(reqParams: params), type: AllRestaurantsData.self) { [weak self](status, response, error) in
            
            var arrRestaurantsData = [RestaurantData]()
            var strErrorMessage = ""
            
            if status {
                
                if let arrRestaurants = response?.restaurants, arrRestaurants.count > 0 {
                    
                    for restaurantData in arrRestaurants {
                        let restaurant = restaurantData.restaurant
                        arrRestaurantsData.append(restaurant)
                    }
                }
                else {
                    strErrorMessage = "No more restaurants are available."
                    print("No Restaurants found.")
                }
            }
            else {
                strErrorMessage = error?.localizedDescription ?? ""
                print(error?.localizedDescription ?? "")
            }
            
            //Delegate
            if let delegate = self?.restaurantListDelegate {
                delegate.didReceiveRestaurantData(restaurants: arrRestaurantsData, isFreshData: self?.isFreshDataRequest ?? true, success: status, error: strErrorMessage)
            }
        }
    }
    
    //Fetch Local Restaurant Data
    func fetchLocalRestaurantData() {
        
        var status = false
        var arrRestaurantsData = [RestaurantData]()
        var strErrorMessage = ""
        
        let defaults = UserDefaults.standard
        if let cacheRestaurants = defaults.object(forKey: "Cache_Restaurants") as? Data {
            
            let decoder = JSONDecoder()
            if let restaurants = try? decoder.decode([RestaurantData].self, from: cacheRestaurants) {
                
                for restaurant in restaurants {
                    arrRestaurantsData.append(restaurant)
                }
                status = true
            }
            else {
                strErrorMessage = "No more resturants are available."
            }
        }
        else {
            strErrorMessage = "No more local resturants are available."
        }
        
        //Delegate
        if let delegate = self.restaurantListDelegate {
            delegate.didReceiveRestaurantData(restaurants: arrRestaurantsData, isFreshData: self.isFreshDataRequest, success: status, error: strErrorMessage)
        }
    }
    
    //Store them into Defaults
    func storeRestaurantDataInLocalCache(resturants: [RestaurantData]) {
        
        let encoder = JSONEncoder()
        if let encodedValue = try? encoder.encode(resturants) {
            let defaults = UserDefaults.standard
            defaults.set(encodedValue, forKey: "Cache_Restaurants")
            defaults.synchronize()
        }
    }
}
