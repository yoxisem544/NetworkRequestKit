//
//  Fetch5Users.swift
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

final public class Fetch5Users : NetworkRequest {
  public typealias ResponseType = User
  
  public var endpoint: String { return "/post" }
  public var method: HTTPMethod { return .post }
  public var parameters: [String : Any]? {
    return ["users": [
        ["json": ["username": "1", "age": "100", "height": "100.1"]],
        ["json": ["username": "2", "age": "2", "height": "93.2"]],
        ["json": ["username": "3", "age": "65", "height": "70.1"]],
        ["json": ["username": "4", "age": "76", "height": "44.2"]],
        ["json": ["username": "5", "age": "12", "height": "89.12"]]
      ]
    ]
  }
  
  public func perform() -> Promise<[ResponseType]> {
    return networkClient.performRequest(self).then(execute: { data -> [ResponseType] in
      let json = JSON(data: data)["json"]["users"]
      // array response hanlder can only parse json array.
      // this is a transform.
      return try self.arrayResponseHandler(json.rawData())
    })
  }
  
}
