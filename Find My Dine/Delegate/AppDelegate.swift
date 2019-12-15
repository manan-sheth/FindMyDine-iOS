//
//  AppDelegate.swift
//  Find My Dine
//
//  Created by Apple Customer on 13/12/19.
//  Copyright © 2019 Manan Sheth. All rights reserved.
//

import UIKit
import CoreTelephony
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    //Location
    let locationManager = CLLocationManager()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        //Default Realm
        RealmData.realmDefaultConfig(realmName: AppCommonConstants.AppConstantValues.constAppDBName)
        
        //Location
        self.checkUserLocationPermission()
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

extension UIApplication {
    
    class func appInstance() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        
        return controller
    }
}

//MARK:- Location Services
extension AppDelegate: CLLocationManagerDelegate {
    
    func checkUserLocationPermission() {
        
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            locationManager.delegate = self
            return
            
        case .restricted, .denied:
            let actionCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            let actionSettings = UIAlertAction(title: "Settings", style: .default) { (action) -> Void in
                
                UIApplication.shared.open(URL.init(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
            }
            
            let alertVC = UIAlertController.init(title: "Location Permission Required", message: "To fetch your nearby restaurants, Kindly allow us to access your location.", preferredStyle: .alert)
            alertVC.addAction(actionCancel)
            alertVC.addAction(actionSettings)
            UIApplication.topViewController()?.present(alertVC, animated: true, completion: nil)
            break
            
        case .authorizedAlways, .authorizedWhenInUse:
            self.getLocationForNearbyRestaurants()
            break
        }
        
        return
    }
    
    //TODO: Get User Location
    func getLocationForNearbyRestaurants() {
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    //TODO: Location Delegates
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            self.getLocationForNearbyRestaurants()
            break
            
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        manager.stopUpdatingLocation()
        manager.delegate = nil
        
        var latValue = 21.17
        var lngValue = 72.83
        
        if let lastLocation = manager.location {
            
            let locValue = lastLocation.coordinate
            latValue = locValue.latitude
            lngValue = locValue.longitude
            
        }
        
        var dictLocation = [String : Double]()
        dictLocation["lat"] = latValue
        dictLocation["lng"] = lngValue
        
        //Location Changed
        let locationInfo: [String : [String : Double]] = ["user_location" : dictLocation]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: AppCommonConstants.AppConstantValues.constLocationChanged), object: nil, userInfo: locationInfo)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        print("Fail to get Location \(error)")
        
        //Location Changed
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: AppCommonConstants.AppConstantValues.constLocationChanged), object: nil, userInfo: nil)
    }
}
