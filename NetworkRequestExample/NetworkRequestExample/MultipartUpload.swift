//
//  MultipartUpload.swift
//  NetworkRequestExample
//
//  Created by David on 2017/7/4.
//
//

import Foundation
import NetworkRequestKit
import Alamofire
import SwiftyJSON
import PromiseKit

final public class MultipartUpload : MultipartNetworkRequest {
  public typealias ResponseType = RawJSONResult
  
  public var endpoint: String { return "/post" }
  public var method: HTTPMethod { return .post }
  
  public var multipartUploadData: Data {
    let img = UIImage(named: "E0YWjdh.jpg")!
    return UIImageJPEGRepresentation(img, 0.01)!
  }
  public var multipartUploadName: String { return "ImageData" }
  public var multipartUploadFileName: String { return "SomeString" }
  public var multipartUploadMimeType: String { return "img/jpeg" }
  
  public func perform() -> Promise<ResponseType> {
    return networkClient.performMultipartRequest(self).then(execute: responseHandler)
  }
  
}
