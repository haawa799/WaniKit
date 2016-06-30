/*
Copyright (C) 2015 Apple Inc. All Rights Reserved.
See LICENSE.txt for this sample’s licensing information

Abstract:
The file shows how to make an AppleOperationCondition that composes another AppleOperationCondition.
*/

import Foundation

/**
 A simple condition that negates the evaluation of another condition.
 This is useful (for example) if you want to only execute an operation if the
 network is NOT reachable.
 */
public struct NegatedCondition<T: AppleOperationCondition>: AppleOperationCondition {
  public static var name: String {
    return "Not<\(T.name)>"
  }
  
  static var negatedConditionKey: String {
    return "NegatedCondition"
  }
  
  public static var isMutuallyExclusive: Bool {
    return T.isMutuallyExclusive
  }
  
  let condition: T
  
  init(condition: T) {
    self.condition = condition
  }
  
  public func dependencyForAppleOperation(_ operation: AppleOperation) -> Operation? {
    return condition.dependencyForAppleOperation(operation)
  }
  
  public func evaluateForAppleOperation(_ operation: AppleOperation, completion: (AppleOperationConditionResult) -> Void) {
    condition.evaluateForAppleOperation(operation) { result in
      if result == .satisfied {
        // If the composed condition succeeded, then this one failed.
        let error = NSError(code: .conditionFailed, userInfo: [
          AppleOperationConditionKey: self.dynamicType.name,
          self.dynamicType.negatedConditionKey: self.condition.dynamicType.name
          ])
        
        completion(.failed(error))
      }
      else {
        // If the composed condition failed, then this one succeeded.
        completion(.satisfied)
      }
    }
  }
}
