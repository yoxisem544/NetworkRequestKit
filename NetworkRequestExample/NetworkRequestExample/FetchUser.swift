//
//  FetchUser.swift
//  NetworkRequestExample
//
//  Created by David on 2017/7/4.
//
//

import Foundation
import NetworkRequestKit
import SwiftyJSON
import Alamofire
import PromiseKit

final public class FetchUser : NetworkRequest {
  
  public typealias ResponseType = User
  
  // I use httpbin here, check httpbin for futher information
  // For normal usage, this is the endpoint that your request is going.
  public var endpoint: String { return "/post" }
  public var method: HTTPMethod { return .post }
  
  // parameter here is passed to httpbin, then will be return by httpbin.
  public var parameters: [String : Any]? {
    return ["username": "1", "age": "100", "height": "100.1"]
  }
  
  public func perform() -> Promise<ResponseType> {
    return networkClient.performRequest(self).then(responseHandler)
  }
  
}
