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
       let firstSingleton = HTZNetworkingFacade.sharedInstance
        firstSingleton.networkingManager.baseURL = "Some URL"
        let secondSingleton = HTZNetworkingFacade.sharedInstance
        XCTAssert(firstSingleton.networkingManager === secondSingleton.networkingManager, "The singleton's network managers are not equal")
    }

    func testGetRequest()
    {
        let myFacade = HTZNetworkingFacade.sharedInstance
        let expectation = expectationWithDescription("Expecting a functional GET request")

        myFacade.networkingManager.baseURL = "https://s3.amazonaws.com/f.cl.ly/items/29123p1h0n2w25282Y1R"
        myFacade.networkingManager.getDataFromEndPoint("/VehicleList.json") { (responseData) -> () in

            let responseReceived = responseData as? Dictionary<String,[AnyObject]>

            XCTAssertTrue(responseReceived?["Vehicles"] != nil)
            expectation.fulfill()
        }
        waitForExpectationsWithTimeout(100) { (error) -> Void in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
}
