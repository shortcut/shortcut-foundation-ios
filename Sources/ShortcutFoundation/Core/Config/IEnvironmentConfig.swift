//
//  IEnvironmentConfig.swift
//  ShortcutFoundation
//
//  Created by Gabriel Sabadin on 2021-05-19.
//  Copyright © 2021 Shortcut Scandinavia Apps AB. All rights reserved.
//

import Foundation

@available(*, deprecated, message: "Use Verbosity instead")
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
    @available(*, deprecated, message: "Use verbosity instead")
    func logLevel() -> LogLevel
    func verbosity() -> Verbosity
    func forceLogoutOnLaunch() -> Bool
    func forceLogoutOnInactivity() -> InactivityControl
    func firebaseContentVersion() -> String
    func authenticationToken() -> String?
}
