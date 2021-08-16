//
//  Device.swift
//  ShortcutFoundation
//
//  Created by Gabriel Sabadin on 2021-04-26.
//  Copyright © 2021 Shortcut Scandinavia Apps AB. All rights reserved.
//

import Foundation

public protocol IDevice {
    var isSwedishMobileBankIdInstalled: Bool { get }
    var isSwishInstalled: Bool { get }
}

#if !os(macOS)
public struct Device: IDevice {
    public init() {}

    public var isSwedishMobileBankIdInstalled: Bool {
        guard let url = URL(string: "bankid://") else { return false }
        return UIApplication.shared.canOpenURL(url)
    }

    public var isSwishInstalled: Bool {
        guard let url = URL(string: "swish://") else { return false }
        return UIApplication.shared.canOpenURL(url)
    }
}
#endif
