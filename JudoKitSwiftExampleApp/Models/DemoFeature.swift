import Foundation

enum DemoFeatureType {
    case payment
    case preAuth
    case createCardToken
    case saveCard
    case repeatPayment
    case tokenPreAuth
    case applePayPayment
    case applePayPreAuth
    case paymentMethods
    case standaloneApplePayButton
}

struct DemoFeature {
    let type: DemoFeatureType
    let title: String
    let details: String
    let action: Selector
}

let defaultFeatures = [
    DemoFeature(type: .payment,
                title: "Payment",
                details: "with default settings",
                action: #selector(MainViewController.pay)),

    DemoFeature(type: .preAuth,
                title: "PreAuth",
                details: "to reserve funds on a card",
                action: #selector(MainViewController.preAuth)),

    DemoFeature(type: .createCardToken,
                title: "Register card",
                details: "to be stored for future transactions",
                action: #selector(MainViewController.createCardToken)),

    DemoFeature(type: .saveCard,
                title: "Save card",
                details: "to be stored for future transactions",
                action: #selector(MainViewController.saveCard)),

    DemoFeature(type: .repeatPayment,
                title: "Token payment",
                details: "with a stored card token",
                action: #selector(MainViewController.repeatPayment)),

    DemoFeature(type: .tokenPreAuth,
                title: "Token preAuth",
                details: "with a stored card token",
                action: #selector(MainViewController.tokenPreAuth)),

    DemoFeature(type: .applePayPayment,
                title: "Apple Pay payment",
                details: "with a wallet card",
                action: #selector(MainViewController.applePayPayment)),

    DemoFeature(type: .applePayPreAuth,
                title: "Apple Pay preAuth",
                details: "with a wallet card",
                action: #selector(MainViewController.applePayPreAuth)),

    DemoFeature(type: .paymentMethods,
                title: "Payment Method",
                details: "with default payment methods",
                action: #selector(MainViewController.navigateToPaymentMethods)),

    DemoFeature(type: .standaloneApplePayButton,
                title: "Apple Pay Button",
                details: "standalone ApplePay Button",
                action: #selector(MainViewController.navigateToStandaloneApplePayButton))
]
