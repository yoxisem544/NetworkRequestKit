//
//  PagingEnabledRequest.swift
//  NetworkRequest
//
//  Created by David on 2016/12/21.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation
import PromiseKit

public protocol PagingEnabledRequest {
    /// Responses per page, default to 25.
    var perPage: Int { get }
    /// Page you are going to fetch
    var page: Int { get set }
    /// Paramters to make a paging request.
    var pagingParameters: [String : Any] { get }
}

extension PagingEnabledRequest {
    
    public var perPage: Int { return 25 }
    
    var pagingParameters: [String : Any] { return ["page": page, "per_page": perPage] }
    
    func checkHasNextPage<Response>(results: [Response]) -> Promise<(results: [Response], nextPage: Int?)> {
        if results.count < perPage {
            // no next page
            return Promise(value: (results: results, nextPage: nil))
        } else {
            return Promise(value: (results: results, nextPage: page + 1))
        }
    }
    
}
