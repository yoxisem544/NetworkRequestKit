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
  var baseURL: String { return "http://httpbin.org" }
  var accessToken: String { return "SOMETOKEN" }
  var headers: [String : String] { return ["access_token": accessToken] }
}
