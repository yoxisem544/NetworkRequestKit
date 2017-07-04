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
  let age: Int
  let height: Double
}

extension User : JSONDecodable {
  
  public init(decodeUsing json: JSON) throws {
    let json = json["json"]
    
    guard let name = json["username"].string else { throw JSONDecodableError.parseError }
    
    self.name = name
    age = json["age"].intValue
    height = json["height"].doubleValue
  }
  
}
