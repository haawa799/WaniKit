//
//  WaniAPIManager.swift
//  Pods
//
//  Created by Andriy K. on 12/10/15.
//
//

import UIKit

// MARK: - Constants
public struct WaniApiManagerConstants {
  public struct NotificationKey {
    public static let NoApiKey = "NoApiKeyNotification"
  }
  public struct URL {
    public static let BaseURL = "https://www.wanikani.com/api"
  }
  public struct NSUserDefaultsKeys {
    public static let WaniKaniApiKey = "WaniAPIManagerKey"
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
  
  let operationQueue = OperationQueue()
  
  // MARK: - Singltone
  
  public static func sharedInstance() -> WaniApiManager {
    return instance
  }
  
  // MARK: - Public API
  
  public func setApiKey(key: String?) {
    myKey = key
  }
  
  public func fetchStudyQueue(handler:(UserInfo) -> ()) throws {
    internalFetchStudyQueue { (user) -> () in

    }
  }
  
  public func apiKey() -> String? {
    return myKey
  }
  
  // MARK: Private
  
  private static let instance = WaniApiManager()
  private var myKey: String?
  
  private func internalFetchStudyQueue(handler:(UserInfo?) throws -> ()) {
    
    let op = GetStudyQueueOperation(apiKey: myKey!) { (userInfo) -> Void in
      print("HI")
      print(userInfo)
    }
    op.userInitiated = true
    operationQueue.addOperation(op)
  }
  
  
  private override init() {
    super.init()
  }
  
}
