//
//  PassKit+TestHelpers.swift
//  ShortcutFoundation
//
//  Created by Swathi on 2022-02-14.
//  Copyright © 2022 Shortcut Scandinavia Apps AB. All rights reserved.
//

#if canImport(PassKit)
import PassKit
import ShortcutFoundation

enum TestStrings: String {
    case invalidCurrency = "XYZ"
    case invalidCountry = "ab"
    case merchantId = "test.merchant.identifier"
    case validCountry = "US"
    case validCurrency = "USD"
    case paymentTitle = "parking ticket"
}

extension PKPaymentRequest {
    
    static var validRequest: PKPaymentRequest {
        let paymentNetworks: [PKPaymentNetwork] = [.amex, .discover, .masterCard, .visa]
        let paymentItem = PKPaymentSummaryItem(label: TestStrings.paymentTitle.rawValue, amount: NSDecimalNumber(value: 22.0))
        let request = PKPaymentRequest()
        request.currencyCode = TestStrings.validCurrency.rawValue
        request.countryCode = TestStrings.validCountry.rawValue
        request.merchantIdentifier = TestStrings.merchantId.rawValue
        request.merchantCapabilities = PKMerchantCapability.capability3DS
        request.supportedNetworks = paymentNetworks
        request.paymentSummaryItems = [paymentItem]
        return request
    }
    
    static var invalidRequest: PKPaymentRequest {
        let paymentNetworks: [PKPaymentNetwork] = [.amex, .discover, .masterCard, .visa]
        let paymentItem = PKPaymentSummaryItem(label: TestStrings.paymentTitle.rawValue, amount: NSDecimalNumber(value: 22.0))
        let request = PKPaymentRequest()
        request.currencyCode = TestStrings.invalidCurrency.rawValue
        request.countryCode = TestStrings.invalidCountry.rawValue
        request.merchantIdentifier = TestStrings.merchantId.rawValue
        request.merchantCapabilities = PKMerchantCapability.capability3DS
        request.supportedNetworks = paymentNetworks
        request.paymentSummaryItems = [paymentItem]
        return request
    }
}

extension PaymentModel {
    
    static var validPayment: PaymentModel {
        return PaymentModel(name: TestStrings.paymentTitle.rawValue,
                            cost: NSDecimalNumber(value: 120.0),
                            countryCode: TestStrings.validCountry.rawValue,
                            currency: TestStrings.validCurrency.rawValue)
    }
    
    static var invalidCountry: PaymentModel {
        return PaymentModel(name: TestStrings.paymentTitle.rawValue,
                            cost: NSDecimalNumber(value: 120.0),
                            countryCode: TestStrings.invalidCountry.rawValue,
                            currency: TestStrings.validCurrency.rawValue)
    }
    
    static var invalidCurrency: PaymentModel {
        return PaymentModel(name: TestStrings.paymentTitle.rawValue,
                            cost: NSDecimalNumber(value: 120.0),
                            countryCode: TestStrings.validCountry.rawValue,
                            currency: TestStrings.invalidCurrency.rawValue)
    }
}
#endif
