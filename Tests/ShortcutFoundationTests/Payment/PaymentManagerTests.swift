//
//  PaymentManagerTests.swift
//  ShortcutFoundation
//
//  Created by Swathi on 2022-02-14.
//  Copyright © 2022 Shortcut Scandinavia Apps AB. All rights reserved.
//

#if canImport(PassKit)
import PassKit
import XCTest
@testable import ShortcutFoundation

#if !os(macOS)
class PaymentManagerTests: XCTestCase {
    
    func test_delegateDidAuthorizePayment_forwardsMessageToProvider() throws {
        let payment = PKPayment()
        let (sut, provider) = makeSUT()
        
        sut.paymentAuthorizationController(try XCTUnwrap(makeAuthController()),
                                           didAuthorizePayment: payment,
                                           handler: { _ in })
        XCTAssertEqual(provider.payments, [payment])
    }
    
    private func makeSUT() -> (sut: PaymentManager, provider: PaymentProviderSpy) {
        let provider = PaymentProviderSpy()
        let sut = PaymentManager(paymentProvider: provider,
                                 paymentAuthorizationHandler: ApplePayAuthorizationHandler(identifier: TestStrings.merchantId.rawValue))
        return (sut, provider)
    }
    
    private func makeAuthController() -> PKPaymentAuthorizationController? {
        PKPaymentAuthorizationController(paymentRequest: .validRequest)
    }
}
#endif

#endif
