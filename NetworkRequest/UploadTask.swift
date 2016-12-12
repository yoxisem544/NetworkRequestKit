//
//  UploadTask.swift
//  NetworkRequest
//
//  Created by David on 2016/12/12.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation
import Alamofire
import PromiseKit
import SwiftyJSON

final public class UploadTask : MultipartNetworkRequest {
    public typealias ResponseType = IgnorableResult
    
    public var endpoint: String { return "hi" }
    public var method: HTTPMethod { return .post }
    public var encoding: ParameterEncoding { return URLEncoding.default }
    
    public var multipartUploadData: Data { return Data() }
    public var multipartUploadName: String { return "" }
    public var multipartUploadFileName: String { return "" }
    public var multipartUploadMimeType: String { return "" }
    
    func perform() -> Promise<ResponseType> {
        return networkClient.performUploadRequest(self).then(execute: responseHandler)
    }
}
