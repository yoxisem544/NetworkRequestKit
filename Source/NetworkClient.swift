//
//  NetworkClient.swift
//  CalendarApp
//
//  Created by David on 2016/9/5.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation
import Alamofire
import PromiseKit

public protocol NetworkClientType {
	func performRequest<Request: NetworkRequest>(_ networkRequest: Request) -> Promise<Data>
}

public struct NetworkClient: NetworkClientType {
	
	public func performRequest<Request : NetworkRequest>(_ networkRequest: Request) -> Promise<Data> {
		
		let (promise, seal) = Promise<Data>.pending()
		print("🔗", #function, "send request to url:", networkRequest.url)
    print("📩 method:", networkRequest.method)
    print("🚠 parameters:", networkRequest.parameters ?? [:])
		
		request(networkRequest.url,
		        method: networkRequest.method,
		        parameters: networkRequest.parameters,
		        encoding: networkRequest.encoding,
		        headers: networkRequest.headers)
			.validate().response { (response) in
				if let data = response.data , response.error == nil {
					seal.fulfill(data)
				} else if let error = response.error, let data = response.data {
                    let e = AlamofireErrorHandler.handleNetworkRequestError(error, data: data, urlResponse: response.response)
					seal.reject(e)
				} else {
					seal.reject(NetworkRequestError.unknownError)
				}
		}
		
		return promise
	}
	
}
