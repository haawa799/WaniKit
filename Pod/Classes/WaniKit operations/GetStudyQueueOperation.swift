//
//  GetStudyQueue.swift
//  Pods
//
//  Created by Andriy K. on 12/10/15.
//
//

import UIKit

public class GetStudyQueueOperation: GroupOperation {
  
  let downloadOperation: DownloadStudyQueueOperation
  let parseOperation: ParseStudyQueueOperation
  
  init(apiKey: String, handler: UserInfoRecieveBlock) {
    
    let cachesFolder = try! NSFileManager.defaultManager().URLForDirectory(.CachesDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: true)
    let cacheFile = cachesFolder.URLByAppendingPathComponent("studyQueue.json")
    
    downloadOperation = DownloadStudyQueueOperation(apiKey: apiKey, cacheFile: cacheFile)
    parseOperation = ParseStudyQueueOperation(cacheFile: cacheFile, handler: handler)
    
    super.init(operations: [downloadOperation, parseOperation])
    name = "Get Study Queue"
  }
  
}
