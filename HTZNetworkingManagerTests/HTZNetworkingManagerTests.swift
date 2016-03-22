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

    func testSingleton()
    {
       let firstSingleton = HTZNetworkingFacade.sharedInstance
        firstSingleton.networkingManager.baseURL = "Some URL"
        let secondSingleton = HTZNetworkingFacade.sharedInstance
        XCTAssert(firstSingleton.networkingManager === secondSingleton.networkingManager, "The singleton's network managers are not equal")
    }

    func testRequests()
    {
        let expectation = expectationWithDescription("Expecting a functional GET request")
        let postExpectation = expectationWithDescription("This API is expected to send a POST request")
        let deleteExpectation = expectationWithDescription("This API is expected to send a DELETE request")
        let putExpectation = expectationWithDescription("This API is expected to send a PUT request")

        let myFacade = HTZNetworkingFacade.sharedInstance
        myFacade.networkingManager.baseURL = "https://httpbin.org/"
        myFacade.networkingManager.getDataFromEndPoint("get", responseType: ResponseType.JSON) { (responseData) in
            switch responseData {
            case .Success(_):
                break
            case .Failure(let NetworkingError.ResponseError(errorDescription)):
                XCTAssert(false, "The GET request failed. - \(errorDescription)")
            }
            expectation.fulfill()
        }
        myFacade.networkingManager.sendDataWithEndPoint("post", dataParameters: ["Foo": "Bar"], responseType: .JSON, httpMethod: .POST) { (responseData) in
            switch responseData {
            case .Success(_):
                break
            case .Failure(let NetworkingError.ResponseError(errorDescription)):
                XCTAssert(false, "The POST request failed. - \(errorDescription)")
            }
            postExpectation.fulfill()
        }
        myFacade.networkingManager.sendDataWithEndPoint("put", dataParameters: ["Hello": "World"], responseType: .JSON, httpMethod: .PUT) { (responseData) in
            switch responseData {
            case .Success(_):
                break
            case .Failure(let NetworkingError.ResponseError(errorDescription)):
                XCTAssert(false, "The PUT request failed. - \(errorDescription)")
            }
            putExpectation.fulfill()
        }
        myFacade.networkingManager.sendDataWithEndPoint("delete", dataParameters: ["hola": "mundo"], responseType: .JSON, httpMethod: .DELETE) { (responseData) in
            switch responseData {
            case .Success(_):
                break
            case .Failure(let NetworkingError.ResponseError(errorDescription)):
                XCTAssert(false, "The DELETE request failed. - \(errorDescription)")
            }
            deleteExpectation.fulfill()
        }
        waitForExpectationsWithTimeout(10) { (error) -> Void in
            if let error = error {
                XCTAssertTrue(true, "API request took longer than the 30 second window. - Error: \(error.localizedDescription)")
            }
        }
    }
}
