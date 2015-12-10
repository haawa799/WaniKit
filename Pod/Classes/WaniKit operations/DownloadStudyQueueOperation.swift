//
//  StudyQueueOperation.swift
//  Pods
//
//  Created by Andriy K. on 12/10/15.
//
//

import UIKit

public class DownloadStudyQueueOperation: GroupOperation {
  
  public private(set) var responseDictionary: NSDictionary?
  
  let cacheFile: NSURL
  
  init(apiKey: String, cacheFile: NSURL) {
    
    self.cacheFile = cacheFile
    
    super.init(operations: [])
    name = "Download Study Queue data"
    //
    
    let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
    let session = NSURLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
    let url = NSURL(string: "\(WaniApiManagerConstants.URL.BaseURL)/user/\(apiKey)/study-queue")!
    let request = NSMutableURLRequest(URL: url)
    request.HTTPMethod = "GET"
    
    let task = session.downloadTaskWithRequest(request) { (url, response, error) -> Void in
      self.downloadFinished(url, response: response, error: error)
    }
    
    let taskOperation = URLSessionTaskOperation(task: task)
    let reachabilityCondition = ReachabilityCondition(host: url)
    taskOperation.addCondition(reachabilityCondition)
    
    let networkObserver = NetworkObserver()
    taskOperation.addObserver(networkObserver)
    
    addOperation(taskOperation)
  }
  
  func downloadFinished(url: NSURL?, response: NSURLResponse?, error: NSError?) {
    if let localURL = url {
      do {
        try NSFileManager.defaultManager().removeItemAtURL(cacheFile)
      }
      catch { }
      
      do {
        try NSFileManager.defaultManager().moveItemAtURL(localURL, toURL: cacheFile)
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
