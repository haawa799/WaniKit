//
//  GetStudyQueue.swift
//  Pods
//
//  Created by Andriy K. on 12/10/15.
//
//

import Foundation

public class GetStudyQueueAppleOperation: GroupAppleOperation {
  
  let downloadAppleOperation: DownloadStudyQueueAppleOperation
  let parseAppleOperation: ParseStudyQueueAppleOperation
  
  init(baseURL: String, cacheFilePrefix: String?, handler: StudyQueueRecieveBlock) {
    
    let cachesFolder = try! FileManager.default().urlForDirectory(.cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
    let cacheFile = try! cachesFolder.appendingPathComponent("\(cacheFilePrefix)_studyQueue.json")
    
    
    let url = URL(string: "\(baseURL)/study-queue")!
    downloadAppleOperation = DownloadStudyQueueAppleOperation(url: url, cacheFile: cacheFile)
    parseAppleOperation = ParseStudyQueueAppleOperation(cacheFile: cacheFile, handler: handler)
    parseAppleOperation.addDependency(downloadAppleOperation)
    
    super.init(operations: [downloadAppleOperation, parseAppleOperation])
    name = "Get Study Queue"
  }
  
  override func execute() {
    super.execute()
    finish()
  }
  
}
