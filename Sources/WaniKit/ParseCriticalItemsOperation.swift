//
//  ParseUserInfoAppleOperation.swift
//  Pods
//
//  Created by Andriy K. on 12/14/15.
//
//

import Foundation


public typealias CriticalItemsResponse = (userInfo: UserInfo?, criticalItems: CriticalItems?)
public typealias CriticalItemsResponseHandler = (Result<CriticalItemsResponse, NSError>) -> Void

public class ParseCriticalItemsAppleOperation: ParseAppleOperation<CriticalItemsResponse> {
  
  override init(cacheFile: URL, handler: ResponseHandler) {
    super.init(cacheFile: cacheFile, handler: handler)
    name = "Parse Critical items list"
  }
  
  override func parsedValue(_ rootDictionary: NSDictionary?) -> CriticalItemsResponse? {
    
    var user: UserInfo?
    if let userInfo = rootDictionary?[WaniKitConstants.ResponseKeys.UserInfoKey] as? NSDictionary {
      user = UserInfo(dict: userInfo)
    }
    
    var criticalItems: CriticalItems?
    if let requestedInfo = rootDictionary?[WaniKitConstants.ResponseKeys.RequestedInfoKey] as? NSArray {
      criticalItems = CriticalItems(array: requestedInfo)
    }
    
    return (user, criticalItems)
  }
  
}
