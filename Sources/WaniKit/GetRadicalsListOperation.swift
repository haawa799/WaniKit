//
//  GetUserInfoAppleOperation.swift
//  Pods
//
//  Created by Andriy K. on 12/14/15.
//
//

import Foundation


public class GetRadicalsListAppleOperation: GroupAppleOperation {
  
  let downloadAppleOperation: DownloadRadicalsListAppleOperation
  let parseAppleOperation: ParseRadicalsListAppleOperation
  
  init(baseURL: String, level: Int, cacheFilePrefix: String?, handler: RadicalsListResponseHandler) {
    
    let cachesFolder = try! FileManager.default.urlForDirectory(.cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
    let cacheFile = try! cachesFolder.appendingPathComponent("\(cacheFilePrefix)_radicalsList_\(level).json")
    
    let url = URL(string: "\(baseURL)/radicals/\(level)")!
    downloadAppleOperation = DownloadRadicalsListAppleOperation(url: url, cacheFile: cacheFile)
    parseAppleOperation = ParseRadicalsListAppleOperation(cacheFile: cacheFile, handler: handler)
    parseAppleOperation.addDependency(downloadAppleOperation)
    
    super.init(operations: [downloadAppleOperation, parseAppleOperation])
    name = "Get Radicals List"
  }
  
  override func execute() {
    super.execute()
    finish()
  }
  
}
