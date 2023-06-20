//
//  RemotePaymentProvider.swift
//  ShortcutFoundation
//
//  Created by Swathi on 2022-02-13.
//  Copyright © 2022 Shortcut Scandinavia Apps AB. All rights reserved.
//

#if canImport(PassKit)
import Foundation
import PassKit

public protocol PaymentProvider {
    func processPayment(_ payment: PKPayment, completion: @escaping (Error?) -> Void)
}

public class RemotePaymentProvider: PaymentProvider {

    public init() {}

    public func processPayment(_ payment: PKPayment, completion: @escaping (Error?) -> Void) {
        // Implement payment validation with provider - Stripe, Braintree
        completion(nil)
    }
}

#endif
