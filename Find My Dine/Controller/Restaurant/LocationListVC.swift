//
//  LocationListVC.swift
//  Find My Dine
//
//  Created by Apple Customer on 13/12/19.
//  Copyright © 2019 Manan Sheth. All rights reserved.
//

import UIKit

protocol LocationSelectionDelegate {
    func selectedLocationData(dictCity: NSDictionary)
}

class LocationListVC: UITableViewController, UISearchResultsUpdating {
    
    var arrLocationData = [NSDictionary]()
    var dictAllLocations = [String : [NSDictionary]]()
    var resultSearchController = UISearchController()
    
    var locationDelegate: LocationSelectionDelegate?
    
    //MARK:- Class Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.accessibilityIdentifier = "locationListVC"
        
        self.title = "Search Location"
        
        resultSearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.searchBar.placeholder = "Enter your city"
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.sizeToFit()
            controller.searchBar.accessibilityIdentifier = "LocationSearch"
            
            self.tableView.tableHeaderView = controller.searchBar
            return controller
        })()
        
        self.tableView.reloadData()
    }
    
    //MARK: Search Delegate Update Method
    func updateSearchResults(for searchController: UISearchController) {
        
        self.arrLocationData.removeAll(keepingCapacity: false)
        
        if let query = searchController.searchBar.text, !query.isEmpty {
            
            if let locations = self.dictAllLocations[query] {
                self.arrLocationData = locations
                self.tableView.reloadData()
            }
            else {
                if query.count > 1 {
                    self.fetchLocationData(searchQuery: query)
                }
            }
        }
    }
    
    //MARK: Fetch New Location Data
    func fetchLocationData(searchQuery: String) {
        
        let params = String(format: "query=%@&count=10", searchQuery)
        
        APIParser.sharedInstance.generateWeatherRequest(reqURL: APIConstants.RestaurantAPI.apiGetLocationList, reqHTTPMethod: .get, reqParams: params) { (status, data, message, error) in
            
            if let dictLocationData = data as? NSDictionary {
                
                if let arrAllLocations = dictLocationData.value(forKey: "location_suggestions") as? [NSDictionary] {
                    
                    self.arrLocationData.removeAll()
                    
                    for objDict in arrAllLocations {
                        self.arrLocationData.append(objDict)
                    }
                    
                    self.dictAllLocations[searchQuery] = self.arrLocationData
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                    self.tableView.reloadData()
                })
            }
            else {
                if let err = error {
                    print("Error: ", err.localizedDescription)
                }
            }
        }
    }
}

//MARK:- Table View Methods
extension LocationListVC {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrLocationData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath) as! LocationCell
        let dictLocation = self.arrLocationData[indexPath.row]
        cell.lblLocation.text = "\(dictLocation.value(forKey: "title") ?? "")"
        cell.lblCity.text = "\(dictLocation.value(forKey: "city_name") ?? "")"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let dictLocation = self.arrLocationData[indexPath.row]
        if let delegate = self.locationDelegate {
            delegate.selectedLocationData(dictCity: dictLocation)
        }
        
        self.resultSearchController.dismiss(animated: true) {
            self.navigationController?.popViewController(animated: true)
        }
    }
}
