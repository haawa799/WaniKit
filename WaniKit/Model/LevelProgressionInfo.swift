//
//  LevelProgressionInfo.swift
//  Pods
//
//  Created by Andriy K. on 12/10/15.
//
//

import Foundation

public struct LevelProgressionInfo {
  
  
  struct DictionaryKey {
    static let radicalsProgress = "radicals_progress"
    static let radicalsTotal = "radicals_total"
    static let kanjiProgress = "kanji_progress"
    static let kanjiTotal = "kanji_total"
  }
  
  public var radicalsProgress: Int?
  public var radicalsTotal: Int?
  public var kanjiProgress: Int?
  public var kanjiTotal: Int?
  
}

public extension LevelProgressionInfo {
  
  public init(dict: [String : AnyObject]) {
    radicalsProgress = (dict[DictionaryKey.radicalsProgress] as? Int)
    radicalsTotal = (dict[DictionaryKey.radicalsTotal] as? Int)
    kanjiProgress = (dict[DictionaryKey.kanjiProgress] as? Int)
    kanjiTotal = (dict[DictionaryKey.kanjiTotal] as? Int)
  }
  
}
