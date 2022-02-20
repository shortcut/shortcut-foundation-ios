//
//  PaymentProviderSpy.swift
//  ShortcutFoundation
//
//  Created by Swathi on 2022-02-13.
//  Copyright © 2022 No more yellow notes AB. All rights reserved.

import PassKit
import ShortcutFoundation

class PaymentProviderSpy: PaymentProvider {
    var payments = [PKPayment]()
    
    func processPayment(_ payment: PKPayment, completion: @escaping (Error?) -> Void) {
        payments.append(payment)
    }
}
