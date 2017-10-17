//
//  CodableExample.swift
//  NetworkRequestExample
//
//  Created by David on 2017/10/17.
//

import Foundation
import NetworkRequestKit
import Alamofire
import PromiseKit

struct Employee {
  var name: String
  var id: String
  var favoriteToy: Toy
  
  enum JSONKeys: String, CodingKey {
    case json
  }
  
  enum CodingKeys: String, CodingKey {
    case id = "employee_id"
    case name
    case gift
  }
}

extension Employee : Encodable {
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(id, forKey: .id)
    try container.encode(name, forKey: .name)
    try container.encode(favoriteToy, forKey: .gift)
  }
}

extension Employee : Decodable {
  init(from decoder: Decoder) throws {
    let jsonContainer = try decoder.container(keyedBy: JSONKeys.self)
    let values = try jsonContainer.nestedContainer(keyedBy: CodingKeys.self, forKey: .json)
//    let values = try decoder.container(keyedBy: CodingKeys.self)
    id = try values.decode(String.self, forKey: .id)
    name = try values.decode(String.self, forKey: .name)
    favoriteToy = try values.decode(Toy.self, forKey: Employee.CodingKeys.gift)
  }
}

struct Toy: Codable {
  var name: String
}

class FetchEmployee : NetworkRequest {
  typealias ResponseType = Employee
  
  // I use httpbin here, check httpbin for futher information
  // For normal usage, this is the endpoint that your request is going.
  public var endpoint: String { return "/post" }
  public var method: HTTPMethod { return .post }
  
  // parameter here is passed to httpbin, then will be return by httpbin.
  public var parameters: [String : Any]? {
    return ["employee_id": "1", "name": "johnny appleseed", "gift": ["name": "Lego"]]
  }
  
  public func perform() -> Promise<ResponseType> {
    return networkClient.performRequest(self).then(execute: responseHandler)
  }
}
