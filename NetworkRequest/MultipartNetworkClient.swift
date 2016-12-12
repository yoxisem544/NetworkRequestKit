//
//  MultipartNetworkClient.swift
//  NetworkRequest
//
//  Created by David on 2016/12/12.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation
import PromiseKit
import Alamofire
import SwiftyJSON

public protocol MultipartNetworkClientType {
    func performMultipartRequest<Request: MultipartNetworkRequest>(_ networkRequest: Request) -> Promise<Data>
}

public struct MultipartNetworkClient : MultipartNetworkClientType {
    
    public func performMultipartRequest<Request : MultipartNetworkRequest>(_ networkRequest: Request) -> Promise<Data> {
        
        let (promise, fulfill, reject) = Promise<Data>.pending()
        
        upload(multipartFormData: { multipartFormData in
            multipartFormData.append(networkRequest.multipartUploadData,
                                     withName: networkRequest.multipartUploadName,
                                     fileName: networkRequest.multipartUploadFileName,
                                     mimeType: networkRequest.multipartUploadMimeType)
        }, usingThreshold: 0, to: networkRequest.url, method: networkRequest.method, headers: networkRequest.headers) { (encodingResult) in
            switch encodingResult {
            case .success(request: let request, streamingFromDisk: _, streamFileURL: _):
                request.response(completionHandler: { (response) in
                    if let data = response.data , response.error == nil {
                        fulfill(data)
                    } else if let error = response.error, let data = response.data {
                        let e = AlamofireErrorHandler.handleNetworkRequestError(error, data: data, urlResponse: response.response)
                        reject(e)
                    } else {
                        reject(NetworkRequestError.unknownError)
                    }
                })
            case .failure(let error):
                reject(error)
            }
        }
        
        return promise
    }
    
}
