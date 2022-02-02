//
//  Locale+Extension.swift
//  ShortcutFoundation
//
//  Created by Gabriel Sabadin on 2021-08-16.
//  Copyright © 2021 Shortcut Scandinavia Apps AB. All rights reserved.
//

import Foundation

public extension Locale {
    static var currentLanguageCode: String {
        let localeID = Locale.preferredLanguages.first ?? ""
        let languageCode = Locale(identifier: localeID).languageCode
        // Locale.current.languageCode (is returning "en")
        return languageCode ?? "en"
    }
}
