//
//  DownloadLevelProgressionAppleOperation.swift
//  Pods
//
//  Created by Andriy K. on 12/10/15.
//
//

import Foundation

public class DownloadLevelProgressionAppleOperation: DownloadAppleOperation {
  
  override init(url: URL, cacheFile: URL) {
    
    super.init(url: url, cacheFile: cacheFile)
    name = "Download Level Progression data"
  }
  
}
