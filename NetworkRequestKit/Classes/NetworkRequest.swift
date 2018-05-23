//
//  NetworkRequest.swift
//  CalendarApp
//
//  Created by David on 2016/9/5.
//  Copyright © 2016年 David. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import PromiseKit

/// NetworkRequestError
///
/// - decodingError: Fail to decode.
/// - jsonParsingError: Fail to parse JSON.
/// - requestFailed: Reqeust failed, with error information attached.
/// - unknownError:  Unknown error.
/// - noNetwork:     No network connection.
public enum NetworkRequestError: Error {
  case decodingError(error: DecodingError)
  case jsonParsingError(error: Error)
  case requestFailed(information: RequestErrorInformation)
  case unknownError
  case noNetwork
}

/// A ignorable result.
/// Will ignore the result server responsed.
public typealias IgnorableResult = ()

/// JSON type of response.
/// Will just pack the response data into json, wont be trasfrom into model.
public typealias RawJSONResult = JSON

/// NetworkRequest
///
/// All information you need to make a network request.
public protocol NetworkRequest {
	associatedtype ResponseType
	
	// MARK: Required
  
	/// End Point.
	/// e.g. /cards/:id/dislike
	var endpoint: String { get }
  
	/// Will transform given data to requested type of response.
	var responseHandler: (Data) throws -> Promise<ResponseType> { get }
	
	// MARK: Optional
	/// An url pointing to your service.
  /// e.g. https://www.myService.io or an ip.
  /// You should extend NetworkRequest and overload this property.
	var baseURL: String { get }
  
	/// Method to make the request. E.g. get, post.
	var method: Alamofire.HTTPMethod { get }
  
	/// Parameter encoding. E.g. JSON, URLEncoding.default.
	var encoding: Alamofire.ParameterEncoding { get }
	
	var parameters: [String : Any]? { get }
  
	var headers: [String : String] { get }
	
	/// Client that helps you to make reqeust.
	var networkClient: NetworkClientType { get }
}

// MARK: - NetworkRequest default implementation
public extension NetworkRequest {
	/// URL to make the request.
  public var url: String { return baseURL + endpoint }
	public var method: Alamofire.HTTPMethod { return .get }
  /// Enconding of this request, default encoding of get is url encoded. post is json encoded
  public var encoding: Alamofire.ParameterEncoding { return method == .get ? URLEncoding.default : JSONEncoding.default }
	
	public var parameters: [String : Any]? { return nil }
  public var headers: [String : String] { return [:] }
	
	public var networkClient: NetworkClientType { return NetworkClient() }
}

// MARK: - Codable extension
extension NetworkRequest where ResponseType: Decodable {
  public var responseHandler: (Data) throws -> Promise<ResponseType> { return decodableResponseHandler }
}

private func decodableResponseHandler<Response: Decodable>(_ data: Data) throws -> Promise<Response> {
  return Promise { seal in
    let jsonDecoder = JSONDecoder()
    do {
      seal.fulfill(try jsonDecoder.decode(Response.self, from: data))
    } catch let e as DecodingError {
      seal.reject(NetworkRequestError.decodingError(error: e))
    }
  }
}

// MARK: - Ignorable Result extesion aka Void, ()
extension NetworkRequest where ResponseType == IgnorableResult {
	public var responseHandler: (Data) throws -> Promise<ResponseType> { return ignorableResponseHandler }
}

private func ignorableResponseHandler(_ data: Data) throws -> Promise<IgnorableResult> {
  return Promise.value(IgnorableResult())
}

// MARK: - SwifyJSON extension
extension NetworkRequest where ResponseType == RawJSONResult {
  public var responseHandler: (Data) throws -> Promise<ResponseType> { return rawJSONResponseHandler }
}

private func rawJSONResponseHandler(_ data: Data) throws -> Promise<RawJSONResult> {
  return Promise { seal in
    do {
      seal.fulfill(try JSON(data: data))
    } catch let e {
      seal.reject(NetworkRequestError.jsonParsingError(error: e))
    }
  }
}
