/*
Copyright (C) 2015 Apple Inc. All Rights Reserved.
See LICENSE.txt for this sample’s licensing information

Abstract:
This file contains the foundational subclass of NSOperation.
*/

import Foundation

/**
    The subclass of `NSOperation` from which all other operations should be derived.
    This class adds both Conditions and Observers, which allow the operation to define
    extended readiness requirements, as well as notify many interested parties
    about interesting operation state changes
*/
public class AppleOperation: Operation {
    
    // use the KVO mechanism to indicate that changes to "state" affect other properties as well
    class func keyPathsForValuesAffectingIsReady() -> Set<NSObject> {
        return ["state"]
    }
    
    class func keyPathsForValuesAffectingIsExecuting() -> Set<NSObject> {
        return ["state"]
    }
    
    class func keyPathsForValuesAffectingIsFinished() -> Set<NSObject> {
        return ["state"]
    }
    
    // MARK: State Management
    
    private enum State: Int, Comparable {
        /// The initial state of an `AppleOperation`.
        case initialized
        
        /// The `AppleOperation` is ready to begin evaluating conditions.
        case pending
        
        /// The `AppleOperation` is evaluating conditions.
        case evaluatingConditions
        
        /**
            The `AppleOperation`'s conditions have all been satisfied, and it is ready
            to execute.
        */
        case ready
        
        /// The `AppleOperation` is executing.
        case executing
        
        /**
            Execution of the `AppleOperation` has finished, but it has not yet notified
            the queue of this.
        */
        case finishing
        
        /// The `AppleOperation` has finished executing.
        case finished
        
        func canTransitionToState(_ target: State) -> Bool {
            switch (self, target) {
                case (.initialized, .pending):
                    return true
                case (.pending, .evaluatingConditions):
                    return true
                case (.evaluatingConditions, .ready):
                    return true
                case (.ready, .executing):
                    return true
                case (.ready, .finishing):
                    return true
                case (.executing, .finishing):
                    return true
                case (.finishing, .finished):
                    return true
                default:
                    return false
            }
        }
    }
    
    /**
        Indicates that the AppleOperation can now begin to evaluate readiness conditions,
        if appropriate.
    */
    func willEnqueue() {
        state = .pending
    }
    
    /// Private storage for the `state` property that will be KVO observed.
    private var _state = State.initialized
    
    /// A lock to guard reads and writes to the `_state` property
    private let stateLock = Lock()
    
    private var state: State {
        get {
            return stateLock.withCriticalScope {
                _state
            }
        }
    
        set(newState) {
            /*
                It's important to note that the KVO notifications are NOT called from inside
                the lock. If they were, the app would deadlock, because in the middle of
                calling the `didChangeValueForKey()` method, the observers try to access
                properties like "isReady" or "isFinished". Since those methods also
                acquire the lock, then we'd be stuck waiting on our own lock. It's the
                classic definition of deadlock.
            */
            willChangeValue(forKey: "state")
            
            stateLock.withCriticalScope { Void -> Void in
                guard _state != .finished else {
                    return
                }
                
                assert(_state.canTransitionToState(newState), "Performing invalid state transition.")
                _state = newState
            }
            
            didChangeValue(forKey: "state")
        }
    }
    
    // Here is where we extend our definition of "readiness".
    override public var isReady: Bool {
        switch state {
            
            case .initialized:
                // If the operation has been cancelled, "isReady" should return true
                return isCancelled
            
            case .pending:
                // If the operation has been cancelled, "isReady" should return true
                guard !isCancelled else {
                    return true
                }
                
                // If super isReady, conditions can be evaluated
                if super.isReady {
                    evaluateConditions()
                }
                
                // Until conditions have been evaluated, "isReady" returns false
                return false
            
            case .ready:
                return super.isReady || isCancelled
            
            default:
                return false
        }
    }
    
    var userInitiated: Bool {
        get {
            return qualityOfService == .userInitiated
        }

        set {
            assert(state < .executing, "Cannot modify userInitiated after execution has begun.")

            qualityOfService = newValue ? .userInitiated : .default
        }
    }
    
    override public var isExecuting: Bool {
        return state == .executing
    }
    
    override public var isFinished: Bool {
        return state == .finished
    }
    
    private func evaluateConditions() {
        assert(state == .pending && !isCancelled, "evaluateConditions() was called out-of-order")

        state = .evaluatingConditions
        
        AppleOperationConditionEvaluator.evaluate(conditions, operation: self) { failures in
            self._internalErrors.append(contentsOf: failures)
            self.state = .ready
        }
    }
    
    // MARK: Observers and Conditions
    
    private(set) var conditions = [AppleOperationCondition]()

    func addCondition(_ condition: AppleOperationCondition) {
        assert(state < .evaluatingConditions, "Cannot modify conditions after execution has begun.")

        conditions.append(condition)
    }
    
    private(set) var observers = [AppleOperationObserver]()
    
    func addObserver(_ observer: AppleOperationObserver) {
        assert(state < .executing, "Cannot modify observers after execution has begun.")
        
        observers.append(observer)
    }
    
    override public func addDependency(_ operation: Operation) {
        assert(state < .executing, "Dependencies cannot be modified after execution has begun.")

        super.addDependency(operation)
    }
    
    // MARK: Execution and Cancellation
    
    override final public func start() {
        // NSOperation.start() contains important logic that shouldn't be bypassed.
        super.start()
        
        // If the operation has been cancelled, we still need to enter the "Finished" state.
        if isCancelled {
            finish()
        }
    }
    
    override final public func main() {
        assert(state == .ready, "This operation must be performed on an operation queue.")

        if _internalErrors.isEmpty && !isCancelled {
            state = .executing
            
            for observer in observers {
                observer.operationDidStart(self)
            }
            
            execute()
        }
        else {
            finish()
        }
    }
    
    /**
        `execute()` is the entry point of execution for all `AppleOperation` subclasses.
        If you subclass `AppleOperation` and wish to customize its execution, you would
        do so by overriding the `execute()` method.
        
        At some point, your `AppleOperation` subclass must call one of the "finish"
        methods defined below; this is how you indicate that your operation has
        finished its execution, and that operations dependent on yours can re-evaluate
        their readiness state.
    */
    func execute() {
        print("\(self.dynamicType) must override `execute()`.")

        finish()
    }
    
    private var _internalErrors = [NSError]()    
    func cancelWithError(_ error: NSError? = nil) {
        if let error = error {
            _internalErrors.append(error)
        }
        
        cancel()
    }
    
    final func produceAppleOperation(_ operation: Operation) {
        for observer in observers {
            observer.operation(self, didProduceAppleOperation: operation)
        }
    }
    
    // MARK: Finishing
    
    /**
        Most operations may finish with a single error, if they have one at all.
        This is a convenience method to simplify calling the actual `finish()`
        method. This is also useful if you wish to finish with an error provided
        by the system frameworks. As an example, see `DownloadEarthquakesAppleOperation`
        for how an error from an `NSURLSession` is passed along via the
        `finishWithError()` method.
    */
    final func finishWithError(_ error: NSError?) {
        if let error = error {
            finish([error])
        }
        else {
            finish()
        }
    }
    
    /**
        A private property to ensure we only notify the observers once that the
        operation has finished.
    */
    private var hasFinishedAlready = false
    final func finish(_ errors: [NSError] = []) {
        if !hasFinishedAlready {
            hasFinishedAlready = true
            state = .finishing
            
            let combinedErrors = _internalErrors + errors
            finished(combinedErrors)
            
            for observer in observers {
                observer.operationDidFinish(self, errors: combinedErrors)
            }
            
            state = .finished
        }
    }
    
    /**
        Subclasses may override `finished(_:)` if they wish to react to the operation
        finishing with errors. For example, the `LoadModelAppleOperation` implements
        this method to potentially inform the user about an error when trying to
        bring up the Core Data stack.
    */
    func finished(_ errors: [NSError]) {
        // No op.
    }
    
    override final public func waitUntilFinished() {
        /*
            Waiting on operations is almost NEVER the right thing to do. It is
            usually superior to use proper locking constructs, such as `dispatch_semaphore_t`
            or `dispatch_group_notify`, or even `NSLocking` objects. Many developers
            use waiting when they should instead be chaining discrete operations
            together using dependencies.
            
            To reinforce this idea, invoking `waitUntilFinished()` will crash your
            app, as incentive for you to find a more appropriate way to express
            the behavior you're wishing to create.
        */
        fatalError("Waiting on operations is an anti-pattern. Remove this ONLY if you're absolutely sure there is No Other Way™.")
    }
    
}

// Simple operator functions to simplify the assertions used above.
private func <(lhs: AppleOperation.State, rhs: AppleOperation.State) -> Bool {
    return lhs.rawValue < rhs.rawValue
}

private func ==(lhs: AppleOperation.State, rhs: AppleOperation.State) -> Bool {
    return lhs.rawValue == rhs.rawValue
}
