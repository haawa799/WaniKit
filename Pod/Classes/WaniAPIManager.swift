//
//  WaniAPIManager.swift
//  Pods
//
//  Created by Andriy K. on 12/10/15.
//
//

import UIKit

// MARK: - Constants
public struct WaniKitConstants {
  public struct URL {
    public static let BaseURL = "https://www.wanikani.com/api"
  }
  public struct ResponseKeys {
    public static let UserInfoKey = "user_information"
    public static let RequestedInfoKey = "requested_information"
  }
}

public enum WaniApiError: ErrorType {
  case ServerError
  case ObjectSereliazationError
}

public class WaniApiManager: NSObject {
  
  public private(set) var getStudyQueueOperation: GetStudyQueueOperation?
  public private(set) var getLevelProgressionOperation: GetLevelProgressionOperation?
  public private(set) var operationQueue: OperationQueue = {
    let q = OperationQueue()
    q.maxConcurrentOperationCount = 1
    return q
  }()
  
  // MARK: - Singltone
  
  public static func sharedInstance() -> WaniApiManager {
    return instance
  }
  
  // MARK: - Public API
  
  public func setApiKey(key: String?) {
    myKey = key
  }
  
  public func fetchStudyQueue(handler: StudyQueueRecieveBlock) {
    
    if (getStudyQueueOperation == nil) || (getStudyQueueOperation?.finished == true) {
      getStudyQueueOperation = GetStudyQueueOperation(apiKey: myKey!, handler: handler)
      getStudyQueueOperation?.userInitiated = true
      operationQueue.addOperation(getStudyQueueOperation!)
    }
  }
  
  public func fetchLevelProgression(handler: LevelProgressionRecieveBlock) {
    
    if (getLevelProgressionOperation == nil) || (getLevelProgressionOperation?.finished == true) {
      getLevelProgressionOperation = GetLevelProgressionOperation(apiKey: myKey!, handler: handler)
      getLevelProgressionOperation?.userInitiated = true
      operationQueue.addOperation(getLevelProgressionOperation!)
    }
  }
  
  public func apiKey() -> String? {
    return myKey
  }
  
  // MARK: Private
  
  private static let instance = WaniApiManager()
  private var myKey: String?
  
  
  private override init() {
    super.init()
  }
  
}
