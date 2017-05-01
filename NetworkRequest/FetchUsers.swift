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

final public class FetchUsers : NetworkRequest {
    public typealias ResponseType = RawJSONResult
    
    public var endpoint: String { return "/post" }
    public var method: HTTPMethod { return .post }
    public var parameters: [String : Any]? { return ["YA": 100] }
    
    public var page: Int = 1
    public func perform(page: Int) -> Promise<ResponseType> {
        self.page = page
        return networkClient.performRequest(self).then(execute: responseHandler)
    }
    
}
