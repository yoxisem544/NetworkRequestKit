//
//  APIUnacceptableErrorInformation.swift
//  NetworkRequest
//
//  Created by David on 2016/12/12.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation
import SwiftyJSON

public struct APIUnacceptableErrorInformation {
    
    let error: Error
    let statusCode: Int?
    let responseBody: JSON
    let errorCode: String?
    
    init(error: Error, data: Data?, urlResponse: HTTPURLResponse?) {
        self.error = error
        responseBody = JSON(data: data ?? Data())
        statusCode = urlResponse?.statusCode
        errorCode = responseBody["error_code"].string
    }
    
}
