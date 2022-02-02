//
//  Dictionary+Extension.swift
//  ShortcutFoundation
//
//  Created by Gabriel Sabadin on 2022-08-16.
//  Copyright © 2021 Shortcut Scandinavia Apps AB. All rights reserved.
//

import Foundation

public extension Dictionary {
    func has(_ key: Key) -> Bool {
        return index(forKey: key) != nil
    }
}
