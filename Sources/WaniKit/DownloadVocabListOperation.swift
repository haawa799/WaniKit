//
//  DownloadUserInfoAppleOperation.swift
//  Pods
//
//  Created by Andriy K. on 12/14/15.
//
//


import Foundation

public class DownloadVocabListAppleOperation: DownloadAppleOperation {
  
  override init(url: URL, cacheFile: URL) {
    
    super.init(url: url, cacheFile: cacheFile)
    name = "Download Vocab info data"
  }
  
}
