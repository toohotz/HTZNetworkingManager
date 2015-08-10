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

public class HTZNetworkingManager: Manager {

    /// The base URL that will be used for all endpoint requests.
    var baseURL: String?

    public init(baseURL: String?) {
        super.init()

        self.baseURL = baseURL
        if let _ = baseURL {
            print("A base URL has been instantiated.", appendNewline: true)
        }
    }

    required public init(configuration: NSURLSessionConfiguration, serverTrustPolicyManager: ServerTrustPolicyManager?) {
        fatalError("init(configuration:serverTrustPolicyManager:) has not been implemented")
    }

    /**
    Retrieve JSON data from a specified endpoint.

    - parameter endpoint: Specified endpoint.
    - parameter JSONData: Closure containing JSON data or an error if the request could no be completed.
    */
    public func getDataFromEndPoint(endpoint: String?, JSONData: (receivedData: AnyObject?) -> () )
    {
        if let url = endpoint {
            let requestURL = "\(baseURL!)\(url)"

            Alamofire.request(.GET, requestURL).responseJSON(completionHandler: { (_, responseObject, _) -> Void in
                guard let validResponse = responseObject else {
                    print("An error occurred for the GET request", appendNewline: true)
                    return
                }
                JSONData(receivedData: validResponse)
            })
        } else {
            print("An error occurred trying to parse the endpoint tha you provided.", appendNewline: true)
        }
    }

    /**
    Sends data to a specific endpoint using an HTTPRequestType request.

    - parameter endpoint:       The endpoint for the URL HTTP request.
    - parameter dataParameters: Optional dictionary information to send along with the request.
    - parameter httpMethod:     HTTPMethod to define the request type.
    - parameter responseData:   An optional response data received from network call if one is received.
    - parameter error:          An optional error if an error occurred.
    */
    public func sendDataWithEndPoint(endpoint: String?, dataParameters: [String : AnyObject]?, httpMethod: HTTPRequestType, responseData: (responseData: AnyObject?) -> () )
    {
        if let url = endpoint {
            let requestURL = "\(baseURL!)\(url)"

            Alamofire.request(Method(rawValue: HTTPRequestType(rawValue: httpMethod.rawValue)!.name)!, requestURL, parameters: dataParameters, encoding: .URL, headers: nil).responseJSON(completionHandler: { (_, dataResponse, _) -> Void in
                responseData(responseData: dataResponse)
            })
        } else {
            print("The request could not be handled", appendNewline: true)
        }
    }
}
