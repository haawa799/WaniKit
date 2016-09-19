//
//  KanjiInfo.swift
//  Pods
//
//  Created by Andriy K. on 12/27/15.
//
//

import Foundation

public struct KanjiInfo {
  
  struct DictionaryKey {
    static let character = "character"
    static let meaning = "meaning"
    static let onyomi = "onyomi"
    static let kunyomi = "kunyomi"
    static let nanori = "nanori"
    static let importantReading = "important_reading"
    static let level = "level"
    static let userSpecific = "user_specific"
    static let percentage = "percentage"
    static let unlockedDate = "unlocked_date"
  }
  
  public var character: String
  public var meaning: String?
  public var onyomi: String?
  public var kunyomi: String?
  public var nanori: String?
  public var importantReading: String?
  public var level: Int
  public var percentage: String?
  public var unlockedDate: Date?
  public var userSpecific: UserSpecific?
  
  public var reading: String? {
    guard let importantReading = importantReading else { return nil }
    switch importantReading {
    case "kunyomi": return kunyomi
    case "onyomi": return onyomi
    case "nanori": return nanori
    default: return nil
    }
  }
}

extension KanjiInfo {
  
  public init(dict: [String : AnyObject]) {
    character = dict[KanjiInfo.DictionaryKey.character] as! String
    meaning = dict[KanjiInfo.DictionaryKey.meaning] as? String
    onyomi = dict[KanjiInfo.DictionaryKey.onyomi] as? String
    kunyomi = dict[KanjiInfo.DictionaryKey.kunyomi] as? String
    nanori = dict[KanjiInfo.DictionaryKey.nanori] as? String
    importantReading = dict[KanjiInfo.DictionaryKey.importantReading] as? String
    level = dict[KanjiInfo.DictionaryKey.level] as! Int
    percentage = dict[DictionaryKey.percentage] as? String
    if let unlockedDateInt = dict[DictionaryKey.unlockedDate] as? Int {
      unlockedDate = Date(timeIntervalSince1970: TimeInterval(unlockedDateInt))
    }
    if let userSpecificDict = dict[DictionaryKey.userSpecific] as? [String : AnyObject] {
      userSpecific = UserSpecific(dict: userSpecificDict)
      unlockedDate = userSpecific?.unlockedDate
    }
  }
}
