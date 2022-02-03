//
//  DeviceAuthentication.swift
//  
//
//  Created by Swathi on 2022-02-02.
//

import LocalAuthentication

//Current state if authentication
public enum DeviceAuthAction: Equatable {
    case authenticated
    case notAuthenticated
    case error(BiometricError)
}

//Error states while authentication
public enum BiometricError: Swift.Error {
    case unsupportedDevice
    case failed
}

public final class DeviceAuthentication: ObservableObject {
    
    var alertDescription: String
    private var context: DeviceContextProtocol
    
    @Published public private(set) var action: DeviceAuthAction
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
                localizedAlertDesc: String) {
        self.context = context
        self.alertDescription = localizedAlertDesc

        // Context can set the biometric type
        context.canEvaluatePolicy(.deviceOwnerAuthentication,
                                  error: nil)
        action = .notAuthenticated
    }
    
    /// Attempt to authenticate the user with biometrics. Updates action with the result
    public func login() {
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

        //authenticate user using biometrics or the user's device passcode.
        //.deviceOwnerAuthenticationWithBiometrics - only faceID/touchId
        context.evaluatePolicy(.deviceOwnerAuthentication,
                               localizedReason: alertDescription) { [weak self] success, _ in
            // Ensure that the action is updated on main thread
            DispatchQueue.main.async {
                self?.action = success ? .authenticated : .error(.failed)
            }
        }
    }

    //Logout if authenticated. Else no state change needed
    public func logout() {
        if action == .authenticated {
            action = .notAuthenticated
        }
    }
}
