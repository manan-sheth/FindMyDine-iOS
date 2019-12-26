//
//  Find_My_DineTests.swift
//  Find My DineTests
//
//  Created by Manan Sheth on 13/12/19.
//  Copyright © 2019 Manan Sheth. All rights reserved.
//

import XCTest
@testable import Find_My_Dine

class Find_My_DineTests: XCTestCase {
    
    override func setUp() {
        
    }
    
    override func tearDown() {
        
    }
    
    func testConvertHexToUIColor() {
        
        let hexColor = AppUtils.hexStringToUIColor(hex: "#FFFFFF")
        let whiteColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        XCTAssert(hexColor == whiteColor, "Convert HEX to UIColor is not working as expected.")
    }
}
