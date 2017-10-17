//
//  User.swift
//  NetworkRequestExample
//
//  Created by David on 2017/7/4.
//
//

import Foundation
import SwiftyJSON
import NetworkRequestKit

public struct User {
  let name: String
  let age: String
  let height: String
  
  enum JSONKeys: String, CodingKey {
    case json
  }
  
  enum CodingKeys: String, CodingKey {
    case name = "username"
    case age
    case height
  }
}

//extension User : Encodable {
//  public func encode(to encoder: Encoder) throws {
//    var container = encoder.container(keyedBy: CodingKeys.self)
//    try container.encode(name, forKey: .name)
//    try container.encode(age, forKey: .age)
//    try container.encode(height, forKey: .height)
//  }
//}

extension User : Decodable {
  public init(from decoder: Decoder) throws {
    let json = try decoder.container(keyedBy: JSONKeys.self)
    let values = try json.nestedContainer(keyedBy: CodingKeys.self, forKey: .json)
    name = try values.decode(String.self, forKey: .name)
    age = try values.decode(String.self, forKey: .age)
    height = try values.decode(String.self, forKey: .height)
  }
}
