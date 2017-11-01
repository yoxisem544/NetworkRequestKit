//
//  PagingRequest.swift
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

final public class PagingRequest : NetworkRequest, PagingEnabledRequest {
  
  public typealias ResponseType = [User]
  
  // I use httpbin here, check httpbin for futher information
  // For normal usage, this is the endpoint that your request is going.
  public var endpoint: String { return "/post" }
  public var method: HTTPMethod { return .post }
  
  // get 7 objects per page.
  public var perPage: Int { return 20 }
  public var page: Int = 1
  
  // parameter here is passed to httpbin, then will be return by httpbin.
  public var parameters: [String : Any]? {
    return ["users": [
        ["json": ["username": "1", "age": "100", "height": "100.1"]],
        ["json": ["username": "2", "age": "2", "height": "93.2"]],
        ["json": ["username": "3", "age": "65", "height": "70.1"]],
        ["json": ["username": "4", "age": "76", "height": "44.2"]],
        ["json": ["username": "5", "age": "12", "height": "89.12"]],
        ["json": ["username": "6", "age": "1255", "height": "89.12"]],
        ["json": ["username": "7", "age": "18882", "height": "89.12"]]
      ]
    ].merged(with: pagingParameters)
  }
  
  public func makeRequest(forPage page: Int) -> Promise<PagingResult> {
    self.page = page
    
    return networkClient.performRequest(self).then(execute: { data -> ResponseType in
      let json = try JSON(data: data)["json"]["users"]
      // array response hanlder can only parse json array.
      // this is a transform.
      return try self.responseHandler(json.rawData())
    }).then(execute: checkHasNextPage)
  }
  
}
