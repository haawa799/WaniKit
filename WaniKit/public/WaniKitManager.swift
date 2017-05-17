//
//  WaniKitManager.swift
//  WaniKani
//
//  Created by Andriy K. on 3/17/17.
//  Copyright © 2017 haawa. All rights reserved.
//

import Foundation

public protocol WaniKitManagerDelegate: class {
    func apiKeyIncorect()
}

public class WaniKitManager {

  public let apiKey: String
  public weak var delegate: WaniKitManagerDelegate?
    
  public init(apiKey: String) {
    self.apiKey = apiKey
  }
}
