//
//  PaymentModel.swift
//  ShortcutFoundation
//
//  Created by Swathi on 2022-02-14.
//  Copyright © 2022 Shortcut Scandinavia Apps AB. All rights reserved.
//

import Foundation

public struct PaymentModel {
    let name: String
    let cost: NSDecimalNumber
    let countryCode: String
    let currency: String
    
    public init(name: String,
                cost: NSDecimalNumber,
                countryCode: String,
                currency: String) {
        self.name = name
        self.cost = cost
        self.countryCode = countryCode
        self.currency = currency
    }
}
