//
//  ParseUserInfoAppleOperation.swift
//  Pods
//
//  Created by Andriy K. on 12/14/15.
//
//

import Foundation


public typealias UserInfoResponse = (UserInfo?)
public typealias UserInfoResponseHandler = (Result<UserInfoResponse, NSError>) -> Void

public class ParseUserInfoAppleOperation: ParseAppleOperation<UserInfoResponse> {
  
  override init(cacheFile: URL, handler: ResponseHandler) {
    super.init(cacheFile: cacheFile, handler: handler)
    name = "Parse User info"
  }
  
  override func parsedValue(_ rootDictionary: NSDictionary?) -> UserInfoResponse? {
    var user: UserInfo?
    if let userInfo = rootDictionary?[WaniKitConstants.ResponseKeys.UserInfoKey] as? NSDictionary {
      user = UserInfo(dict: userInfo)
    }
    return user
  }
  
}
