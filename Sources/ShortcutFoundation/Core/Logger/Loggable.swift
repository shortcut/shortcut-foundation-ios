//
//  Loggable.swift
//  ShortcutFoundation
//
//  Created by Gabriel Sabadin on 2021-12-13.
//  Copyright © 2021 Shortcut Scandinavia Apps AB. All rights reserved.
//

import Foundation

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

    /// Init Method that creates a custom logger for logging to a specific identifier and category.
    /// - Author: Gabriel Sabadin
    ///
    /// - Parameter verbosity: The desired Verbosity
    /// - Parameter identifier: A String to determine the identifier of the logger
    /// - Parameter category: A String to determine the category of the logger
    init(verbosity: Verbosity, identifier: String, category: String)

    /// Method that triggers the logging procedure
    /// - Author: Gabriel Sabadin
    ///
    /// - Parameter message: A String to determine the message you want to be logged
    func log(message: String)
}

struct PrintLogger: Loggable {
    var verbosity: Verbosity

    init(verbosity: Verbosity, identifier: String, category: String) {
        self.verbosity = verbosity
    }

    func log(message: String) {
        switch verbosity {
        case .debug:
            print("🕵️‍♀️ DEBUG: \(message)")
        case .info:
            print("ℹ️ INFO: \(message)")
        case .warning:
            print("⚠️ WARNING: \(message)")
        case .error:
            print("⛔️ ERROR: \(message)")
        case .critical:
            print("☣️ CRITICAL: \(message)")
        case .silent:
            // no log message message
            break
        }
    }
}

import os
@available(iOS 14.0, *)
struct AppleLogger: Loggable {
    private let logger: os.Logger
    var verbosity: Verbosity

    init(verbosity: Verbosity, identifier: String, category: String) {
        self.verbosity = verbosity
        logger = os.Logger(subsystem: identifier, category: category)
    }

    func log(message: String) {
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

public struct Logger: Loggable {
    private var strategy: Loggable

    public var verbosity: Verbosity = .silent {
        didSet {
            strategy.verbosity = verbosity
        }
    }

    public init(verbosity: Verbosity = .silent,
                identifier: String = "",
                category: String = "") {
        if #available(iOS 14.0, *) {
            strategy = AppleLogger(verbosity: verbosity, identifier: identifier, category: category)
        } else {
            strategy = PrintLogger(verbosity: verbosity, identifier: identifier, category: category)
        }
    }

    public func log(message: String) {
        strategy.log(message: message)
    }
}
