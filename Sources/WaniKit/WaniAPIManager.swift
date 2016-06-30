//
//  WaniAPIManager.swift
//  Pods
//
//  Created by Andriy K. on 12/10/15.
//
//

import Foundation


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

public enum WaniApiError: ErrorProtocol {
  case serverError
  case objectSereliazationError
}

public protocol WaniApiManagerDelegate: class {
  func apiKeyWasUsedBeforeItWasSet()
  func apiKeyWasSet()
}

public class WaniApiManager {
  
  public var baseURL: String? {
    
    guard let apiKey = apiKey() else {
      return nil
    }
    return testBaseURL ?? "\(WaniKitConstants.URL.BaseURL)/user/\(apiKey)"
  }
  
  private var testBaseURL: String?
  private let identifier = UUID().uuidString
  
  public init(testBaseURL: String? = nil) {
    self.testBaseURL = testBaseURL
  }
  
  public weak var delegate: WaniApiManagerDelegate?
  
  public private(set) var getStudyQueueAppleOperation: GetStudyQueueAppleOperation?
  public private(set) var getLevelProgressionAppleOperation: GetLevelProgressionAppleOperation?
  public private(set) var getUserInfoAppleOperation: GetUserInfoAppleOperation?
  public private(set) var getKanjiListAppleOperation: GetKanjiListAppleOperation?
  public private(set) var getRadicalsListAppleOperation: GetRadicalsListAppleOperation?
  public private(set) var getVocabListAppleOperation: GetVocabListAppleOperation?
  public private(set) var getCriticalItemsAppleOperation: GetCriticalItemsAppleOperation?
  public private(set) var operationQueue: AppleAppleOperationQueue = {
    let q = AppleAppleOperationQueue()
    q.maxConcurrentOperationCount = 1
    return q
  }()
  
  // MARK: - Public API
  
  public func setApiKey(_ key: String?) {
    myKey = key
    if key != nil {
      delegate?.apiKeyWasSet()
    }
  }
  
  public func fetchStudyQueue(_ handler: StudyQueueRecieveBlock) {
    guard let baseURL = baseURL else {
      return
    }
    
    if (getStudyQueueAppleOperation == nil) || (getStudyQueueAppleOperation?.isFinished == true) {
      getStudyQueueAppleOperation = GetStudyQueueAppleOperation(baseURL: baseURL, cacheFilePrefix: identifier, handler: handler)
      getStudyQueueAppleOperation?.userInitiated = true
      operationQueue.addOperation(getStudyQueueAppleOperation!)
    }
  }
  
  public func fetchLevelProgression(_ handler: LevelProgressionRecieveBlock) {
    guard let baseURL = baseURL else {
      return
    }
    
    if (getLevelProgressionAppleOperation == nil) || (getLevelProgressionAppleOperation?.isFinished == true) {
      getLevelProgressionAppleOperation = GetLevelProgressionAppleOperation(baseURL: baseURL, cacheFilePrefix: identifier, handler: handler)
      getLevelProgressionAppleOperation?.userInitiated = true
      operationQueue.addOperation(getLevelProgressionAppleOperation!)
    }
  }
  
  public func fetchUserInfo(_ handler: UserInfoResponseHandler) {
    guard let baseURL = baseURL else {
      return
    }
    
    if (getUserInfoAppleOperation == nil) || (getUserInfoAppleOperation?.isFinished == true) {
      getUserInfoAppleOperation = GetUserInfoAppleOperation(baseURL: baseURL, cacheFilePrefix: identifier, handler: handler)
      getUserInfoAppleOperation?.userInitiated = true
      operationQueue.addOperation(getUserInfoAppleOperation!)
    }
  }
  
  public func fetchKanjiList(_ level: Int, handler: KanjiListResponseHandler) {
    guard let baseURL = baseURL else {
      return
    }
    
    if (getKanjiListAppleOperation == nil) || (getKanjiListAppleOperation?.isFinished == true) {
      getKanjiListAppleOperation = GetKanjiListAppleOperation(baseURL: baseURL, level: level, cacheFilePrefix: identifier, handler: handler)
      getKanjiListAppleOperation?.userInitiated = true
      operationQueue.addOperation(getKanjiListAppleOperation!)
    }
  }
  
  public func fetchRadicalsList(_ level: Int, handler: RadicalsListResponseHandler) {
    guard let baseURL = baseURL else {
      return
    }
    
    if (getRadicalsListAppleOperation == nil) || (getRadicalsListAppleOperation?.isFinished == true) {
      getRadicalsListAppleOperation = GetRadicalsListAppleOperation(baseURL: baseURL, level: level, cacheFilePrefix: identifier, handler: handler)
      getRadicalsListAppleOperation?.userInitiated = true
      operationQueue.addOperation(getRadicalsListAppleOperation!)
    }
  }
  
  public func fetchVocabList(_ level: Int, handler: VocabListResponseHandler) {
    guard let baseURL = baseURL else {
      return
    }
    
    if (getVocabListAppleOperation == nil) || (getVocabListAppleOperation?.isFinished == true) {
      getVocabListAppleOperation = GetVocabListAppleOperation(baseURL: baseURL, level: level, cacheFilePrefix: identifier, handler: handler)
      getVocabListAppleOperation?.userInitiated = true
      operationQueue.addOperation(getVocabListAppleOperation!)
    }
  }
  
  public func fetchCriticalItems(_ percentage: Int, handler: CriticalItemsResponseHandler) {
    guard let baseURL = baseURL else {
      return
    }
    
    if (getCriticalItemsAppleOperation == nil) || (getCriticalItemsAppleOperation?.isFinished == true) {
      getCriticalItemsAppleOperation = GetCriticalItemsAppleOperation(baseURL: baseURL, percentage: percentage, cacheFilePrefix: identifier, handler: handler)
      getCriticalItemsAppleOperation?.userInitiated = true
      operationQueue.addOperation(getCriticalItemsAppleOperation!)
    }
  }
  
  public func apiKey() -> String? {
    if myKey == nil {
      delegate?.apiKeyWasUsedBeforeItWasSet()
    }
    return myKey
  }
  
  // MARK: Private
  private var myKey: String?
  
}
