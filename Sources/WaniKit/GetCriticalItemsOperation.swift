//
//  GetUserInfoAppleOperation.swift
//  Pods
//
//  Created by Andriy K. on 12/14/15.
//
//

import Foundation


public class GetCriticalItemsAppleOperation: GroupAppleOperation {
  
  let downloadAppleOperation: DownloadCriticalItemsAppleOperation
  let parseAppleOperation: ParseCriticalItemsAppleOperation
  
  init(baseURL: String, percentage: Int, cacheFilePrefix: String?, handler: CriticalItemsResponseHandler) {
    
    let cachesFolder = try! FileManager.default().urlForDirectory(.cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
    let cacheFile = try! cachesFolder.appendingPathComponent("\(cacheFilePrefix)_criticalItems_\(percentage).json")
    
    let url = URL(string: "\(baseURL)/critical-items/\(percentage)")!
    downloadAppleOperation = DownloadCriticalItemsAppleOperation(url: url, cacheFile: cacheFile)
    parseAppleOperation = ParseCriticalItemsAppleOperation(cacheFile: cacheFile, handler: handler)
    parseAppleOperation.addDependency(downloadAppleOperation)
    
    super.init(operations: [downloadAppleOperation, parseAppleOperation])
    name = "Get Critical items List"
  }
  
  override func execute() {
    super.execute()
    finish()
  }
  
}
