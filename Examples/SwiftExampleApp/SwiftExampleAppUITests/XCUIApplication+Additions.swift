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

    var stateField: XCUIElement? {
        return textFieldWithIdentifier(Selectors.BillingInfo.stateField)
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
    
    var idealNextButton: XCUIElement? {
        return buttonWithLabel(Selectors.Ideal.nextButton)
    }
    
    var idealLoginButton: XCUIElement? {
        return buttonWithLabel(Selectors.Ideal.loginButton)
    }
    
    var idealPaymentButton: XCUIElement? {
        return buttonWithLabel(Selectors.Ideal.makePaymentButton)
    }
    
    var idealBackButton: XCUIElement? {
        return buttonWithLabel(Selectors.Ideal.backButton)
    }
    
    var idealAbortButton: XCUIElement? {
        return buttonWithLabel(Selectors.Ideal.abortButton)
    }

    func configureSettings(isRavelinTest: Bool, isIdealTest: Bool) {
        let judoID = ProcessInfo.processInfo.environment["TEST_API_JUDO_ID"]
        let apiToken = ProcessInfo.processInfo.environment["TEST_API_TOKEN"]
        let apiSecret = ProcessInfo.processInfo.environment["TEST_API_SECRET"]
        
        let idealJudoID = ProcessInfo.processInfo.environment["IDEAL_JUDO_ID"]
        let idealToken = ProcessInfo.processInfo.environment["IDEAL_API_TOKEN"]
        let idealSecret = ProcessInfo.processInfo.environment["IDEAL_API_SECRET"]
        
        if isIdealTest {
            launchArguments += ["-judo_id", idealJudoID ?? "",
                                "-token", idealToken ?? "",
                                "-secret", idealSecret ?? "",
                                "-is_payment_method_ideal_enabled", "true",
                                "-is_payment_method_card_enabled", "false",
                                "-currency", "EUR"]
        } else {
            launchArguments += ["-judo_id", judoID ?? "",
                                "-token", apiToken ?? "",
                                "-secret", apiSecret ?? "",]
        }
        
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
    
    func assertIdealResultObject(_ app: XCUIApplication, _ paymentMethod: String, _ message: String) {
        let tableView = app.tables[Selectors.Other.resultsTable]
        XCTAssert(tableView.waitForExistence(timeout: 10))
        
        let receiptIdCell = tableView.cells.element(matching: .cell, identifier: "receiptId")
        let receiptIdValue = receiptIdCell.staticTexts.element(boundBy: 1).label
        XCTAssert(!receiptIdValue.isEmpty, "ReceiptId is empty")
        
        let paymentMethodCell = tableView.cells.element(matching: .cell, identifier: "paymentMethod")
        let paymentMethodValue = paymentMethodCell.staticTexts.element(boundBy: 1).label
        XCTAssertEqual(paymentMethodValue, paymentMethod, "Payment method value on result object does not match the expected string")
        
        let messageCell = tableView.cells.element(matching: .cell, identifier: "message")
        let messageValue = messageCell.staticTexts.element(boundBy: 1).label
        XCTAssertTrue(messageValue.hasPrefix(message), "Message value on result object does not start with the expected string")
    }
}
