//
//  DownloadAppleOperation.swift
//  Pods
//
//  Created by Andriy K. on 12/10/15.
//
//

import Foundation

public enum Result<T, U> {
  case response(() -> T)
  case error(() -> U)
}

public class DownloadAppleOperation: GroupAppleOperation {
  
  let cacheFile: URL
  
  init(url: URL, cacheFile: URL) {
    
    print(url)
    self.cacheFile = cacheFile
    
    super.init(operations: [])
    name = "Download AppleOperation"
    //
    
    let sessionConfig = URLSessionConfiguration.default()
    let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    
    let task = session.downloadTask(with: request) { (url, response, error) -> Void in
      self.downloadFinished(url, response: response, error: error)
    }
    
    let taskAppleOperation = URLSessionTaskAppleOperation(task: task)
    let reachabilityCondition = ReachabilityCondition(host: url)
    taskAppleOperation.addCondition(reachabilityCondition)
    
    let networkObserver = NetworkObserver()
    taskAppleOperation.addObserver(networkObserver)
    
    addOperation(taskAppleOperation)
  }
  
  func downloadFinished(_ url: URL?, response: URLResponse?, error: NSError?) {
    
    if let localURL = url {
      do {
        try FileManager.default().removeItem(at: cacheFile)
      }
      catch { }
      
      do {
        try FileManager.default().moveItem(at: localURL, to: cacheFile)
      }
      catch let error as NSError {
        aggregateError(error)
      }
      
    }
    else if let error = error {
      aggregateError(error)
    }
    else {
      // Do nothing, and the operation will automatically finish.
    }
  }
  
}
