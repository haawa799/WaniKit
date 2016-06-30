/*
Copyright (C) 2015 Apple Inc. All Rights Reserved.
See LICENSE.txt for this sample’s licensing information

Abstract:
This file defines the AppleOperationObserver protocol.
*/

import Foundation

/**
    The protocol that types may implement if they wish to be notified of significant
    operation lifecycle events.
*/
protocol AppleOperationObserver {
    
    /// Invoked immediately prior to the `AppleOperation`'s `execute()` method.
    func operationDidStart(_ operation: AppleOperation)
    
    /// Invoked when `AppleOperation.produceAppleOperation(_:)` is executed.
    func operation(_ operation: AppleOperation, didProduceAppleOperation newAppleOperation: Operation)
    
    /**
        Invoked as an `AppleOperation` finishes, along with any errors produced during
        execution (or readiness evaluation).
    */
    func operationDidFinish(_ operation: AppleOperation, errors: [NSError])
    
}
