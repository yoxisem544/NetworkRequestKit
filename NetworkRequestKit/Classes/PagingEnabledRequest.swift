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
  
  typealias PagingResult = (results: [Decodable], nextPage: Int?)
  
  /// Responses per page, default to 25.
  var perPage: Int { get }
  /// Page you are going to fetch
  var page: Int { get set }
  /// Paramters to make a paging request.
  var pagingParameters: [String : Any] { get }
}

extension PagingEnabledRequest where Self : NetworkRequest {
    
  public var perPage: Int { return 25 }
  
  public var pagingParameters: [String : Any] { return ["page": page, "per_page": perPage] }
  
  public func checkHasNextPage<Response: Decodable>(results: [Response]) -> Promise<PagingResult> {
    if results.count < perPage {
      // no next page
      return Promise(value: (results: results, nextPage: nil))
    } else {
      return Promise(value: (results: results, nextPage: page + 1))
    }
  }
    
}
