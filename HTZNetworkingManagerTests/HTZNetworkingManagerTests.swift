//
//  HTZNetworkingManagerTests.swift
//  HTZNetworkingManagerTests
//
//  Created by Kemar White on 7/17/15.
//  Copyright (c) 2015 toohotz. All rights reserved.
//

import UIKit
import XCTest

class HTZNetworkingManagerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSingleton()
    {
       let firstSingleton = HTZFacade.sharedInstance
        firstSingleton.networkingManager.baseURL = "Some URL"
        let secondSingleton = HTZFacade.sharedInstance
        XCTAssert(firstSingleton.networkingManager === secondSingleton.networkingManager, "The singleton's are not equal")
    }
}
