//
//  DictionaryConvertable.swift
//  Pods
//
//  Created by Andriy K. on 12/10/15.
//
//

import Foundation

protocol DictionaryConvertable {
  associatedtype T
  static func entityFromDictionary(_ dict: NSDictionary) -> T?
}

public protocol DictionaryInitialization {
  init(dict: NSDictionary)
}

protocol ArrayInitialization {
  init(array: NSArray)
}

public func performWithDelay(_ delay: Double, closure: () -> Void) {
  DispatchQueue.main.after(when: .now() + delay, execute: closure)
}
