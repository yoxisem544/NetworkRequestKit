//
//  AlamofireErrorHandler.swift
//  NetworkRequest
//
//  Created by David on 2016/12/12.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

public class AlamofireErrorHandler {
    
    public class func handleNetworkRequestError(_ error: Error, data: Data?, urlResponse: HTTPURLResponse?) -> Error {
        if (error as NSError).code == -1009 {
            return NetworkRequestError.noNetworkConnection
        } else {
            let responseBody: JSON? = (data != nil ? JSON(data: data!) : nil)
            let statusCode = urlResponse?.statusCode
            let errorCode = responseBody?["error_code"].string
            let e = NetworkRequestError.apiUnacceptable(error: error, statusCode: statusCode, responseBody: responseBody, errorCode: errorCode)
            return e as Error
        }
    }
    
}
