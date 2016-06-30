//
//  DownloadUserInfoAppleOperation.swift
//  Pods
//
//  Created by Andriy K. on 12/14/15.
//
//


import Foundation

public class DownloadUserInfoAppleOperation: DownloadAppleOperation {
  
  typealias ErrorHandler = (errors: [NSError]) -> Void
  
  var errorHandler: ErrorHandler?
  
  override init(url: URL, cacheFile: URL) {
    super.init(url: url, cacheFile: cacheFile)
    name = "Download User info data"
  }
  
  override func finished(_ errors: [NSError]) {
    super.finished(errors)
    errorHandler?(errors: errors)
  }
  
}
