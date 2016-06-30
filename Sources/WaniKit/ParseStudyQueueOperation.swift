//
//  ParseStudyQueue.swift
//  Pods
//
//  Created by Andriy K. on 12/10/15.
//
//

import Foundation

public typealias StudyQueueResponse = (userInfo: UserInfo?, studyQInfo: StudyQueueInfo?)
public typealias StudyQueueRecieveBlock = (Result<StudyQueueResponse, NSError>) -> Void


public class ParseStudyQueueAppleOperation: ParseAppleOperation<StudyQueueResponse> {
  
  override init(cacheFile: URL, handler: ResponseHandler) {
    super.init(cacheFile: cacheFile, handler: handler)
    name = "Parse LevelProgression"
  }
  
  override func parsedValue(_ rootDictionary: NSDictionary?) -> StudyQueueResponse? {
    
    var user: UserInfo?
    var studyQ: StudyQueueInfo?
    if let userInfo = rootDictionary?[WaniKitConstants.ResponseKeys.UserInfoKey] as? NSDictionary {
      user = UserInfo(dict: userInfo)
    }
    if let studyQInfo = rootDictionary?[WaniKitConstants.ResponseKeys.RequestedInfoKey] as? NSDictionary {
      studyQ = StudyQueueInfo(dict: studyQInfo)
    }
    
    return (user, studyQ)
  }
}
