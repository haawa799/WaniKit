/*
Copyright (C) 2015 Apple Inc. All Rights Reserved.
See LICENSE.txt for this sample’s licensing information

Abstract:
This file contains an NSOperationQueue subclass.
*/

import Foundation

/**
    The delegate of an `AppleAppleOperationQueue` can respond to `AppleOperation` lifecycle
    events by implementing these methods.

    In general, implementing `AppleAppleOperationQueueDelegate` is not necessary; you would
    want to use an `AppleOperationObserver` instead. However, there are a couple of
    situations where using `AppleAppleOperationQueueDelegate` can lead to simpler code.
    For example, `GroupAppleOperation` is the delegate of its own internal
    `AppleAppleOperationQueue` and uses it to manage dependencies.
*/
@objc protocol AppleAppleOperationQueueDelegate: NSObjectProtocol {
    @objc optional func operationQueue(_ operationQueue: AppleAppleOperationQueue, willAddAppleOperation operation: Operation)
    @objc optional func operationQueue(_ operationQueue: AppleAppleOperationQueue, operationDidFinish operation: Operation, withErrors errors: [NSError])
}

/**
    `AppleAppleOperationQueue` is an `NSOperationQueue` subclass that implements a large
    number of "extra features" related to the `AppleOperation` class:
    
    - Notifying a delegate of all operation completion
    - Extracting generated dependencies from operation conditions
    - Setting up dependencies to enforce mutual exclusivity
*/
public class AppleAppleOperationQueue: OperationQueue {
    weak var delegate: AppleAppleOperationQueueDelegate?
    
    override public func addOperation(_ operation: Operation) {
        if let op = operation as? AppleOperation {
            // Set up a `BlockObserver` to invoke the `AppleAppleOperationQueueDelegate` method.
            let delegate = BlockObserver(
                startHandler: nil,
                produceHandler: { [weak self] in
                    self?.addOperation($1)
                },
                finishHandler: { [weak self] in
                    if let q = self {
                        q.delegate?.operationQueue?(q, operationDidFinish: $0, withErrors: $1)
                    }
                }
            )
            op.addObserver(delegate)
            
            // Extract any dependencies needed by this operation.
            let dependencies = op.conditions.flatMap {
                $0.dependencyForAppleOperation(op)
            }
                
            for dependency in dependencies {
                op.addDependency(dependency)

                self.addOperation(dependency)
            }
            
            /*
                With condition dependencies added, we can now see if this needs
                dependencies to enforce mutual exclusivity.
            */
            let concurrencyCategories: [String] = op.conditions.flatMap { condition in
                if !condition.dynamicType.isMutuallyExclusive { return nil }
                
                return "\(condition.dynamicType)"
            }

            if !concurrencyCategories.isEmpty {
                // Set up the mutual exclusivity dependencies.
                let exclusivityController = ExclusivityController.sharedExclusivityController

                exclusivityController.addOperation(op, categories: concurrencyCategories)
                
                op.addObserver(BlockObserver { operation, _ in
                    exclusivityController.removeAppleOperation(operation, categories: concurrencyCategories)
                })
            }
            
            /*
                Indicate to the operation that we've finished our extra work on it
                and it's now it a state where it can proceed with evaluating conditions,
                if appropriate.
            */
            op.willEnqueue()
        }
        else {
            /*
                For regular `NSOperation`s, we'll manually call out to the queue's
                delegate we don't want to just capture "operation" because that
                would lead to the operation strongly referencing itself and that's
                the pure definition of a memory leak.
            */
            operation.addCompletionBlock { [weak self, weak operation] in
                guard let queue = self, let operation = operation else { return }
                queue.delegate?.operationQueue?(queue, operationDidFinish: operation, withErrors: [])
            }
        }
        
        delegate?.operationQueue?(self, willAddAppleOperation: operation)
        super.addOperation(operation)
    }
    
    override public func addOperations(_ operations: [Operation], waitUntilFinished wait: Bool) {
        /*
            The base implementation of this method does not call `addOperation()`,
            so we'll call it ourselves.
        */
        for operation in operations {
            addOperation(operation)
        }
        
        if wait {
            for operation in operations {
              operation.waitUntilFinished()
            }
        }
    }
}
