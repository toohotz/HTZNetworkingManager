//
//  HTZNetworkingManager.swift
//  TestingSwift
//
//  Created by Kemar White on 7/8/15.
//  Copyright © 2015 toohotz. All rights reserved.
//

import Foundation
import Alamofire

public enum HTTPRequestType: Int {
    case get, head, put, post, delete

    var name: String {
        switch self {
        case .get:   return "GET"
        case .head:  return "HEAD"
        case .put:   return "PUT"
        case .post:  return "POST"
        case .delete: return "DELETE"
        }
    }
}

public enum ResponseType {
    case json
    case string
    case rawData
}

public class HTZNetworkingFacade {

    /// The networking facade shared instance.
    static public let sharedInstance = HTZNetworkingFacade()

    /// The underlying networking manager that initiates HTTP requests.
    public let networkingManager = HTZNetworkingManager()

    public init() {}
}

public class HTZNetworkingManager: Manager {

    /// The base URL that will be used for all endpoint requests.
    public var baseURL: String?

    /**
     Retrieve JSON data from a specified endpoint.

     - parameter endpoint: Specified endpoint.
     - parameter JSONData: Closure containing the specified response type data or an error if the request could no be completed.
     */
    public func getDataFromEndPoint(_ endpoint: String?, responseType: ResponseType, resultData: (Result<AnyObject, NetworkingError>) -> () )
    {
        guard let setURL = self.baseURL else {
            print("A base URL has not been set, cancelling request.")
            return
        }
        let requestURL = (endpoint != nil) ? "\(setURL)\(endpoint!)" : setURL

        switch responseType {
        case .json:
            Alamofire.request(.GET, requestURL).responseJSON(completionHandler: { (JSONResponse) -> Void in
                switch JSONResponse.result {
                case .success(let JSON):
                    resultData(.success(JSON))
                case .failure(let errorOccurred):
                    resultData(.failure(NetworkingError.responseError(errorOccurred.localizedDescription)))
                }
            })
        case .string:
            Alamofire.request(.GET, requestURL).responseString(completionHandler: { (responseString) -> Void in
                switch responseString.result {
                case .success(let stringValue):
                    resultData(.success(stringValue))
                case .failure(let errorOccurred):
                    resultData(.failure(NetworkingError.responseError(errorOccurred.localizedDescription)))
                }
            })
        case .rawData:
            Alamofire.request(.GET, requestURL).responseData(completionHandler: { (responseData) -> Void in
                switch responseData.result {
                case .success(let response):
                    resultData(.success(response))
                case .failure(let errorOccurred):
                    resultData(.failure(NetworkingError.responseError(errorOccurred.localizedDescription)))
                }
            })
        }
    }

    /**
     Sends data to a specified endpoint (if provided) using an **HTTPRequestType** request.

     - parameter endpoint:       The endpoint for the URL HTTP request.
     - parameter dataParameters: Optional dictionary information to send along with the request.
     - parameter responseType:   The desired response type (ie. JSON for a JSON response type, String for an expected string response type)
     - parameter httpMethod:      **HTTPMethod** to define the request type.
     - parameter resultData:     Closure containing result data or an error if the request could no be completed.
     */
    public func sendDataWithEndPoint(_ endpoint: String?, dataParameters: [String : AnyObject]?, responseType: ResponseType, httpMethod: HTTPRequestType, resultData: (Result<AnyObject, NetworkingError>) -> () )
    {
        guard let setURL = self.baseURL else {
            print("A base URL has not been set, cancelling request.")
            return
        }
        let requestURL = (endpoint != nil) ? "\(setURL)\(endpoint!)" : setURL
        // Response type checking
        switch responseType {
        case .json:
            Alamofire.request(Method(rawValue: HTTPRequestType(rawValue: httpMethod.rawValue)!.name)!, requestURL, parameters: dataParameters, encoding: .json, headers: nil).responseJSON(completionHandler: { (JSONResponse) -> Void in
                switch JSONResponse.result {
                case .success(let JSON):
                    resultData(.success(JSON))
                case .failure(let errorOccurred):
                    resultData(.failure(NetworkingError.responseError(errorOccurred.localizedDescription)))
                }
            })
        case .string:
            Alamofire.request(Method(rawValue: HTTPRequestType(rawValue: httpMethod.rawValue)!.name)!, requestURL, parameters: dataParameters, encoding: .json, headers: nil).responseString(completionHandler: { (responseString) -> Void in
                switch responseString.result {
                case .success(let validString):
                    resultData(.success(validString))

                case .failure(let errorOccurred):
                    resultData(.failure(NetworkingError.responseError(errorOccurred.localizedDescription)))
                }
            })
        case .rawData:
            Alamofire.request(Method(rawValue: HTTPRequestType(rawValue: httpMethod.rawValue)!.name)!, requestURL, parameters: dataParameters, encoding: .json, headers: nil).responseData(completionHandler: { (responseData) -> Void in
                switch responseData.result {
                case .success(let validResponse):
                    resultData(.success(validResponse))
                case .failure(let errorOccurred):
                    resultData(.failure(NetworkingError.responseError(errorOccurred.localizedDescription)))
                }
            })
        }
    }
}
