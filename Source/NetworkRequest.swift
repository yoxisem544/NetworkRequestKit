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
/// - invalidData:         Fail to parse data from response.
/// - apiUnacceptable:     Fail to connect with api. Error information attached.
/// - unknownError:        Unknown error.
/// - noNetworkConnection: no network connection.
public enum NetworkRequestError: Error {
	case invalidData
    case apiUnacceptable(errorInformation: APIUnacceptableErrorInformation)
	case unknownError
    case noNetworkConnection
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
	
	// Required
	/// End Point.
	/// e.g. /cards/:id/dislike
	var endpoint: String { get }
	/// Will transform given data to requested type of response.
	var responseHandler: (Data) throws -> ResponseType { get }
	
	// Optional
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
	/// Access token to make the api request.
	public var accessToken: String { return "" }
	public var baseURL: String { return "https://httpbin.org/" }
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
        throw NetworkRequestError.invalidData
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

private func codableResponseHandler<Response: Codable>(_ data: Data) throws -> Response {
  let jsonDecoder = JSONDecoder()
  return try jsonDecoder.decode(Response.self, from: data)
}
private func codableArrayResponseHandler<Response: Codable>(_ data: Data) throws -> [Response] {
  let jsonDecoder = JSONDecoder()
  return try jsonDecoder.decode([Response].self, from: data)
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
