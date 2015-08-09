//
//  HTZNetworkingManager.swift
//  TestingSwift
//
//  Created by Kemar White on 7/8/15.
//  Copyright © 2015 toohotz. All rights reserved.
//

import Foundation
import Alamofire

enum HTTPRequestType: Int {
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

class HTZNetworkingManager: Manager {

    /// The base URL that will be used for all endpoint requests.
    var baseURL: String?

    init(baseURL: String?) {
    super.init()

        self.baseURL = baseURL
        if let _ = baseURL {
            print("A base URL has been instantiated.", appendNewline: true)
        }
    }

    required init(configuration: NSURLSessionConfiguration?) {
        fatalError("init(configuration:) has not been implemented")
    }

    /**
    Retrieve JSON data from a specified endpoint.

    :param: endpoint Specified endpoint.
    :param: JSONData Closure containing JSON data or an error if the request could no be completed.
    */
    func getDataFromEndPoint(endpoint: String?, JSONData: (receivedData: AnyObject?) -> () )
    {
        if let url = endpoint {
            let requestURL = "\(baseURL!)\(url)"
            Alamofire.request(.GET, requestURL).responseJSON { (request, responseObject, data, error) -> Void in
                // Handle data
                if error != nil {
                    JSONData(receivedData: error)
                } else {
                    JSONData( receivedData:data)
                }
            }
        } else {
            print("An error occurred trying to parse the endpoint tha you provided.", appendNewline: true)
        }
    }

    /**
    Sends data to a specific endpoint using an HTTPRequestType request

    :param: endpoint       The endpoint for the URL HTTP request.
    :param: dataParameters Optional dictionary information to send along with the request.
    :param: httpMethod     HTTPMethod to define the request type.
    :param: responseData   An optional response data received from network call if one is received.
    :param: error          An optional error if an error occurred.
    */
    func sendDataWithEndPoint(endpoint: String?, dataParameters: [String : AnyObject]?, httpMethod: HTTPRequestType, responseData: (postResponseStatus: String?, error: NSError?) -> () )
    {
        if let url = endpoint {
            let requestURL = "\(baseURL!)\(url)"

            Alamofire.request(Method(rawValue: HTTPRequestType(rawValue: httpMethod.rawValue)!.name)!, requestURL, parameters: dataParameters, encoding: .URL).responseString(completionHandler: { (_, _, responseString, error) -> Void in
                responseData(postResponseStatus: responseString, error: error)
            })

        } else {
                print("The request could not be handled", appendNewline: true)
            }

        }
}
