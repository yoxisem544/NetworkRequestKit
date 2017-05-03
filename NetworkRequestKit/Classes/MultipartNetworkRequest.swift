//
//  MultipartNetworkRequest.swift
//  NetworkRequest
//
//  Created by David on 2016/12/12.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation

public protocol MultipartNetworkRequest : NetworkRequest {
    
    /// Data prepared to upload
    var multipartUploadData: Data { get }
    /// e.g. "avatar"
    var multipartUploadName: String { get }
    /// e.g. "file"
    var multipartUploadFileName: String { get }
    /// e.g. "image/jpeg"
    var multipartUploadMimeType: String { get }
    
    var networkClient: MultipartNetworkClient { get }
    
}

extension MultipartNetworkRequest {
    
    public var networkClient: MultipartNetworkClient { return MultipartNetworkClient() }
    
}
