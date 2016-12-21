//
//  FetchUsers.swift
//  NetworkRequest
//
//  Created by David on 2016/12/21.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation
import PromiseKit
import Alamofire

final public class FetchUsers : NetworkRequest, PagingEnabledRequest {
    public typealias ResponseType = IgnorableResult
    
    public var endpoint: String { return "/users" }
    public var method: HTTPMethod { return .get }
    public var parameters: [String : Any]? { return ["page": page, "per_page": perPage] }
    
    public var page: Int = 1
    public func perform(page: Int) {
        networkClient.performRequest(self).then(execute: arrayResponseHandler)
    }
    
}
