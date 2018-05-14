//
//  PagingEnabledRequest.swift
//  NetworkRequest
//
//  Created by David on 2016/12/21.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation
import PromiseKit

public enum NextPage {
  case nextPage(Int)
  case doesNotExist
}

public protocol PagingEnabledRequest {
  
  typealias PagingResult = (results: [Decodable], nextPage: NextPage)
  
  /// Responses per page, default to 25.
  var perPage: Int { get }
  /// Page you are going to fetch
  var page: Int { get set }
  /// Paramters to make a paging request.
  var pagingParameters: [String : Any] { get }
}

extension PagingEnabledRequest where Self : NetworkRequest {
  
  /// Default response per page is 25.
  /// Overload this if you want more responses at once.
  public var perPage: Int { return 25 }
  
  /// Parameters to tell backend which page and how much responses do you want.
  public var pagingParameters: [String : Any] { return ["page": page, "per_page": perPage] }
  
  /// Helper function to check if there is more pages to fetch.
  public func checkHasNextPage<Response: Decodable>(results: [Response]) -> Promise<PagingResult> {
    if results.count < perPage {
      // no next page
      return Promise.value((results: results, nextPage: .doesNotExist))
    } else {
      return Promise.value((results: results, nextPage: .nextPage(page + 1)))
    }
  }
    
}
