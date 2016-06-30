/*
Copyright (C) 2015 Apple Inc. All Rights Reserved.
See LICENSE.txt for this sample’s licensing information

Abstract:
The file contains the code to automatically set up dependencies between mutually exclusive operations.
*/

import Foundation

/**
    `ExclusivityController` is a singleton to keep track of all the in-flight
    `AppleOperation` instances that have declared themselves as requiring mutual exclusivity.
    We use a singleton because mutual exclusivity must be enforced across the entire
    app, regardless of the `AppleAppleOperationQueue` on which an `AppleOperation` was executed.
*/
class ExclusivityController {
    static let sharedExclusivityController = ExclusivityController()
    
    private let serialQueue = DispatchQueue(label: "AppleOperations.ExclusivityController", attributes: DispatchQueueAttributes.serial)
    private var operations: [String: [AppleOperation]] = [:]
    
    private init() {
        /*
            A private initializer effectively prevents any other part of the app
            from accidentally creating an instance.
        */
    }
    
    /// Registers an operation as being mutually exclusive
    func addOperation(_ operation: AppleOperation, categories: [String]) {
        /*
            This needs to be a synchronous operation.
            If this were async, then we might not get around to adding dependencies
            until after the operation had already begun, which would be incorrect.
        */
        serialQueue.sync {
            for category in categories {
                self.noqueue_addOperation(operation, category: category)
            }
        }
    }
    
    /// Unregisters an operation from being mutually exclusive.
    func removeAppleOperation(_ operation: AppleOperation, categories: [String]) {
        serialQueue.async {
            for category in categories {
                self.noqueue_removeAppleOperation(operation, category: category)
            }
        }
    }
    
    
    // MARK: AppleOperation Management
    
    private func noqueue_addOperation(_ operation: AppleOperation, category: String) {
        var operationsWithThisCategory = operations[category] ?? []
        
        if let last = operationsWithThisCategory.last {
            operation.addDependency(last)
        }
        
        operationsWithThisCategory.append(operation)

        operations[category] = operationsWithThisCategory
    }
    
    private func noqueue_removeAppleOperation(_ operation: AppleOperation, category: String) {
        let matchingAppleOperations = operations[category]

        if var operationsWithThisCategory = matchingAppleOperations,
           let index = operationsWithThisCategory.index(of: operation) {

            operationsWithThisCategory.remove(at: index)
            operations[category] = operationsWithThisCategory
        }
    }
    
}
