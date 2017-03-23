//
//  SRSLevelInfo.swift
//  WaniKit
//
//  Created by Andriy K. on 9/13/16.
//  Copyright © 2016 haawa. All rights reserved.
//

import Foundation

public struct SRSLevelInfo {
  
  struct DictionaryKey {
    static let radicals = "radicals"
    static let kanji = "kanji"
    static let vocabulary = "onyomi"
    static let total = "kunyomi"
  }
  
  public let radicals: Int
  public let kanji: Int
  public let vocabulary: Int
  public let total: Int
  
  public init(radicals: Int, kanji: Int, vocabulary: Int, total: Int? = nil) {
    self.radicals = radicals
    self.kanji = kanji
    self.vocabulary = vocabulary
    self.total = total ?? (radicals + kanji + vocabulary)
  }
}

extension SRSLevelInfo {
  
  public init(dict: [String : AnyObject]) {
    let radicals = dict[DictionaryKey.radicals] as? Int ?? 0
    let kanji = dict[DictionaryKey.kanji] as? Int ?? 0
    let vocabulary = dict[DictionaryKey.vocabulary] as? Int ?? 0
    let total = dict[DictionaryKey.total] as? Int
    self.init(radicals: radicals, kanji: kanji, vocabulary: vocabulary, total: total)
  }
}
