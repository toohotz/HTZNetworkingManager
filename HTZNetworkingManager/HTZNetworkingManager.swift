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
    case GET, HEAD, PUT, POST, DELETE

    var name: String {
        switch self {
        case .GET:   return "GET"
        case .HEAD:  return "HEAD"
        case .PUT:   return "PUT"
        case .POST:  return "POST"
        case .DELETE: return "DELETE"
        }
    }
}

public enum ResponseType {
    case JSON
    case String
    case RawData
}

public class HTZNetworkingFacade {

    /// The networking facade shared instance.
    static public let sharedInstance = HTZNetworkingFacade()

    /// The underlying networking manager.
    public let networkingManager = HTZNetworkingManager()

    public init() {}
}

public class HTZNetworkingManager: Manager {

    /// The base URL that will be used for all endpoint requests.
    public var baseURL: String?

    /**
     Retrieve JSON data from a specified endpoint.

     - parameter endpoint: Specified endpoint.
     - parameter JSONData: Closure containing JSON data or an error if the request could no be completed.
     */
    public func getDataFromEndPoint(endpoint: String?, JSONData: (Result<AnyObject, NetworkingError>) -> () )
    {
        guard let setURL = self.baseURL else {
            print("A base URL has not been set, cancelling request.")
            return
        }
        if endpoint == nil || endpoint?.isEmpty == true {
            Alamofire.request(.GET, setURL).responseJSON(completionHandler: { (jsonResponse) -> Void in
                if let finalResponse = jsonResponse.result.value {
                    JSONData(.Success(finalResponse))
                } else {
                    if let errorOccurred = jsonResponse.result.error {
                        JSONData(.Failure(NetworkingError.ResponseError(errorOccurred.localizedDescription)))
                    }
                }
            })
        } else  {
            let requestURL = "\(setURL)\(endpoint!)"
            Alamofire.request(.GET, requestURL).responseJSON(completionHandler: { (jsonResponse) -> Void in
                if let finalResponse = jsonResponse.result.value {
                    JSONData(.Success(finalResponse))
                } else {
                    if let errorOccurred = jsonResponse.result.error {
                        JSONData(.Failure(NetworkingError.ResponseError(errorOccurred.localizedDescription)))
                    }
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
    public func sendDataWithEndPoint(endpoint: String?, dataParameters: [String : AnyObject]?, responseType: ResponseType, httpMethod: HTTPRequestType, resultData: (Result<AnyObject, NetworkingError>) -> () )
    {
        guard let setURL = self.baseURL else {
            print("A base URL has not been set, cancelling request.")
            return
        }
        let requestURL = (endpoint != nil) ? "\(setURL)\(endpoint!)" : setURL
        // Response type checking
        switch responseType {
        case .JSON:
            Alamofire.request(Method(rawValue: HTTPRequestType(rawValue: httpMethod.rawValue)!.name)!, requestURL, parameters: dataParameters, encoding: .JSON, headers: nil).responseJSON(completionHandler: { (JSONResponse) -> Void in
                switch JSONResponse.result {
                case .Success(let JSON):
                    resultData(.Success(JSON))
                case .Failure(let errorOccurred):
                    resultData(.Failure(NetworkingError.ResponseError(errorOccurred.localizedDescription)))
                }
            })
        case .String:
            Alamofire.request(Method(rawValue: HTTPRequestType(rawValue: httpMethod.rawValue)!.name)!, requestURL, parameters: dataParameters, encoding: .JSON, headers: nil).responseString(completionHandler: { (responseString) -> Void in
                switch responseString.result {
                case .Success(let validString):
                    resultData(.Success(validString))

                case .Failure(let errorOccurred):
                    resultData(.Failure(NetworkingError.ResponseError(errorOccurred.localizedDescription)))
                }
            })
        case .RawData:
            Alamofire.request(Method(rawValue: HTTPRequestType(rawValue: httpMethod.rawValue)!.name)!, requestURL, parameters: dataParameters, encoding: .JSON, headers: nil).responseData({ (responseData) -> Void in
                switch responseData.result {
                case .Success(let validResponse):
                    resultData(.Success(validResponse))
                case .Failure(let errorOccurred):
                    resultData(.Failure(NetworkingError.ResponseError(errorOccurred.localizedDescription)))
                }
            })
        }
    }
}
