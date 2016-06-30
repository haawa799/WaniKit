//
//  GetLevelProgressionAppleOperation.swift
//  Pods
//
//  Created by Andriy K. on 12/10/15.
//
//

import Foundation

public class GetLevelProgressionAppleOperation: GroupAppleOperation {
  
  let downloadAppleOperation: DownloadLevelProgressionAppleOperation
  let parseAppleOperation: ParseLevelProgressionAppleOperation
  
  init(baseURL: String, cacheFilePrefix: String?, handler: LevelProgressionRecieveBlock) {
    
    let cachesFolder = try! FileManager.default().urlForDirectory(.cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
    let cacheFile = try! cachesFolder.appendingPathComponent("\(cacheFilePrefix)_levelProgress.json")
    
    
    let url = URL(string: "\(baseURL)/level-progression")!
    downloadAppleOperation = DownloadLevelProgressionAppleOperation(url: url, cacheFile: cacheFile)
    parseAppleOperation = ParseLevelProgressionAppleOperation(cacheFile: cacheFile, handler: handler)
    parseAppleOperation.addDependency(downloadAppleOperation)
    
    super.init(operations: [downloadAppleOperation, parseAppleOperation])
    name = "Get Level progression"
  }
  
  override func execute() {
    super.execute()
    finish()
  }
  
}
