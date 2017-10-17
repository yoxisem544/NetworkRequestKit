//
//  RequestErrorInformation.swift
//  NetworkRequest
//
//  Created by David on 2016/12/12.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation
import SwiftyJSON

public struct RequestErrorInformation {
  
  /// Error returned from alamofire.
  let error: Error
  /// Error status code.
  let statusCode: Int?
  /// More error information, this could be returned error information from backend.
  let responseBody: JSON
  
  init(error: Error, data: Data?, urlResponse: HTTPURLResponse?) {
    self.error = error
    responseBody = (try? JSON(data: data ?? Data())) ?? JSON()
    statusCode = urlResponse?.statusCode
  }
    
}
