//
//  ParseOpertion.swift
//  Pods
//
//  Created by Andriy K. on 12/27/15.
//
//

import Foundation


public class ParseAppleOperation <T> : AppleOperation {
  
  public typealias ResponseHandler = (Result<T, NSError>) -> Void
  
  private let cacheFile: URL
  private var handler: ResponseHandler
  
  public init(cacheFile: URL, handler: ResponseHandler ) {
    self.cacheFile = cacheFile
    self.handler = handler
    super.init()
  }
  
  override func execute() {
    
    func throwAnError() {
      let error = NSError(domain: "Error reading data", code: 0, userInfo: nil)
      handler(Result.error({error}))
      finish()
    }
    
    
    guard let stream = InputStream(url: cacheFile) else {
      throwAnError()
      return
    }
    stream.open()
    
    defer {
      stream.close()
    }
    
    do {
      let json = try JSONSerialization.jsonObject(with: stream, options: []) as? NSDictionary
      
      if let parsedResult = parsedValue(json) {
        handler(Result.response({parsedResult}))
        finish()
      } else {
        throwAnError()
      }
    }
    catch _ {
      throwAnError()
    }
  }
  
  func parsedValue(_ rootDictionary: NSDictionary?) -> T? {
    return nil
  }
  
}
