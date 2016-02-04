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

            switch responseData {
            case .Success(let validResponse):
                print("Valid response received. \(validResponse)")
            case .Failure(let NetworkingError.ResponseError(errorDescription)):
                XCTAssert(false, "The GET request failed. - \(errorDescription)")
            }
            expectation.fulfill()
        }
        waitForExpectationsWithTimeout(30) { (error) -> Void in
            if let error = error {
                XCTAssertTrue(true, "API request took longer than the 30 second window. - Error: \(error.localizedDescription)")
            }
        }
    }

    func testCRUDRequests()
    {
        let myFacade = HTZNetworkingFacade.sharedInstance
        let postExpectation = expectationWithDescription("post request")
        let putExpectation = expectationWithDescription("put request")
        let deleteExpectation = expectationWithDescription("delete request")

        myFacade.networkingManager.baseURL = "http://httpbin.org/"

        // POST
        myFacade.networkingManager.sendDataWithEndPoint("post", dataParameters: ["Hello": "World"], httpMethod: HTTPRequestType.POST) { (responseData) -> () in

            switch responseData {
            case .Success(let validResponse):
                print("Valid response received. \(validResponse)")
            case .Failure(let NetworkingError.ResponseError(errorDescription)):
                XCTAssert(false, "The POST request failed. - \(errorDescription)")
            }
            postExpectation.fulfill()
        }

        // PUT
        myFacade.networkingManager.sendDataWithEndPoint("put", dataParameters: ["hola": "mundo"], httpMethod: .PUT) { (responseData) -> () in
            switch responseData {
            case .Success(let validResponse):
                print("Valid response received. \(validResponse)")
            case .Failure(let NetworkingError.ResponseError(errorDescription)):
                XCTAssert(false, "The PUT request failed. - \(errorDescription)")
            }
            putExpectation.fulfill()
        }

        // DELETE
        myFacade.networkingManager.sendDataWithEndPoint("delete", dataParameters: ["hello": "world"], httpMethod: .DELETE) { (responseData) -> () in
            switch responseData {
            case .Success(let validResponse):
                print("Valid response received. \(validResponse)")
            case .Failure(let NetworkingError.ResponseError(errorDescription)):
                XCTAssert(false, "The DELETE request failed. - \(errorDescription)")
            }
            deleteExpectation.fulfill()
        }
        waitForExpectationsWithTimeout(30) { (error) -> Void in
            if let error = error {
                XCTAssertTrue(true, "API request took longer than the 30 second window. - Error: \(error.localizedDescription)")
            }
        }
    }
}
