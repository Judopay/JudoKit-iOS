//
//  XCUIApplication+Additions.swift
//  SwiftExampleAppUITests
//
//  Created by Eugene Zhernakov on 19/09/2024.
//  Copyright © 2024 Judopay. All rights reserved.
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
        return textFieldWithIdentifier(Selectors.CardEntry.cardNumberField)
    }

    var cardholderTextField: XCUIElement? {
        return textFieldWithIdentifier(Selectors.CardEntry.cardHolderNameField)
    }

    var expiryDateTextField: XCUIElement? {
        return textFieldWithIdentifier(Selectors.CardEntry.expiryDateField)
    }

    var securityCodeTextField: XCUIElement? {
        return textFieldWithIdentifier(Selectors.CardEntry.securityCodeField)
    }

    var cardDetailsSubmitButton: XCUIElement? {
        return buttonWithIdentifier(Selectors.CardEntry.cardDetailsSubmitButtonSelector)
    }

    var settingsButton: XCUIElement? {
        return buttonWithIdentifier(Selectors.FeatureList.settingsSectionButton)
    }

    var cancelButton: XCUIElement? {
        return buttonWithLabel(Selectors.CardEntry.cancelCardEntryButton)
    }

    var cancelButton3DS2: XCUIElement? {
        return buttonWithLabel(Selectors.Other.threeDS2CancelButton)
    }

    var tokenizeNewCardButton: XCUIElement? {
        return buttonWithLabel(Selectors.TokenPayments.tokenizeNewCardButtonSelector)
    }

    var tokenPaymentButton: XCUIElement? {
        return buttonWithLabel(Selectors.TokenPayments.tokenPaymentButtonSelector)
    }

    var tokenPreauthButton: XCUIElement? {
        return buttonWithLabel(Selectors.TokenPayments.tokenPreAuthButton)
    }

    var addCard: XCUIElement? {
        return buttonWithLabel(Selectors.PaymentMethods.addNewCardButton)
    }

    var payNowButton: XCUIElement? {
        return buttonWithLabel(Selectors.PaymentMethods.payNowButtonSelector)
    }

    var editCardsButton: XCUIElement? {
        return buttonWithLabel(Selectors.PaymentMethods.editCardsButtonSelector)
    }

    var deleteCardButton: XCUIElement? {
        return buttonWithLabel(Selectors.PaymentMethods.deleteCardButtonSelector)
    }

    var emailField: XCUIElement? {
        return textFieldWithIdentifier(Selectors.BillingInfo.emailField)
    }

    var mobileField: XCUIElement? {
        return textFieldWithIdentifier(Selectors.BillingInfo.phoneField)
    }

    var addressLineOne: XCUIElement? {
        return textFieldWithIdentifier(Selectors.BillingInfo.addressOneField)
    }

    var addressLineTwo: XCUIElement? {
        return textFieldWithIdentifier(Selectors.BillingInfo.addressTwoField)
    }

    var cityField: XCUIElement? {
        return textFieldWithIdentifier(Selectors.BillingInfo.cityField)
    }

    var postCodeField: XCUIElement? {
        return textFieldWithIdentifier(Selectors.BillingInfo.postCodeField)
    }

    var administrativeDivisionField: XCUIElement? {
        return textFieldWithIdentifier(Selectors.BillingInfo.administrativeDivisionField)
    }

    var countryField: XCUIElement? {
        return textFieldWithIdentifier(Selectors.BillingInfo.countryField)
    }

    var addAddressLineButton: XCUIElement? {
        return buttonWithIdentifier(Selectors.BillingInfo.addAddressLineButton)
    }

    var fieldErrorLabel: String? {
        return textWithIdentifier(Selectors.BillingInfo.fieldErrorLabel)?.label
    }

    func configureSettings(isRavelinTest: Bool) {
        let judoID = ProcessInfo.processInfo.environment["TEST_API_JUDO_ID"]
        let apiToken = ProcessInfo.processInfo.environment["TEST_API_TOKEN"]
        let apiSecret = ProcessInfo.processInfo.environment["TEST_API_SECRET"]

        launchArguments += ["-judo_id", judoID ?? "",
                            "-token", apiToken ?? "",
                            "-secret", apiSecret ?? ""]

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

    func fillWithStandardCardDetails() {
        fillCardSheetDetails(cardNumber: Constants.CardDetails.cardNumber,
                                 cardHolder: Constants.CardDetails.cardHolderName,
                                 expiryDate: Constants.CardDetails.cardExpiry,
                                 securityCode: Constants.CardDetails.cardSecurityCode)
    }
}
