//
//  EventMap.swift
//  ShortcutFoundation
//
//  Created by Gabriel Sabadin on 2021-09-13.
//  Copyright © 2021 Shortcut Scandinavia Apps AB. All rights reserved.
//

import Foundation

struct EventMap {
    var storage = [String: [Function]]()

    func hasListener(forKey key: String) -> Bool {
        guard let event = self[key], event.count > 0 else {
            return false
        }
        return true
    }

    mutating func remove(forKey key: String) {
        storage.removeValue(forKey: key)
    }

    subscript(_ key: String) -> [Function]? {
        get {
            return storage[key]
        } set {
            guard let newValue = newValue else {
                return
            }
            storage[key] = newValue
        }
    }
}
