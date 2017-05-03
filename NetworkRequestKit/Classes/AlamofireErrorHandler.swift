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
            let errorInfo = APIUnacceptableErrorInformation(error: error, data: data, urlResponse: urlResponse)
            let e = NetworkRequestError.apiUnacceptable(errorInformation: errorInfo)
            return e as Error
        }
    }
    
}
