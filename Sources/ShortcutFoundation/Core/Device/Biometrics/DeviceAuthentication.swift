//
//  DeviceAuthentication.swift
//  ShortcutFoundation
//
//  Created by Swathi on 2022-02-02.
//  Copyright © 2022 Shortcut Scandinavia Apps AB. All rights reserved.
//

import LocalAuthentication

//Current state if authentication
public enum DeviceAuthAction: Equatable {
    case authenticated
    case notAuthenticated
    case error(DeviceAuthError)
}

//Error states while authentication
public enum DeviceAuthError: Error {
    case unsupportedDevice
    case failed
}

public final class DeviceAuthentication: ObservableObject {
    
    public var alertDescription: String
    private var context: DeviceContextProtocol
    
    @Published private(set) var action: DeviceAuthAction
    {
        didSet {
            if action == .notAuthenticated {
                context = LAContext()
            }
        }
    }
    
    /// Indicates what type is supported by the  device
    public var type: LABiometryType {
        context.biometryType
    }

    /// Indicates if biometrics are supported
    public var isBiometricsSupported: Bool {
        context.biometryType != .none
    }
    
    public init(context: DeviceContextProtocol = LAContext(),
                policy: LAPolicy = .deviceOwnerAuthentication,
                localizedAlertDesc: String) {
        self.context = context
        self.alertDescription = localizedAlertDesc

        context.canEvaluatePolicy(policy,
                                  error: nil)
        action = .notAuthenticated
    }
    
    /// Attempt to authenticate the user with biometrics. Updates action with the result
    public func login(_ policy: LAPolicy = .deviceOwnerAuthentication) {
        var error: NSError?
        // Determine if the device supports biometrics, else return error.
        guard context.canEvaluatePolicy(.deviceOwnerAuthentication,
                                        error: &error) else {
            action = .error(.unsupportedDevice)
            return
        }

        // Ensures a new context is provided for authentication, else the previous one will always fail to re-auth
        if action == .authenticated {
            action = .notAuthenticated
        }

        context.evaluatePolicy(policy,
                               localizedReason: alertDescription) { [weak self] success, _ in
            self?.action = success ? .authenticated : .error(.failed)
        }
    }
    
    

    //Logout if authenticated. Else no state change needed
    public func logout() {
        if action == .authenticated {
            action = .notAuthenticated
        }
    }
}
