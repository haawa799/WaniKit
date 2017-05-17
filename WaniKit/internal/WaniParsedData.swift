//
//  WaniParsedData.swift
//  WaniKani
//
//  Created by Andriy K. on 3/17/17.
//  Copyright © 2017 haawa. All rights reserved.
//

import Foundation

internal struct WaniParsedData {

  enum RequestedInfo {
    case array(items: [[String: Any]])
    case dictionary(dict: [String: Any])

    init?(value: Any) {
      switch value {
      case let array as [[String: Any]]: self = .array(items: array)
      case let dict as [String: Any]: self = .dictionary(dict: dict)
      default: return nil
      }
    }
  }

  let userInfoDictionary: [String: Any]
  let requestedInfo: RequestedInfo

  init(root: [String : Any]) throws {
    if let errorDict = root[Key.error] as? [String: Any] {
        if let errorCode = errorDict[Key.code] as? String {
          switch errorCode {
            case ErrorCode.userNotFound: throw ParsingError.apiKeyProblem
            default: break
          }
        }
    }
    guard let userDict = root[Key.userInfo] as? [String: Any] else { throw ParsingError.noUserInfo }
    guard let requestedInfoValue = root[Key.requestedInfo] else { throw ParsingError.noRequestedInfo }
    guard let requestedInfo = RequestedInfo(value: requestedInfoValue) else { throw ParsingError.requestedInfoNotCorrect }
    self.userInfoDictionary = userDict
    self.requestedInfo = requestedInfo
  }
}

extension WaniParsedData {
  struct Key {
    static let userInfo = "user_information"
    static let requestedInfo = "requested_information"
    static let error = "error"
    static let code = "code"
  }
  struct ErrorCode {
    static let userNotFound = "user_not_found"
  }
}
