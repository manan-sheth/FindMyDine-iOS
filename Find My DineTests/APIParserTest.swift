//
//  APIParserTest.swift
//  Find My DineTests
//
//  Created by Apple Customer on 15/12/19.
//  Copyright © 2019 Manan Sheth. All rights reserved.
//

import XCTest

class APIParserTest: XCTestCase {
    
    var restaurnatId = ""
    
    override func setUp() {
        
    }
    
    override func tearDown() {
        
    }
    
    func testFetchWeatherAPI() {
        
        let params = String(format: "lat=%.3f&lon=%.3f&entity_type=city&count=50", 21.17, 72.83)
        
        APIParser.sharedInstance.generateWeatherRequest(reqURL: APIConstants.RestaurantAPI.apiGetRestaurantList, reqHTTPMethod: .get, reqParams: params) { (status, data, message, error) in
            
            XCTAssertTrue((error == nil), "Fetch restaurant details API calling is not working as expected. Error is occuring.")
            XCTAssertTrue(data is NSDictionary, "Fetch restaurant details API calling is not working as expected.")
        }
    }
    
    func testDictionaryWithPropertiesOfObject() {
        
        let id = "123"
        let name = "Surat"
        let dict = NSDictionary(dictionary: ["id": id, "name" : name])
        
        self.mapWithDictionary(dictionary: dict)
        XCTAssertTrue(restaurnatId == id, "Convert dictionary object to Weather object method is not working as expected.")
    }
    
    func mapWithDictionary(dictionary: NSDictionary) {
        
        if dictionary["id"] != nil && !(dictionary["id"] is NSNull) {
            restaurnatId = "\(dictionary["id"]!)"
        }
    }
}
