//
//  LocationListVC.swift
//  Find My Dine
//
//  Created by Manan Sheth on 16/12/19.
//  Copyright © 2019 Manan Sheth. All rights reserved.
//

import UIKit

protocol LocationSelectionDelegate: class {
    
    func selectedLocationData(selectedCity: CityData)
}

class LocationListView: UITableViewController {
    
    private var arrCities: [CityData] = [CityData]()
    var dictAllLocations = [String : [CityData]]()
    var resultSearchController = UISearchController()
    
    private var viewModel: LocationListViewModel = LocationListViewModel()
    weak var locationSelectDelegate: LocationSelectionDelegate?
    
    //MARK:- Class Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.accessibilityIdentifier = "locationListVC"
        self.title = "Search Location"
        
        viewModel.locationListdelegate = self
        
        self.tableView.tableFooterView = UIView.init()
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 75
        
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
}

//MARK:- Search Methods
extension LocationListView: UISearchResultsUpdating, LocationViewModelDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        self.arrCities.removeAll(keepingCapacity: false)
        
        if let query = searchController.searchBar.text, !query.isEmpty {
            
            if let cities = self.dictAllLocations[query] {
                self.arrCities = cities
                self.tableView.reloadData()
            }
            else {
                if query.count > 1 {
                    viewModel.fetchLocationData(searchQuery: query)
                }
            }
        }
    }
    
    func didReceiveLocationData(cities: [CityData], success: Bool, error: String?) {
        
        if success {
            self.arrCities = cities
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.tableView.reloadData()
            }
        }
        else {
            print("Error ===> \(error ?? "")")
        }
    }
}

//MARK:- Table View Methods
extension LocationListView {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrCities.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath) as! LocationCell
        let objCity = self.arrCities[indexPath.row]
        cell.lblLocation.text = objCity.title
        cell.lblCity.text = objCity.city_name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let objCity = self.arrCities[indexPath.row]
        if let delegate = self.locationSelectDelegate {
            delegate.selectedLocationData(selectedCity: objCity)
        }
        
        self.resultSearchController.dismiss(animated: true) {
            self.navigationController?.popViewController(animated: true)
        }
    }
}
