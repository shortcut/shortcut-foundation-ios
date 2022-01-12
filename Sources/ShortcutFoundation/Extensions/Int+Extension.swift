//
//  Int+Extension.swift
//  ShortcutFoundation
//
//  Created by Andreas Lif on 2022-01-12.
//  Copyright © 2021 Shortcut Scandinavia Apps AB. All rights reserved.
//

import Foundation

public extension Int {
    
    var isEven: Bool {
        guard self != 0 else { return true }
        return self % 2 == 0
    }
    var isOdd: Bool {
        guard self != 0 else { return false }
        return self % 2 != 0
    }
    
}
