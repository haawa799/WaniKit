// Copyright (c) 2016 Lebara. All rights reserved.
// Author:  Andrew Kharchyshyn <akharchyshyn@gmail.com>

import Foundation
import WaniModel


public class ParseLevelProgressionOperation: ParseOperation<LevelProgressionInfo> {
  
  static let key = "requested_information"
  
  override func parsedValue(rootDictionary: [[String: AnyObject]]) -> LevelProgressionInfo? {
    guard let root = rootDictionary.first else { return nil}
    guard let levelProgressionDict = root[ParseLevelProgressionOperation.key] as? [String : AnyObject] else { return nil }
    let levelProgression = LevelProgressionInfo(dict: levelProgressionDict)
    return levelProgression
  }
  
}
