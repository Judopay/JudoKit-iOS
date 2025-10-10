//
//  XCUIApplication+Additions.swift
//  ObjectiveCExampleAppUITests
//
//  Copyright © 2023 Judopay. All rights reserved.
//

import XCTest

extension XCUIApplication {
    
    func cellWithIdentifier(_ identifier: String) -> XCUIElement? {
        return cells.matching(identifier: identifier).firstMatch
    }
    
    func textFieldWithIdentifier(_ identifier: String) -> XCUIElement? {
        return otherElements.matching(identifier: identifier).firstMatch
    }

    func buttonWithIdentifier(_ identifier: String) -> XCUIElement? {
        return buttons.matching(identifier: identifier).firstMatch
    }
    
    func buttonWithLabel(_ label: String) -> XCUIElement? {
        return buttons.matching(NSPredicate(format: "label == %@", label)).firstMatch
    }
    
    func textWithIdentifier(_ identifier: String) -> XCUIElement? {
        return staticTexts.matching(identifier: identifier).firstMatch
    }
    
    func textWithLabel(_ label: String) -> XCUIElement? {
        return staticTexts.matching(NSPredicate(format: "label CONTAINS %@", label)).firstMatch
    }
    
    func switchWithLabel(_ label: String) -> XCUIElement? {
        return switches.matching(NSPredicate(format: "label CONTAINS %@", label)).firstMatch
    }
        
    var cardNumberTextField: XCUIElement? {
        get {
            return textFieldWithIdentifier(Selectors.CardEntry.cardNumberField)
        }
    }
    
    var cardholderTextField: XCUIElement? {
        get {
            return textFieldWithIdentifier(Selectors.CardEntry.cardHolderNameField)
        }
    }
    
    var expiryDateTextField: XCUIElement? {
        get {
            return textFieldWithIdentifier(Selectors.CardEntry.expiryDateField)
        }
    }
    
    var securityCodeTextField: XCUIElement? {
        get {
            return textFieldWithIdentifier(Selectors.CardEntry.securityCodeField)
        }
    }
    
    var cardDetailsSubmitButton: XCUIElement? {
        get {
            return buttonWithIdentifier(Selectors.CardEntry.cardDetailsSubmitButtonSelector)
        }
    }
    
    var settingsButton: XCUIElement? {
        get {
            return buttonWithIdentifier(Selectors.FeatureList.settingsSectionButton)
        }
    }
    
    var cancelButton: XCUIElement? {
        get {
            return buttonWithLabel(Selectors.CardEntry.cancelCardEntryButton)
        }
    }
    
    var cancelButton3DS2: XCUIElement? {
        get {
            return buttonWithLabel(Selectors.Other.threeDS2CancelButton)
        }
    }
    
    var tokenizeNewCardButton: XCUIElement? {
        get {
            return buttonWithLabel(Selectors.TokenPayments.tokenizeNewCardButtonSelector)
        }
    }
    
    var tokenPaymentButton: XCUIElement? {
        get {
            return buttonWithLabel(Selectors.TokenPayments.tokenPaymentButtonSelector)
        }
    }
    
    var tokenPreauthButton: XCUIElement? {
        get {
            return buttonWithLabel(Selectors.TokenPayments.tokenPreAuthButton)
        }
    }
    
    var addCard: XCUIElement? {
        get {
            return buttonWithLabel(Selectors.PaymentMethods.addNewCardButton)
        }
    }
    
    var payNowButton: XCUIElement? {
        get {
            return buttonWithLabel(Selectors.PaymentMethods.payNowButtonSelector)
        }
    }
    
    var editCardsButton: XCUIElement? {
        get {
            return buttonWithLabel(Selectors.PaymentMethods.editCardsButtonSelector)
        }
    }
    
    var deleteCardButton: XCUIElement? {
        get {
            return buttonWithLabel(Selectors.PaymentMethods.deleteCardButtonSelector)
        }
    }
    
    var emailField: XCUIElement? {
        get {
            return textFieldWithIdentifier(Selectors.BillingInfo.emailField)
        }
    }
    
    var mobileField: XCUIElement? {
        get {
            return textFieldWithIdentifier(Selectors.BillingInfo.phoneField)
        }
    }
    
    var addressLineOne: XCUIElement? {
        get {
            return textFieldWithIdentifier(Selectors.BillingInfo.addressOneField)
        }
    }
    
    var addressLineTwo: XCUIElement? {
        get {
            return textFieldWithIdentifier(Selectors.BillingInfo.addressTwoField)
        }
    }
    
    var cityField: XCUIElement? {
        get {
            return textFieldWithIdentifier(Selectors.BillingInfo.cityField)
        }
    }
    
    var postCodeField: XCUIElement? {
        get {
            return textFieldWithIdentifier(Selectors.BillingInfo.postCodeField)
        }
    }
    
    var administrativeDivisionField: XCUIElement? {
        get {
            return textFieldWithIdentifier(Selectors.BillingInfo.administrativeDivisionField)
        }
    }
    
    var countryField: XCUIElement? {
        get {
            return textFieldWithIdentifier(Selectors.BillingInfo.countryField)
        }
    }
        
    var addAddressLineButton: XCUIElement? {
        get {
            return buttonWithIdentifier(Selectors.BillingInfo.addAddressLineButton)
        }
    }
    
    var fieldErrorLabel: String? {
        get {
            return textWithIdentifier(Selectors.BillingInfo.fieldErrorLabel)?.label
        }
    }
    
    var wormholyButton: XCUIElement? {
        get {
            return buttonWithIdentifier(Selectors.Other.wormholyButton)
        }
    }
    
    var paymentRequestLabel: XCUIElement? {
        get {
            return textWithLabel(Selectors.Other.paymentsRequestLabel)
        }
    }
    
    var viewRequestBodyLabel: XCUIElement? {
        get {
            return textWithLabel(Selectors.Other.viewBodyLabel)
        }
    }
    
    var dismissLabel: XCUIElement? {
        get {
            return buttonWithIdentifier(Selectors.Other.dismissButton)
        }
    }
    
    var searchButton: XCUIElement? {
        get {
            return buttonWithLabel(Selectors.Other.searchButton)
        }
    }
    
    var haltTransactionSwitch: XCUIElement? {
        get {
            return switchWithLabel(Selectors.Other.haltTransactionSwitch)
        }
    }
    
    var haltTransactionSwitchValue: String? {
        (switchWithLabel(Selectors.Other.haltTransactionSwitch)?.value as? String)
    }
    
    var backButton: XCUIElement? {
        get {
            return buttonWithLabel(Selectors.Other.backButton)
        }
    }
    
    func configureSettings(isRavelinTest: Bool, isFabrickTest: Bool = false) {
        let judoID: String?
        let apiToken: String?
        let apiSecret: String?
        
        if isFabrickTest {
            judoID = ProcessInfo.processInfo.environment["FABRICK3DS_JUDO_ID"]
            apiToken = ProcessInfo.processInfo.environment["FABRICK3DS_API_TOKEN"]
            apiSecret = ProcessInfo.processInfo.environment["FABRICK3DS_API_SECRET"]
        } else {
            judoID = ProcessInfo.processInfo.environment["TEST_API_JUDO_ID"]
            apiToken = ProcessInfo.processInfo.environment["TEST_API_TOKEN"]
            apiSecret = ProcessInfo.processInfo.environment["TEST_API_SECRET"]
        }

        launchArguments += ["-judo_id", judoID ?? "",
                            "-token", apiToken ?? "",
                            "-secret", apiSecret ?? "",]
        
        launchArguments += ["-is_sandboxed", "true",
                            "-is_token_and_secret_on", "true",
                            "-should_ask_for_billing_information", "false",
                            "-is_recommendation_enabled", "false"]
        
        if isRavelinTest {
            launchArguments += ["-is_payment_session_on", "true",
                                "-should_ask_for_billing_information", "false",
                                "-is_token_and_secret_on", "false",
                                "-is_recommendation_enabled", "true"]
        }
    }
    
    func configureRavelin(suffix: String) {
        
        let rsaPublicKey = ProcessInfo.processInfo.environment["RSA_PUBLIC_KEY"]
        let ravelinMockServerURL = ProcessInfo.processInfo.environment["RAVELIN_MOCK_SERVER_URL"]
        
        let url = (ravelinMockServerURL ?? "") + suffix
        
        launchArguments += ["-is_recommendation_enabled", "true",
                            "-rsa_key", rsaPublicKey ?? "",
                            "-recommendation_url", url]
    }
    
    func fillCardSheetDetails(cardNumber: String, cardHolder: String, expiryDate: String, securityCode: String) {
        cardNumberTextField?.tapAndTypeText(cardNumber)
        cardholderTextField?.tapAndTypeText(cardHolder)
        expiryDateTextField?.tapAndTypeText(expiryDate)
        securityCodeTextField?.tapAndTypeText(securityCode)
    }
    
    func fillBillingInfoDetails(email: String, phone: String, addressOne: String, addressTwo: String, city: String, postCode: String) {
        emailField?.tapAndTypeText(email)
        mobileField?.tapAndTypeText(phone)
        addressLineOne?.tapAndTypeText(addressOne)
        addAddressLineButton?.tap()
        addressLineTwo?.tapAndTypeText(addressTwo)
        cityField?.tapAndTypeText(city)
        postCodeField?.tapAndTypeText(postCode)
    }
    
    func clearTextFieldByIndex(index: Int) {
        let textField = textFields.element(boundBy: index)
        textField.tap(withNumberOfTaps: 3, numberOfTouches: 1)
        textField.typeText(XCUIKeyboardKey.delete.rawValue)
    }
    
    func ravelinTestSetup() {
        launchArguments += ["-payment_reference", "RAVELIN-" + NSUUID().uuidString, "-consumer_reference", "RAVELIN-TESTING"]
        launch()
        settingsButton?.tap()
        clearTextFieldByIndex(index: 2)
        staticTexts["Generate Payment Session"].tap()
        sleep(3)
    }
}
