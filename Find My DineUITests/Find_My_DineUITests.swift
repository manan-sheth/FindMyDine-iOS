//
//  Find_My_DineUITests.swift
//  Find My DineUITests
//
//  Created by Manan Sheth on 13/12/19.
//  Copyright © 2019 Manan Sheth. All rights reserved.
//

import XCTest

class Find_My_DineUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        
        continueAfterFailure = false
        
        app = XCUIApplication()
        app.launchArguments.append("--uitesting")
    }
    
    override func tearDown() {
        
    }
    
    func testAllowLocationPermission() {
        
        addUIInterruptionMonitor(withDescription: "Allow us to access your location to fetch restaurants data.") { (alert) -> Bool in
            alert.buttons["Always Allow"].tap()
            return true
        }
    }
    
    func testGetAllLocationList() {
        
        app.launch()
        XCTAssertTrue(app.isDisplayingRestaurantList)
        
        app.buttons["Search"].tap()
        XCTAssertTrue(app.isDisplayingLocationList, "You should be on Location List Page")
        
        app.searchFields.element.tap()
        sleep(1)
        app.searchFields.element.typeText("Surat")
        sleep(2)
        
        app.tables["locationListVC"].children(matching: .cell).element(boundBy: 0).tap()
        XCTAssertTrue(app.isDisplayingRestaurantList, "You should be on Restaurant List Page")
        sleep(1)
    }
    
    func testGetRefreshList() {
        
        app.launch()
        XCTAssertTrue(app.isDisplayingRestaurantList)
        
        app.buttons["Refresh"].tap()
        XCTAssertTrue(app.isDisplayingRestaurantList, "You should be on Restaurant List Page")
    }
}

extension XCUIApplication {
    
    var isDisplayingRestaurantList: Bool {
        return otherElements.tables["restaurantListVC"].exists
    }
    
    var isDisplayingLocationList: Bool {
        return otherElements.tables["locationListVC"].exists
    }
}

