//
//  DeviceContextProtocol.swift
//  
//
//  Created by Swathi on 2022-02-02.
//

import Foundation
import LocalAuthentication

public protocol DeviceContextProtocol {
    var biometryType: LABiometryType { get }
    
    @discardableResult
    func canEvaluatePolicy(_ policy: LAPolicy,
                           error: NSErrorPointer) -> Bool
    func evaluatePolicy(_ policy: LAPolicy,
                        localizedReason: String,
                        reply: @escaping (Bool, Error?) -> Void)
}

extension LAContext: DeviceContextProtocol {}

