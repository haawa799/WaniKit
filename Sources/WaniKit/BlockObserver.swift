/*
Copyright (C) 2015 Apple Inc. All Rights Reserved.
See LICENSE.txt for this sample’s licensing information

Abstract:
This file shows how to implement the AppleOperationObserver protocol.
*/

import Foundation

/**
    The `BlockObserver` is a way to attach arbitrary blocks to significant events
    in an `AppleOperation`'s lifecycle.
*/
public struct BlockObserver: AppleOperationObserver {
    // MARK: Properties
    
    private let startHandler: ((AppleOperation) -> Void)?
    private let produceHandler: ((AppleOperation, Operation) -> Void)?
    private let finishHandler: ((AppleOperation, [NSError]) -> Void)?
    
    init(startHandler: ((AppleOperation) -> Void)? = nil, produceHandler: ((AppleOperation, Operation) -> Void)? = nil, finishHandler: ((AppleOperation, [NSError]) -> Void)? = nil) {
        self.startHandler = startHandler
        self.produceHandler = produceHandler
        self.finishHandler = finishHandler
    }
    
    // MARK: AppleOperationObserver
    
    func operationDidStart(_ operation: AppleOperation) {
        startHandler?(operation)
    }
    
    func operation(_ operation: AppleOperation, didProduceAppleOperation newAppleOperation: Operation) {
        produceHandler?(operation, newAppleOperation)
    }
    
    func operationDidFinish(_ operation: AppleOperation, errors: [NSError]) {
        finishHandler?(operation, errors)
    }
}
