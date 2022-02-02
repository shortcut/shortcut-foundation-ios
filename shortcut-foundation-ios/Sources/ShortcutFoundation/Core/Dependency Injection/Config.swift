//
//  Config.swift
//  ShortcutFoundation
//
//  Created by Gabriel Sabadin on 2021-04-26.
//  Copyright © 2021 Shortcut Scandinavia Apps AB. All rights reserved.
//

import Foundation

public protocol Config {
    func configure(_ injector: Injector)
}
