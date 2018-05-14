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

public protocol MultipartNetworkClientType {
  func performMultipartRequest<Request: MultipartNetworkRequest>(_ networkRequest: Request) -> Promise<Data>
}

public struct MultipartNetworkClient : MultipartNetworkClientType {
    
  public func performMultipartRequest<Request : MultipartNetworkRequest>(_ networkRequest: Request) -> Promise<Data> {
      
    let (promise, seal) = Promise<Data>.pending()
    
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
            seal.fulfill(data)
          } else if let error = response.error, let data = response.data {
            let e = AlamofireErrorHandler.handleNetworkRequestError(error, data: data, urlResponse: response.response)
            seal.reject(e)
          } else {
            seal.reject(NetworkRequestError.unknownError)
          }
        })
      case .failure(let error):
          seal.reject(error)
      }
    }
    
    return promise
  }
    
}
