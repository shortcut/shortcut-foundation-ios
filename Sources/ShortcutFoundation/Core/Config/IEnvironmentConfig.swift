//
//  IEnvironmentConfig.swift
//  HerCare
//
//  Created by Gabriel Sabadin on 2021-05-19.
//  Copyright © 2021 Hercare Sweden AB. All rights reserved.
//

import Foundation

public enum LogLevel {
    case off
    case info
    case debug
}

public enum InactivityControl {
    case no
    case yes(Int)
}

public protocol IEnvironmentConfig {
    func firebasePlist() -> String
    func baseURL() -> String
    func logLevel() -> LogLevel
    func forceLogoutOnLaunch() -> Bool
    func forceLogoutOnInactivity() -> InactivityControl
    func firebaseContentVersion() -> String
    func authenticationToken() -> String?
}
