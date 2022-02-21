//
//  PaymentManager.swift
//  ShortcutFoundation
//
//  Created by Swathi on 2022-02-14.
//  Copyright © 2022 Shortcut Scandinavia Apps AB. All rights reserved.
//

import Foundation
import PassKit

protocol IPaymentManager {
    var hasApplePaySupport: Bool { get }
    func checkoutWithApplePay(for paymentModel: PaymentModel)
}

#if !os(macOS)
public final class PaymentManager: NSObject, IPaymentManager {
    @OptionalInject private var logger: Loggable?
    let paymentProvider: PaymentProvider
    let paymentAuthorizationHandler: ApplePayAuthorizationHandler
    var paymentController: PKPaymentAuthorizationController?
    
    public init(paymentProvider: PaymentProvider,
                paymentAuthorizationHandler: ApplePayAuthorizationHandler) {
        self.paymentProvider = paymentProvider
        self.paymentAuthorizationHandler = paymentAuthorizationHandler
    }
    
    public var hasApplePaySupport: Bool { return self.paymentAuthorizationHandler.deviceSupportsApplePay() }
    
    public func checkoutWithApplePay(for paymentModel: PaymentModel) {
        paymentAuthorizationHandler.requestAuthorization(for: paymentModel) { completion in
            if case let .failure(error) = completion {
                self.logger?.log(message: error.localizedDescription, verbosity: .error)
            }
            if case let .success(controller) = completion {
                paymentController = controller
                paymentController?.delegate = self
                paymentController?.present(completion: nil)
            }
        }
    }
}

extension PaymentManager: PKPaymentAuthorizationControllerDelegate {
    
    public func paymentAuthorizationControllerDidFinish(_ controller: PKPaymentAuthorizationController) {
        paymentController?.dismiss(completion: nil)
    }
    
    public func paymentAuthorizationController(_ controller: PKPaymentAuthorizationController,
                                               didAuthorizePayment payment: PKPayment,
                                               handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        
        let errors = [Error]()
        paymentProvider.processPayment(payment) { error in
            if let error = error {
                self.logger?.log(message: String(describing: error), verbosity: .error)
                completion(PKPaymentAuthorizationResult(status: .failure, errors: errors))
            } else {
                completion(PKPaymentAuthorizationResult(status: .success, errors: errors))
            }
        }
    }
}
#endif
