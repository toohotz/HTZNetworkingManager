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

        myFacade.networkingManager.baseURL = "https://api.github.com/users/mralexgray/repos"
        myFacade.networkingManager.getDataFromEndPoint(nil) { (responseData) -> () in

            XCTAssertFalse(responseData is NSError, "The response received is nil.")
            expectation.fulfill()
        }
        waitForExpectationsWithTimeout(100) { (error) -> Void in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
}
