//
//  RealmData.swift
//  Find My Dine
//
//  Created by Apple Customer on 13/12/19.
//  Copyright © 2019 Manan Sheth. All rights reserved.
//

import UIKit
import RealmSwift

let appRealmVersion = 1

class RealmData: NSObject {
    
    class func realmDefaultConfig(realmName: String) {
        
        var config = Realm.Configuration()
        config.fileURL = config.fileURL?.deletingLastPathComponent().appendingPathComponent("\(realmName).realm")
        print("Realm URL : \(config.fileURL!)")
        config.deleteRealmIfMigrationNeeded = false
        config.schemaVersion = UInt64(appRealmVersion)
        Realm.Configuration.defaultConfiguration = config
    }
    
    class func initNewRealm(configuration: Realm.Configuration? = nil) -> Realm {
        
        if configuration == nil {
            
            let realmObj = try! Realm()
            return realmObj
        }
        else {
            let realmObj = try! Realm(configuration: configuration!)
            return realmObj
        }
    }
}
