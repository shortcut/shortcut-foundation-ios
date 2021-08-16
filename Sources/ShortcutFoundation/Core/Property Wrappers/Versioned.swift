//
//  Versioned.swift
//  ShortcutFoundation
//
//  Created by Gabriel Sabadin on 2021-04-26.
//  Copyright © 2021 Shortcut Scandinavia Apps AB. All rights reserved.
//

import Foundation

@propertyWrapper
public struct Versioned<T> {
    private var current: T
    private var currentHistory = [T]()

    public init(wrappedValue: T) {
        current = wrappedValue
        currentHistory.append(current)
    }

    public var wrappedValue: T {
        get { return current }

        set {
            currentHistory.append(current)
            current = newValue
        }
    }

    public var projectedValue: Self {
        return self
    }

    public func history() -> [T] {
        return currentHistory
    }
}
