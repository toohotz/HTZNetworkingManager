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
private let sharedInstance = HTZNetworkingFacade()

public class HTZNetworkingFacade {

    /// The networking facade shared instance.
    static let sharedInstance = HTZNetworkingFacade()

    let networkingManager = HTZNetworkingManager()

    var baseURL: String?
}

public class HTZNetworkingManager: Manager {

    /// The base URL that will be used for all endpoint requests.
    var baseURL: String?

    public init() {
        super.init()
    }

    required public override init(configuration: NSURLSessionConfiguration, serverTrustPolicyManager: ServerTrustPolicyManager?) {
        fatalError("init(configuration:serverTrustPolicyManager:) has not been implemented")
    }

    /**
    Retrieve JSON data from a specified endpoint.

    - parameter endpoint: Specified endpoint.
    - parameter JSONData: Closure containing JSON data or an error if the request could no be completed.
    */
    public func getDataFromEndPoint(endpoint: String?, JSONData: (receivedData: AnyObject?) -> () )
    {
        guard let setURL = self.baseURL else { return }
        if let url = endpoint {
            let requestURL = "\(setURL)\(url)"

            Alamofire.request(.GET, requestURL).responseJSON(completionHandler: { (_, responseObject, _) -> Void in
                guard let validResponse = responseObject else {
                    print("An error occurred for the GET request", terminator: "\n")
                    return
                }
                JSONData(receivedData: validResponse)
            })
        } else {
            print("An error occurred trying to parse the endpoint tha you provided.", terminator: "\n")
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
        guard let setURL = self.baseURL else { return }
        if let url = endpoint {
            let requestURL = "\(setURL)\(url)"

            Alamofire.request(Method(rawValue: HTTPRequestType(rawValue: httpMethod.rawValue)!.name)!, requestURL, parameters: dataParameters, encoding: .URL, headers: nil).responseJSON(completionHandler: { (_, dataResponse, _) -> Void in
                responseData(responseData: dataResponse)
            })
        } else {
            print("The request could not be handled", terminator: "\n")
        }
    }
}
