//
//  Double+Extension.swift
//  ShortcutFoundation
//
//  Created by Sheikh Bayazid on 2022-05-30.
//  Copyright © 2022 Shortcut Scandinavia Apps AB. All rights reserved.
//

import Foundation

public extension Double {
    func localized(locale: Locale = .current, maximumFractionDigits: Int = 2) -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = locale
        formatter.maximumFractionDigits = maximumFractionDigits
        
        return formatter.string(from: self as NSNumber)
    }
}
