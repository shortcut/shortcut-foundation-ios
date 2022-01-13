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
        return self.isMultiple(of: 2)
    }
    var isOdd: Bool {
        return !(self.isMultiple(of: 2))
    }
    
}
