//
//  Realm+Helper.swift
//  Find My Dine
//
//  Created by Apple Customer on 13/12/19.
//  Copyright © 2019 Manan Sheth. All rights reserved.
//

import UIKit
import RealmSwift

extension Realm {
    
    private func safeTransaction(withBlock block: @escaping () -> Void) {
        
        if !isInWriteTransaction {
            beginWrite()
        }
        
        block()
        
        if isInWriteTransaction {
            do {
                try commitWrite()
            }
            catch {
                print(error.localizedDescription)
            }
        }
    }
    
    //NSPredicate(format: "featuretype > 0")
    //[SortDescriptor(keyPath: "Author", ascending: true), SortDescriptor(keyPath: "Title", ascending: true)
    func fetchObjects<T: Object>(type: T.Type, predicate: NSPredicate?, order: [SortDescriptor]?) -> Results<T>? {
        
        var results = objects(type)
        
        if predicate != nil {
            results = results.filter(predicate!)
        }
        if order != nil {
            results = results.sorted(by: order!)
        }
        return results
    }
    
    func addObject(object: Object?, update: Bool? = false) {
        
        safeTransaction {
            if object != nil {
                self.add(object!, update: update! ? .all : .error)
            }
        }
    }
    
    func updateObject(updateBlock: @escaping () -> ()) {
        
        safeTransaction {
            updateBlock()
        }
    }
}
