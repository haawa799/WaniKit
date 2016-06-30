/*
Copyright (C) 2015 Apple Inc. All Rights Reserved.
See LICENSE.txt for this sample’s licensing information

Abstract:
This file defines the error codes and convenience functions for interacting with AppleOperation-related errors.
*/

import Foundation

let AppleOperationErrorDomain = "AppleOperationErrors"

enum AppleOperationErrorCode: Int {
    case conditionFailed = 1
    case executionFailed = 2
}

extension NSError {
    convenience init(code: AppleOperationErrorCode, userInfo: [NSObject: AnyObject]? = nil) {
        self.init(domain: AppleOperationErrorDomain, code: code.rawValue, userInfo: userInfo)
    }
}

// This makes it easy to compare an `NSError.code` to an `AppleOperationErrorCode`.
func ==(lhs: Int, rhs: AppleOperationErrorCode) -> Bool {
    return lhs == rhs.rawValue
}

func ==(lhs: AppleOperationErrorCode, rhs: Int) -> Bool {
    return lhs.rawValue == rhs
}
