/*
Copyright (C) 2015 Apple Inc. All Rights Reserved.
See LICENSE.txt for this sample’s licensing information

Abstract:
This file contains the fundamental logic relating to AppleOperation conditions.
*/

import Foundation

let AppleOperationConditionKey = "AppleOperationCondition"

/**
    A protocol for defining conditions that must be satisfied in order for an
    operation to begin execution.
*/
public protocol AppleOperationCondition {
    /**
        The name of the condition. This is used in userInfo dictionaries of `.ConditionFailed`
        errors as the value of the `AppleOperationConditionKey` key.
    */
    static var name: String { get }
    
    /**
        Specifies whether multiple instances of the conditionalized operation may
        be executing simultaneously.
    */
    static var isMutuallyExclusive: Bool { get }
    
    /**
        Some conditions may have the ability to satisfy the condition if another
        operation is executed first. Use this method to return an operation that
        (for example) asks for permission to perform the operation
        
        - parameter operation: The `AppleOperation` to which the Condition has been added.
        - returns: An `NSOperation`, if a dependency should be automatically added. Otherwise, `nil`.
        - note: Only a single operation may be returned as a dependency. If you
            find that you need to return multiple operations, then you should be
            expressing that as multiple conditions. Alternatively, you could return
            a single `GroupAppleOperation` that executes multiple operations internally.
    */
    func dependencyForAppleOperation(_ operation: AppleOperation) -> Operation?
    
    /// Evaluate the condition, to see if it has been satisfied or not.
    func evaluateForAppleOperation(_ operation: AppleOperation, completion: (AppleOperationConditionResult) -> Void)
}

/**
    An enum to indicate whether an `AppleOperationCondition` was satisfied, or if it
    failed with an error.
*/
public enum AppleOperationConditionResult: Equatable {
    case satisfied
    case failed(NSError)
    
    var error: NSError? {
        if case .failed(let error) = self {
            return error
        }
        
        return nil
    }
}

public func ==(lhs: AppleOperationConditionResult, rhs: AppleOperationConditionResult) -> Bool {
    switch (lhs, rhs) {
        case (.satisfied, .satisfied):
            return true
        case (.failed(let lError), .failed(let rError)) where lError == rError:
            return true
        default:
            return false
    }
}

// MARK: Evaluate Conditions

public struct AppleOperationConditionEvaluator {
    static func evaluate(_ conditions: [AppleOperationCondition], operation: AppleOperation, completion: ([NSError]) -> Void) {
        // Check conditions.
        let conditionGroup = DispatchGroup()

        var results = [AppleOperationConditionResult?](repeating: nil, count: conditions.count)
        
        // Ask each condition to evaluate and store its result in the "results" array.
        for (index, condition) in conditions.enumerated() {
            conditionGroup.enter()
            condition.evaluateForAppleOperation(operation) { result in
                results[index] = result
                conditionGroup.leave()
            }
        }
        
        // After all the conditions have evaluated, this block will execute.
        conditionGroup.notify(queue: DispatchQueue.global(attributes: DispatchQueue.GlobalAttributes(rawValue: UInt64(Int(UInt64(DispatchQueueAttributes.qosDefault.rawValue)))))) {
            // Aggregate the errors that occurred, in order.
            var failures = results.flatMap { $0?.error }
            
            /*
                If any of the conditions caused this operation to be cancelled,
                check for that.
            */
            if operation.isCancelled {
                failures.append(NSError(code: .conditionFailed))
            }
            
            completion(failures)
        }
    }
}
