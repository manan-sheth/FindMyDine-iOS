//
//  RestaurantListVC.swift
//  Find My Dine
//
//  Created by Apple Customer on 13/12/19.
//  Copyright © 2019 Manan Sheth. All rights reserved.
//

import UIKit
import RealmSwift
import SDWebImage

let batchCount = 50

class RestaurantListVC: UITableViewController {
    
    let realm = try! Realm()
    var arrRestaurantData = [RestaurantData]()
    
    var currentRecord = 1
    var lastLatValue = 21.17
    var lastLngValue = 72.83
    
    //MARK:- Class Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.accessibilityIdentifier = "restaurantListVC"
        
        self.tableView.tableFooterView = UIView.init()
        
        self.tableView.refreshControl?.attributedTitle = NSAttributedString(string: "Fetching new restaurants...")
        self.tableView.refreshControl?.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        
        //Load Local Data
        self.loadLocalRestaurantData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(self.fetchDataFromLocation), name: NSNotification.Name(rawValue: AppCommonConstants.AppConstantValues.constLocationChanged), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: AppCommonConstants.AppConstantValues.constLocationChanged), object: nil)
        super.viewWillDisappear(animated)
    }
    
    //Load Local Restaurant Data
    func loadLocalRestaurantData() {
        
        if let restaurantData = realm.fetchObjects(type: RestaurantData.self, predicate: nil, order: nil) {
            
            for restaurant in restaurantData {
                self.arrRestaurantData.append(restaurant.safecopy)
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.tableView.reloadData()
            }
        }
    }
    
    //Fetch Data From Location
    @objc func fetchDataFromLocation(_ notification: NSNotification) {
        
        if let locationInfo = notification.userInfo?["user_location"] as? [String : Double] {
            
            self.lastLatValue = locationInfo["lat"] ?? 21.17
            self.lastLngValue = locationInfo["lng"] ?? 72.83
            
            let reqParams = String(format: "lat=%.3f&lon=%.3f&entity_type=city&count=50", self.lastLatValue, self.lastLngValue)
            self.fetchNewRestaurantData(params: reqParams)
        }
    }
    
    //Fetch New Restaurant Data
    func fetchNewRestaurantData(params: String) {
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        APIParser.sharedInstance.generateWeatherRequest(reqURL: APIConstants.RestaurantAPI.apiGetRestaurantList, reqHTTPMethod: .get, reqParams: params) { (status, data, message, error) in
            
            if let dictRestaurantData = data as? NSDictionary {
                
                if let arrAllRestaurants = dictRestaurantData.value(forKey: "restaurants") as? [NSDictionary], arrAllRestaurants.count > 0 {
                    
                    if let result = self.realm.fetchObjects(type: RestaurantData.self, predicate: nil, order: nil) {
                        
                        self.realm.updateObject {
                            self.realm.delete(result)
                        }
                    }
                    self.arrRestaurantData.removeAll()
                    
                    //New Data
                    for objDict in arrAllRestaurants {
                        
                        if let dictRestaurant = objDict.value(forKey: "restaurant") as? NSDictionary {
                            
                            //print("===============================")
                            //print(dictRestaurant)
                            //print("===============================")
                            
                            let restaurant = RestaurantData.init(dictionary: dictRestaurant)
                            self.realm.addObject(object: restaurant, update: true)
                            
                            self.arrRestaurantData.append(restaurant.safecopy)
                        }
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                        self.tableView.reloadData()
                        self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
                    })
                }
            }
            else {
                if let err = error {
                    print(err.localizedDescription)
                }
            }
            
            self.tableView.refreshControl?.endRefreshing()
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
    
    @objc func refresh(sender: AnyObject) {
        
        let reqParams = String(format: "lat=%.3f&lon=%.3f&entity_type=city&count=50", self.lastLatValue, self.lastLngValue)
        self.fetchNewRestaurantData(params: reqParams)
    }
}

//MARK: Navigation Bar Button Methods
extension RestaurantListVC: LocationSelectionDelegate {
    
    @IBAction func clickToFindMyNearBy() {
        
        let reqParams = String(format: "lat=%.3f&lon=%.3f&entity_type=city&count=50", self.lastLatValue, self.lastLngValue)
        self.fetchNewRestaurantData(params: reqParams)
    }
    
    @IBAction func clickToSearchCity() {
        
        let locationVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "idLocationListVC") as! LocationListVC
        locationVC.locationDelegate = self
        self.navigationController?.pushViewController(locationVC, animated: true)
    }
    
    func selectedLocationData(dictCity: NSDictionary) {
        
        if let cityId = dictCity["city_id"] {
            
            let entityId = "\(cityId)"
            let reqParams = String(format: "entity_id=%@&entity_type=city&count=50", entityId)
            self.fetchNewRestaurantData(params: reqParams)
        }
    }
}

//MARK: Table View Methods
extension RestaurantListVC {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrRestaurantData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantCell", for: indexPath) as! RestaurantCell
        let objRestaurant = self.arrRestaurantData[indexPath.row]
        cell.lblName.text = objRestaurant.name
        cell.lblAddress.text = objRestaurant.location?.address ?? "City"
        cell.lblCost.text = "Average cost for 2 persons: \(objRestaurant.currency) \(objRestaurant.average_cost_for_two)"
        cell.lblVotes.text = "\(objRestaurant.user_rating?.votes ?? "0.0") Votes"
        cell.lblRating.text = "\(objRestaurant.user_rating?.aggregate_rating ?? "0.0") / 5.0"
        
        if let rateValue = objRestaurant.user_rating?.rating_color, !rateValue.isEmpty {
            let hexColor = AppUtils.hexStringToUIColor(hex: "#\(rateValue)")
            cell.lblRating.backgroundColor = hexColor
            cell.lblRating.layer.cornerRadius = 5.0
            cell.lblRating.clipsToBounds = true
        }
        
        cell.imgImage.sd_setImage(with: URL(string: objRestaurant.featured_image), placeholderImage: UIImage(named:  "ImgPlaceholder"), options: .continueInBackground) { (image, error, type, url) in
            
            if let img = image {
                cell.imgImage.image = img
            }
        }
        return cell
    }
}
