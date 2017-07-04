//
//  DictionaryExtension.swift
//  NetworkRequestExample
//
//  Created by David on 2017/7/4.
//
//

import Foundation

extension Dictionary {
  mutating func merge<S: Sequence>(contentsOf other: S) where S.Iterator.Element == (key: Key, value: Value) {
    for (key, value) in other {
      self[key] = value
    }
  }
  
  func merged<S: Sequence>(with other: S) -> [Key: Value] where S.Iterator.Element == (key: Key, value: Value) {
    var dic = self
    dic.merge(contentsOf: other)
    return dic
  }
}
