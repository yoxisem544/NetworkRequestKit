//
//  NetworkRequestConfig.swift
//  NetworkRequestExample
//
//  Created by David on 2017/7/4.
//
//

import Foundation
import NetworkRequestKit

extension NetworkRequest {
  public var baseURL: String { return "http://httpbin.org" }
  public var accessToken: String { return "SOMETOKEN" }
  public var headers: [String : String] { return ["access_token": accessToken] }
}
