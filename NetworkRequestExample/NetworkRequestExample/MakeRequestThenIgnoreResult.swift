//
//  MakeRequestThenIgnoreResult.swift
//  NetworkRequestExample
//
//  Created by David on 2017/7/4.
//
//

import Foundation
import NetworkRequestKit
import Alamofire
import SwiftyJSON
import PromiseKit

final public class MakeRequestThenIgnoreResult : NetworkRequest {
  public typealias ResponseType = IgnorableResult
  
  public var endpoint: String { return "/post" }
  public var method: HTTPMethod { return .post }
  public var parameters: [String : Any]? { return ["ignore": "this"] }
  
  public func perform() -> Promise<ResponseType> {
    return networkClient.performRequest(self).then(execute: responseHandler)
  }
  
}
