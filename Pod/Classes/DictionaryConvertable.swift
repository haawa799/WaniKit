//
//  DictionaryConvertable.swift
//  Pods
//
//  Created by Andriy K. on 12/10/15.
//
//

import Foundation

protocol DictionaryConvertable {
  typealias T
  static func entityFromDictionary(dict: NSDictionary) -> T?
}

protocol DictionaryInitialization {
  init(dict: NSDictionary)
}
//
//protocol ArrayInitialization {
//  init(array: NSArray)
//}
