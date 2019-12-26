//
//  LocationListViewModel.swift
//  Find My Dine
//
//  Created by Manan Sheth on 16/12/19.
//  Copyright © 2019 Manan Sheth. All rights reserved.
//

import UIKit

protocol LocationViewModelDelegate: class {
    
    func didReceiveLocationData(cities: [CityData], success: Bool, error: String?)
}

final class LocationListViewModel {
    
    weak var locationListdelegate: LocationViewModelDelegate?
    
    //MARK: Fetch New Location Data
    func fetchLocationData(searchQuery: String) {
        
        let params = String(format: "query=%@&count=10", searchQuery)
        
        let networking = APINetworking()
        networking.performNetworkRequest(reqEndpoint: APIConstants.citiesList(reqParams: params), type: LocationSuggestionsData.self) { [weak self](status, response, error) in
            
            var arrCitiesData = [CityData]()
            var strErrorMessage = ""
            
            if status {
                
                if let arrLocations = response?.location_suggestions {
                    
                    for city in arrLocations {
                        arrCitiesData.append(city)
                    }
                }
                else {
                    strErrorMessage = "No more cities are available."
                    print("No Location found.")
                }
            }
            else {
                strErrorMessage = error?.localizedDescription ?? ""
                print(error?.localizedDescription ?? "")
            }
            
            if let delegate = self?.locationListdelegate {
                delegate.didReceiveLocationData(cities: arrCitiesData, success: status, error: strErrorMessage)
            }
        }
    }
}
