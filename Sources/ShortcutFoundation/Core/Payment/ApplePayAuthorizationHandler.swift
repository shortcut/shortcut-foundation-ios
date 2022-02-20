//
//  ApplePayAuthorizationHandler.swift
//  ShortcutFoundation
//
//  Created by Swathi on 2022-02-13.
//  Copyright © 2022 No more yellow notes AB. All rights reserved.

import PassKit

public final class ApplePayAuthorizationHandler {
    
    public typealias ApplePayControllerFactory = (PKPaymentRequest) -> PKPaymentAuthorizationController?
    public typealias ApplePayCompletionHandler = (Result<PKPaymentAuthorizationController, ApplePayError>) -> Void
    public typealias NetworkAuthorizationHandler = ([PKPaymentNetwork]) -> Bool
    
    public enum ApplePayError: Error {
        case networkNotSupported
        case unableToInitialize
        case invalidCountryCode
        case invalidCurrency
    }
    
    private let controllerFactory: ApplePayControllerFactory
    private let networkAuthorizationHandler: NetworkAuthorizationHandler
    
    private let merchantIdentifier: String
    private let supportedNetworks: [PKPaymentNetwork] = [.amex, .discover, .masterCard, .visa]
    
    public init(
        controllerFactory: @escaping ApplePayControllerFactory = PKPaymentAuthorizationController.init,
        networkAuthorizationHandler: @escaping NetworkAuthorizationHandler = PKPaymentAuthorizationController.canMakePayments,
        identifier: String
    ) {
        self.controllerFactory = controllerFactory
        self.networkAuthorizationHandler = networkAuthorizationHandler
        self.merchantIdentifier = identifier
    }
    
    public func makePaymentRequest(for paymentModel: PaymentModel) -> PKPaymentRequest {
        let paymentSummaryItem = PKPaymentSummaryItem(label: paymentModel.name,
                                                      amount: paymentModel.cost)
        let request = PKPaymentRequest()
        request.paymentSummaryItems = [paymentSummaryItem]
        request.merchantIdentifier = merchantIdentifier
        request.merchantCapabilities = .capability3DS
        request.currencyCode = paymentModel.currency
        request.countryCode = paymentModel.countryCode
        request.supportedNetworks = supportedNetworks
        request.shippingMethods = []
    
        return request
    }
    
    public func deviceSupportsApplePay() -> Bool {
        return PKPaymentAuthorizationController.canMakePayments(usingNetworks: self.supportedNetworks)
    }
    
    public func requestAuthorization(for paymentModel: PaymentModel, completion: ApplePayCompletionHandler) {
        guard NSLocale.isoCountryCodes.contains(paymentModel.countryCode) else {
            completion(.failure(ApplePayError.invalidCountryCode))
            return
        }
       
        guard NSLocale.isoCurrencyCodes.contains(paymentModel.currency) else {
            completion(.failure(ApplePayError.invalidCurrency))
            return
        }
        
        let request = makePaymentRequest(for: paymentModel)
        
        guard networkAuthorizationHandler(request.supportedNetworks) else {
            completion(.failure(ApplePayError.networkNotSupported))
            return
        }
        guard let paymentVC = controllerFactory(request) else {
            completion(.failure(ApplePayError.unableToInitialize))
            return
        }
        completion(.success(paymentVC))
    }
}
