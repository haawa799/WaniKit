/*
Copyright (C) 2015 Apple Inc. All Rights Reserved.
See LICENSE.txt for this sample’s licensing information

Abstract:
This file shows an example of implementing the AppleOperationCondition protocol.
*/

import Foundation

#if os(iOS)

import UIKit
    
private let RemoteNotificationQueue = AppleAppleOperationQueue()
private let RemoteNotificationName = "RemoteNotificationPermissionNotification"

private enum RemoteRegistrationResult {
    case token(Data)
    case error(NSError)
}

/// A condition for verifying that the app has the ability to receive push notifications.
public struct RemoteNotificationCondition: AppleOperationCondition {
    public static let name = "RemoteNotification"
    public static let isMutuallyExclusive = false
    
    public static func didReceiveNotificationToken(_ token: Data) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: RemoteNotificationName), object: nil, userInfo: [
            "token": token
        ])
    }
    
    public static func didFailToRegister(_ error: NSError) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: RemoteNotificationName), object: nil, userInfo: [
            "error": error
        ])
    }
    
    let application: UIApplication
    
    init(application: UIApplication) {
        self.application = application
    }
    
    public func dependencyForAppleOperation(_ operation: AppleOperation) -> Operation? {
        return RemoteNotificationPermissionAppleOperation(application: application, handler: { _ in })
    }
    
    public func evaluateForAppleOperation(_ operation: AppleOperation, completion: (AppleOperationConditionResult) -> Void) {
        /*
            Since evaluation requires executing an operation, use a private operation
            queue.
        */
        RemoteNotificationQueue.addOperation(RemoteNotificationPermissionAppleOperation(application: application) { result in
            switch result {
                case .token(_):
                    completion(.satisfied)

                case .error(let underlyingError):
                    let error = NSError(code: .conditionFailed, userInfo: [
                        AppleOperationConditionKey: self.dynamicType.name,
                        NSUnderlyingErrorKey: underlyingError
                    ])

                    completion(.failed(error))
            }
        })
    }
}

/**
    A private `AppleOperation` to request a push notification token from the `UIApplication`.
    
    - note: This operation is used for *both* the generated dependency **and**
        condition evaluation, since there is no "easy" way to retrieve the push
        notification token other than to ask for it.

    - note: This operation requires you to call either `RemoteNotificationCondition.didReceiveNotificationToken(_:)` or
        `RemoteNotificationCondition.didFailToRegister(_:)` in the appropriate
        `UIApplicationDelegate` method, as shown in the `AppDelegate.swift` file.
*/
private class RemoteNotificationPermissionAppleOperation: AppleOperation {
    let application: UIApplication
    private let handler: (RemoteRegistrationResult) -> Void
    
    private init(application: UIApplication, handler: (RemoteRegistrationResult) -> Void) {
        self.application = application
        self.handler = handler

        super.init()
        
        /*
            This operation cannot run at the same time as any other remote notification
            permission operation.
        */
        addCondition(MutuallyExclusive<RemoteNotificationPermissionAppleOperation>())
    }
    
    override func execute() {
        DispatchQueue.main.async {
            let notificationCenter = NotificationCenter.default
            
            notificationCenter.addObserver(self, selector: #selector(RemoteNotificationPermissionAppleOperation.didReceiveResponse(_:)), name: NSNotification.Name(rawValue: RemoteNotificationName), object: nil)
            
            self.application.registerForRemoteNotifications()
        }
    }
    
    @objc func didReceiveResponse(_ notification: Notification) {
        NotificationCenter.default.removeObserver(self)
        
        let userInfo = (notification as NSNotification).userInfo

        if let token = userInfo?["token"] as? Data {
            handler(.token(token))
        }
        else if let error = userInfo?["error"] as? NSError {
            handler(.error(error))
        }
        else {
            fatalError("Received a notification without a token and without an error.")
        }

        finish()
    }
}
    
#endif
