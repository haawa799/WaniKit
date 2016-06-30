//
//  GetUserInfoAppleOperation.swift
//  Pods
//
//  Created by Andriy K. on 12/14/15.
//
//

import Foundation


public class GetVocabListAppleOperation: GroupAppleOperation {
  
  let downloadAppleOperation: DownloadVocabListAppleOperation
  let parseAppleOperation: ParseVocabListAppleOperation
  
  init(baseURL: String, level: Int, cacheFilePrefix: String?, handler: VocabListResponseHandler) {
    
    let cachesFolder = try! FileManager.default().urlForDirectory(.cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
    let cacheFile = try! cachesFolder.appendingPathComponent("\(cacheFilePrefix)_vocabList_\(level).json")
    
    let url = URL(string: "\(baseURL)/vocabulary/\(level)")!
    downloadAppleOperation = DownloadVocabListAppleOperation(url: url, cacheFile: cacheFile)
    parseAppleOperation = ParseVocabListAppleOperation(cacheFile: cacheFile, handler: handler)
    parseAppleOperation.addDependency(downloadAppleOperation)
    
    super.init(operations: [downloadAppleOperation, parseAppleOperation])
    name = "Get Vocab List"
  }
  
  override func execute() {
    super.execute()
    finish()
  }
  
}
