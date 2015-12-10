//
//  ParseStudyQueue.swift
//  Pods
//
//  Created by Andriy K. on 12/10/15.
//
//

import UIKit

public typealias UserInfoRecieveBlock = (userInfo: UserInfo?) -> Void

public class ParseStudyQueueOperation: Operation {
  
  private let cacheFile: NSURL
  private var handler: UserInfoRecieveBlock
  
  public init(cacheFile: NSURL, handler: UserInfoRecieveBlock ) {
    self.cacheFile = cacheFile
    self.handler = handler
    super.init()
    name = "Parse StudyQueue"
  }
  
  override func execute() {
    guard let stream = NSInputStream(URL: cacheFile) else {
      finish()
      return
    }
    stream.open()
    
    defer {
      stream.close()
    }
    
    do {
      let json = try NSJSONSerialization.JSONObjectWithStream(stream, options: []) as? [String: AnyObject]
    
      if let userInfo = json?[WaniApiManagerConstants.ResponseKeys.UserInfoKey] as? NSDictionary {
        let user = UserInfo(dict: userInfo)
        handler(userInfo: user)
      }
      else {
        finish()
      }
    }
    catch let jsonError as NSError {
      finishWithError(jsonError)
    }
  }
  
}
