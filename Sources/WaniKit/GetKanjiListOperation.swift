//
//  GetUserInfoAppleOperation.swift
//  Pods
//
//  Created by Andriy K. on 12/14/15.
//
//

import Foundation


public class GetKanjiListAppleOperation: GroupAppleOperation {
  
  let downloadAppleOperation: DownloadKanjiListAppleOperation
  let parseAppleOperation: ParseKanjiListAppleOperation
  
  init(baseURL: String, level: Int, cacheFilePrefix: String?, handler: KanjiListResponseHandler) {
    
    let cachesFolder = try! FileManager.default.urlForDirectory(.cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
    let cacheFile = try! cachesFolder.appendingPathComponent("\(cacheFilePrefix)_kanjiList_\(level).json")
    
    let url = URL(string: "\(baseURL)/kanji/\(level)")!
    downloadAppleOperation = DownloadKanjiListAppleOperation(url: url, cacheFile: cacheFile)
    parseAppleOperation = ParseKanjiListAppleOperation(cacheFile: cacheFile, handler: handler)
    parseAppleOperation.addDependency(downloadAppleOperation)
    
    super.init(operations: [downloadAppleOperation, parseAppleOperation])
    name = "Get Kanji List"
  }
  
  override func execute() {
    super.execute()
    finish()
  }
  
}
