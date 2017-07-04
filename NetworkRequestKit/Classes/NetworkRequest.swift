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

/// NetworkRequestError
///
/// - failToDecode:  Fail to decode the response.
/// - requestFailed: Reqeust failed, with error information attached.
/// - unknownError:  Unknown error.
/// - noNetwork:     No network connection.
public enum NetworkRequestError: Error {
  case failToDecode
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
	var responseHandler: (Data) throws -> ResponseType { get }
	
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

extension NetworkRequest where ResponseType: JSONDecodable {
	public var responseHandler: (Data) throws -> ResponseType { return jsonResponseHandler }
	public var arrayResponseHandler: (Data) throws -> [ResponseType] { return jsonArrayResponseHandler }
}

extension NetworkRequest where ResponseType == IgnorableResult {
	public var responseHandler: (Data) throws -> ResponseType { return ignorableResponseHandler }
	public var arrayResponseHandler: (Data) throws -> [ResponseType] { return ignorableArrayResponseHandler }
}

extension NetworkRequest where ResponseType == RawJSONResult {
  public var responseHandler: (Data) throws -> ResponseType { return rawJSONResponseHandler }
}

private func jsonResponseHandler<Response: JSONDecodable>(_ data: Data) throws -> Response {
	let json = JSON(data: data)
  do {
    return try Response(decodeUsing: json)
  } catch {
    throw NetworkRequestError.failToDecode
  }
}

private func jsonArrayResponseHandler<Response: JSONDecodable>(_ data: Data) throws -> [Response] {
	let json = JSON(data: data)
	guard json.type == Type.array else { throw JSONDecodableError.parseError }
	var responses: [Response] = []
	for (_, json) in json {
    guard let response = (try? Response(decodeUsing: json)) else { continue }
    responses.append(response)
	}
	return responses
}

private func ignorableResponseHandler(_ data: Data) throws -> IgnorableResult {
	return IgnorableResult()
}

private func ignorableArrayResponseHandler(_ data: Data) throws -> [IgnorableResult] {
	return []
}

private func rawJSONResponseHandler(_ data: Data) throws -> RawJSONResult {
  return JSON(data: data)
}
