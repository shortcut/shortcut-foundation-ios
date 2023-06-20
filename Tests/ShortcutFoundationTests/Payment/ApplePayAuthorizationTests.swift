//
//  ApplePayAuthorizationTests.swift
//  ShortcutFoundation
//
//  Created by Swathi on 2022-02-14.
//  Copyright © 2022 Shortcut Scandinavia Apps AB. All rights reserved.
//

#if canImport(PassKit)
import PassKit
import XCTest
import ShortcutFoundation

class ApplePayAuthorizationTests: XCTestCase {
    
    func test_requestAuthorization_failsWhenPaymentNetworkNotSupported() {
        let (sut, _) = makeSUT(request: .validRequest,
                               authorizedNetworks: false)
        expect(sut,
               testPayment: PaymentModel.validPayment,
               toCompleteWith: .failure(.networkNotSupported))
    }
    
    func test_requestAuthorization_succeedsWhenPaymentNetworkSupported() {
        let (sut, _) = makeSUT(request: .validRequest,
                               authorizedNetworks: true)
        expect(sut,
               testPayment: PaymentModel.validPayment,
               toCompleteWith: nil)
}
    
    func test_requestAuthorization_failsWhenInvalidCountry() {
        let (sut, _) = makeSUT(request: .invalidRequest,
                               authorizedNetworks: true)
        expect(sut,
               testPayment: PaymentModel.invalidCountry,
               toCompleteWith: .failure(.invalidCountryCode))
    }
    
    func test_requestAuthorization_failsWhenInvalidCurrency() {
        let (sut, _) = makeSUT(request: .invalidRequest,
                               authorizedNetworks: true)
        
        expect(sut,
               testPayment: PaymentModel.invalidCurrency,
               toCompleteWith: .failure(.invalidCurrency))
    }
    
    // MARK: - Helpers

    private func makeSUT(request: PKPaymentRequest,
                         authorizedNetworks: Bool) -> (
                            sut: ApplePayAuthorizationHandler,
                            authController: PKPaymentAuthorizationController?) {
        let authController = PKPaymentAuthorizationController(paymentRequest: request)
        let sut = ApplePayAuthorizationHandler(controllerFactory: { _ in
            authController
        }, networkAuthorizationHandler: { _ in
            authorizedNetworks
        }, identifier: TestStrings.merchantId.rawValue)
        return (sut, authController)
    }
    
    private func expect(_ sut: ApplePayAuthorizationHandler,
                        testPayment: PaymentModel,
                        toCompleteWith expectedCompletion: Result<PKPaymentAuthorizationController, ApplePayAuthorizationHandler.ApplePayError>?,
                        file: StaticString = #filePath,
                        line: UInt = #line) {
        let exp = expectation(description: "Wait for request permission")
        sut.requestAuthorization(for: testPayment) { receivedCompletion in
            switch (receivedCompletion, expectedCompletion) {
            case let (.failure(receivedError), .failure(expectedError)):
                XCTAssertEqual(receivedError, expectedError, file: file, line: line)
            case let (.success(receivedController), nil):
                XCTAssertNotNil(receivedController, "Request might be incomplete, or payment is not possible", file: file, line: line)
            default:
                XCTFail("Expected completion \(String(describing: expectedCompletion)) but got \(receivedCompletion) instead", file: file, line: line)
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }
}
#endif
