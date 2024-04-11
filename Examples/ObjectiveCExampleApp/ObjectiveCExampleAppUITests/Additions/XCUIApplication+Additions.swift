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
        
    var cardNumberTextField: XCUIElement? {
        get {
            return textFieldWithIdentifier(Selectors.cardNumberField)
        }
    }
    
    var cardholderTextField: XCUIElement? {
        get {
            return textFieldWithIdentifier(Selectors.cardHolderNameField)
        }
    }
    
    var expiryDateTextField: XCUIElement? {
        get {
            return textFieldWithIdentifier(Selectors.expiryDateField)
        }
    }
    
    var securityCodeTextField: XCUIElement? {
        get {
            return textFieldWithIdentifier(Selectors.securityCodeField)
        }
    }
    
    var cardDetailsSubmitButton: XCUIElement? {
        get {
            return buttonWithIdentifier(Selectors.cardDetailsSubmitButtonSelector)
        }
    }
    
    var settingsButton: XCUIElement? {
        get {
            return buttonWithIdentifier(Selectors.settingsSectionButton)
        }
    }
    
    var cancelButton: XCUIElement? {
        get {
            return buttonWithLabel(Selectors.cancelCardEntryButton)
        }
    }
    
    var cancelButton3DS2: XCUIElement? {
        get {
            return buttonWithLabel(Selectors.threeDS2CancelButton)
        }
    }
    
    var tokenizeNewCardButton: XCUIElement? {
        get {
            return buttonWithLabel(Selectors.tokenizeNewCardButtonSelector)
        }
    }
    
    var tokenPaymentButton: XCUIElement? {
        get {
            return buttonWithLabel(Selectors.tokenPaymentButtonSelector)
        }
    }
    
    var tokenPreauthButton: XCUIElement? {
        get {
            return buttonWithLabel(Selectors.tokenPreAuthButton)
        }
    }
    
    var addCard: XCUIElement? {
        get {
            return buttonWithLabel(Selectors.addNewCardButton)
        }
    }
    
    var payNowButton: XCUIElement? {
        get {
            return buttonWithLabel(Selectors.payNowButtonSelector)
        }
    }
    
    var editCardsButton: XCUIElement? {
        get {
            return buttonWithLabel(Selectors.editCardsButtonSelector)
        }
    }
    
    var deleteCardButton: XCUIElement? {
        get {
            return buttonWithLabel(Selectors.deleteCardButtonSelector)
        }
    }
    
    var emailField: XCUIElement? {
        get {
            return textFieldWithIdentifier(Selectors.emailField)
        }
    }
    
    var mobileField: XCUIElement? {
        get {
            return textFieldWithIdentifier(Selectors.phoneField)
        }
    }
    
    var addressLineOne: XCUIElement? {
        get {
            return textFieldWithIdentifier(Selectors.addressOneField)
        }
    }
    
    var addressLineTwo: XCUIElement? {
        get {
            return textFieldWithIdentifier(Selectors.addressTwoField)
        }
    }
    
    var cityField: XCUIElement? {
        get {
            return textFieldWithIdentifier(Selectors.cityField)
        }
    }
    
    var postCodeField: XCUIElement? {
        get {
            return textFieldWithIdentifier(Selectors.postCodeField)
        }
    }
    
    var stateField: XCUIElement? {
        get {
            return textFieldWithIdentifier(Selectors.stateField)
        }
    }
    
    var countryField: XCUIElement? {
        get {
            return textFieldWithIdentifier(Selectors.countryField)
        }
    }
        
    var addAddressLineButton: XCUIElement? {
        get {
            return buttonWithIdentifier(Selectors.addAddressLineButton)
        }
    }
    
    var fieldErrorLabel: String? {
        get {
            guard let labelElement = textWithIdentifier(Selectors.fieldErrorLabel) else {
                return nil
            }
            return labelElement.label
        }
    }
    
    func configureSettings(isRavelinTest: Bool) {
        let judoID = ProcessInfo.processInfo.environment["TEST_API_JUDO_ID"]
        let apiToken = ProcessInfo.processInfo.environment["TEST_API_TOKEN"]
        let apiSecret = ProcessInfo.processInfo.environment["TEST_API_SECRET"]
        
        launchArguments += ["-judo_id", judoID ?? "",
                            "-token", apiToken ?? "",
                            "-secret", apiSecret ?? "",
                            "-is_sandboxed", "true",
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
    
    func configureRavelin(action: String, toa: String, exemption: String, challenge: String) {
        
        let rsaPublicKey = ProcessInfo.processInfo.environment["RSA_PUBLIC_KEY"]
        let ravelinMockServerURL = ProcessInfo.processInfo.environment["RAVELIN_MOCK_SERVER_URL"]
        
        let suffix = action + "/" + toa + "/" + exemption + "/" + challenge
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
