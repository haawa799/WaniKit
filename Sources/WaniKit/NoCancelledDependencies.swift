/*
Copyright (C) 2015 Apple Inc. All Rights Reserved.
See LICENSE.txt for this sample’s licensing information

Abstract:
This file shows an example of implementing the AppleOperationCondition protocol.
*/

import Foundation

/**
    A condition that specifies that every dependency must have succeeded.
    If any dependency was cancelled, the target operation will be cancelled as
    well.
*/
public struct NoCancelledDependencies: AppleOperationCondition {
    public static let name = "NoCancelledDependencies"
    public static let cancelledDependenciesKey = "CancelledDependencies"
    public static let isMutuallyExclusive = false
    
    init() {
        // No op.
    }
    
    public func dependencyForAppleOperation(_ operation: AppleOperation) -> Operation? {
        return nil
    }
    
    public func evaluateForAppleOperation(_ operation: AppleOperation, completion: (AppleOperationConditionResult) -> Void) {
        // Verify that all of the dependencies executed.
        let cancelled = operation.dependencies.filter { $0.isCancelled }

        if !cancelled.isEmpty {
            // At least one dependency was cancelled; the condition was not satisfied.
            let error = NSError(code: .conditionFailed, userInfo: [
                AppleOperationConditionKey: self.dynamicType.name,
                self.dynamicType.cancelledDependenciesKey: cancelled
            ])
            
            completion(.failed(error))
        }
        else {
            completion(.satisfied)
        }
    }
}
