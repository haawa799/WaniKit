/*
Copyright (C) 2015 Apple Inc. All Rights Reserved.
See LICENSE.txt for this sample’s licensing information

Abstract:
This file shows how to implement the AppleOperationObserver protocol.
*/

import Foundation

/**
    `TimeoutObserver` is a way to make an `AppleOperation` automatically time out and
    cancel after a specified time interval.
*/
public struct TimeoutObserver: AppleOperationObserver {
    // MARK: Properties

    static let timeoutKey = "Timeout"
    
    private let timeout: TimeInterval
    
    // MARK: Initialization
    
    init(timeout: TimeInterval) {
        self.timeout = timeout
    }
    
    // MARK: AppleOperationObserver
    
    func operationDidStart(_ operation: AppleOperation) {
        // When the operation starts, queue up a block to cause it to time out.
        DispatchQueue.global(attributes: DispatchQueue.GlobalAttributes.qosDefault).after(when: .now() + timeout) {
            /*
                Cancel the operation if it hasn't finished and hasn't already
                been cancelled.
            */
            if !operation.isFinished && !operation.isCancelled {
                let error = NSError(code: .executionFailed, userInfo: [
                    self.dynamicType.timeoutKey: self.timeout
                ])

                operation.cancelWithError(error)
            }
        }
    }

    func operation(_ operation: AppleOperation, didProduceAppleOperation newAppleOperation: Operation) {
        // No op.
    }

    func operationDidFinish(_ operation: AppleOperation, errors: [NSError]) {
        // No op.
    }
}
