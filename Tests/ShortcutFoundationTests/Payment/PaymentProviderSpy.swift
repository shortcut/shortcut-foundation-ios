//
//  PaymentProviderSpy.swift
//  ShortcutFoundation
//
//  Created by Swathi on 2022-02-13.
//  Copyright © 2022 Shortcut Scandinavia Apps AB. All rights reserved.
//

#if canImport(PassKit)
import PassKit
import ShortcutFoundation

class PaymentProviderSpy: PaymentProvider {
    var payments = [PKPayment]()
    
    func processPayment(_ payment: PKPayment, completion: @escaping (Error?) -> Void) {
        payments.append(payment)
    }
}
#endif
