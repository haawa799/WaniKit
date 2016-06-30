//
//  ParseLevelProgressionAppleOperation.swift
//  Pods
//
//  Created by Andriy K. on 12/10/15.
//
//

import Foundation

public typealias LevelProgressionResponse = (userInfo: UserInfo?, levelProgression: LevelProgressionInfo?)
public typealias LevelProgressionRecieveBlock = (Result<LevelProgressionResponse, NSError>) -> Void


public class ParseLevelProgressionAppleOperation: ParseAppleOperation<LevelProgressionResponse> {
  
  override init(cacheFile: URL, handler: ResponseHandler) {
    super.init(cacheFile: cacheFile, handler: handler)
    name = "Parse LevelProgression"
  }
  
  override func parsedValue(_ rootDictionary: NSDictionary?) -> LevelProgressionResponse? {
    
    var user: UserInfo?
    var levelProgress: LevelProgressionInfo?
    if let userInfo = rootDictionary?[WaniKitConstants.ResponseKeys.UserInfoKey] as? NSDictionary {
      user = UserInfo(dict: userInfo)
    }
    if let levelProgInfo = rootDictionary?[WaniKitConstants.ResponseKeys.RequestedInfoKey] as? NSDictionary {
      levelProgress = LevelProgressionInfo(dict: levelProgInfo)
    }
    
    return (user, levelProgress)
  }
}
