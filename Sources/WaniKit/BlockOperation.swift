/*
Copyright (C) 2015 Apple Inc. All Rights Reserved.
See LICENSE.txt for this sample’s licensing information

Abstract:
This code shows how to create a simple subclass of AppleOperation.
*/

import Foundation

/// A closure type that takes a closure as its parameter.
typealias AppleOperationBlock = ((Void) -> Void) -> Void

/// A sublcass of `AppleOperation` to execute a closure.
class BlockAppleOperation: AppleOperation {
    private let block: AppleOperationBlock?
    
    /**
        The designated initializer.
        
        - parameter block: The closure to run when the operation executes. This
            closure will be run on an arbitrary queue. The parameter passed to the
            block **MUST** be invoked by your code, or else the `BlockAppleOperation`
            will never finish executing. If this parameter is `nil`, the operation
            will immediately finish.
    */
    init(block: AppleOperationBlock? = nil) {
        self.block = block
        super.init()
    }
    
    /**
        A convenience initializer to execute a block on the main queue.
        
        - parameter mainQueueBlock: The block to execute on the main queue. Note
            that this block does not have a "continuation" block to execute (unlike
            the designated initializer). The operation will be automatically ended
            after the `mainQueueBlock` is executed.
    */
    convenience init(mainQueueBlock: (Void) -> Void) {
        self.init(block: { continuation in
            DispatchQueue.main.async {
                mainQueueBlock()
                continuation()
            }
        })
    }
    
    override func execute() {
        guard let block = block else {
            finish()
            return
        }
        
        block {
            self.finish()
        }
    }
}
