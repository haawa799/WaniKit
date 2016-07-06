//
//  GetUserInfoAppleOperation.swift
//  Pods
//
//  Created by Andriy K. on 12/14/15.
//
//

import Foundation


public class GetUserInfoAppleOperation: GroupAppleOperation {
  
  let downloadAppleOperation: DownloadUserInfoAppleOperation
  let parseAppleOperation: ParseUserInfoAppleOperation
  
  init(baseURL: String, cacheFilePrefix: String?, handler: UserInfoResponseHandler) {
    
    let cachesFolder = try! FileManager.default.urlForDirectory(.cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
    let cacheFile = try! cachesFolder.appendingPathComponent("\(cacheFilePrefix)_userInfo.json")
    
    
    let url = URL(string: "\(baseURL)/user-information")!
    downloadAppleOperation = DownloadUserInfoAppleOperation(url: url, cacheFile: cacheFile)
    parseAppleOperation = ParseUserInfoAppleOperation(cacheFile: cacheFile, handler: handler)
    parseAppleOperation.addDependency(downloadAppleOperation)
    
    super.init(operations: [downloadAppleOperation, parseAppleOperation])
    name = "Get User info"
  }
  
  override func execute() {
    super.execute()
    finish()
  }
  
}
