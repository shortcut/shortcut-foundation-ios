//
// Loggable.swift
// VSFoundation
//
// Created by Gabriel Sabadin on 2021-12-13.
// Copyright Virtual Stores - 2021
//

import Foundation
import os

/**
 Verbosity Desired level to determine the output of the logger
 ````
 case debug
 case info
 case warning
 case error
 case critical
 case silent
 ````
*/

public enum Verbosity {
    /// used for debug purposes
    case debug

    /// used to add relevant information
    case info

    /// used to indicate warnings and provide guidance
    case warning

    /// used to indicate errors and provide ways to troubleshoot
    case error

    /// used to indicate critical errors
    case critical

    /// used to silent the logger (nothing will be printed out)
    case silent
}

public protocol Loggable {
    /// @abstract The desired verbosity
    var verbosity: Verbosity { get set }

    /// Method that triggers the logging procedure
    /// - Author: Gabriel Sabadin
    ///
    /// - Parameter message: A String to determine the message you want to be logged
    func log(message: String)
}

public struct Logger: Loggable {
    private let logger: os.Logger
    public var verbosity: Verbosity

    public init(verbosity: Verbosity = .silent,
                identifier: String = "",
                category: String = "") {
        self.verbosity = verbosity
        logger = os.Logger(subsystem: identifier, category: category)
    }

    public func log(message: String) {
        switch verbosity {
        case .debug:
            logger.debug("\(message)")
        case .info:
            logger.info("\(message)")
        case .warning:
            logger.warning("\(message)")
        case .error:
            logger.error("\(message)")
        case .critical:
            logger.critical("\(message)")
        case .silent:
            // no log message message
            break
        }
    }
}
