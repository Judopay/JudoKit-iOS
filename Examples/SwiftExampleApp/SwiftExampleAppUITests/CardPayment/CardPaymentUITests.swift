//
//  CardPaymentUITests.swift
//  SwiftExampleAppUITests
//
//  Created by Eugene Zhernakov on 19/09/2024.
//  Copyright © 2024 Judopay. All rights reserved.
//

import XCTest

final class CardPaymentUITests: XCTestCase {
    var app: XCUIApplication!
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.configureSettings(isRavelinTest: false)
        addUIInterruptionMonitor(withDescription: "System Dialog") { (alert) -> Bool in
            alert.buttons["Allow While Using App"].tap()
            return true
        }
    }

    func testCancelledTransactionErrorPopupShouldBeDisplayed() {
        app.launch()
        app.textWithIdentifier(Selectors.FeatureList.payWithCard)?.tap()
        app.cancelButton?.tap()
        let alert = app.textWithIdentifier(Constants.Other.cancelledPaymentAlert)
        XCTAssert(alert!.exists, "Alert message not displayed")
    }

    func testOnValidCardDetailsInputSubmitButtonShouldBeEnabled() {
        app.launch()
        app.textWithIdentifier(Selectors.FeatureList.payWithCard)?.tap()
        app.fillWithStandardCardDetails()
        XCTAssertTrue(app.cardDetailsSubmitButton!.isEnabled)
    }

    func testSuccessfulTransaction() {
        app.launch()
        app.textWithIdentifier(Selectors.FeatureList.payWithCard)?.tap()
        app.fillWithStandardCardDetails()
        app.cardDetailsSubmitButton?.tap()
        tapCompleteButton(app)
        assertResultObject(app, "Payment", "AuthCode: ", "Success")
    }

    func testDeclinedTransaction() {
        app.launch()
        app.textWithIdentifier(Selectors.FeatureList.payWithCard)?.tap()
        app.fillCardSheetDetails(cardNumber: Constants.CardDetails.cardNumber,
                                 cardHolder: Constants.CardDetails.cardHolderName,
                                 expiryDate: Constants.CardDetails.cardExpiry,
                                 securityCode: "123")
        app.cardDetailsSubmitButton?.tap()
        tapCompleteButton(app)
        assertResultObject(app, "Payment", "Card declined: Additional customer authentication required", "Declined")
    }

    func testFailedTransaction() {
        app.launch()
        app.textWithIdentifier(Selectors.FeatureList.payWithCard)?.tap()
        app.fillCardSheetDetails(cardNumber: "4111 1111 1111 1111",
                                 cardHolder: Constants.CardDetails.cardHolderName,
                                 expiryDate: Constants.CardDetails.cardExpiry,
                                 securityCode: "123")
        app.cardDetailsSubmitButton?.tap()
        tapCompleteButton(app)
        assertResultObject(app, "Payment", "The gateway reported an error", "Error")
    }

    func testCancel3DS2ChallengeScreenErrorPopupShouldBeDisplayed() {
        app.launch()
        app.textWithIdentifier(Selectors.FeatureList.payWithCard)?.tap()
        app.fillWithStandardCardDetails()
        app.cardDetailsSubmitButton?.tap()
        let cancelButton = app.buttons["Cancel"]
        XCTAssert(cancelButton.waitForExistence(timeout: 10))
        app.cancelButton3DS2?.tap()
    }

    func testSuccessfulPreauthTransaction() {
        app.launch()
        app.textWithIdentifier(Selectors.FeatureList.preAuthWithCard)?.tap()
        app.fillWithStandardCardDetails()
        app.cardDetailsSubmitButton?.tap()
        tapCompleteButton(app)
        assertResultObject(app, "PreAuth", "AuthCode: ", "Success")
    }

    func testSuccessfulRegisterCardTransaction() {
        app.launch()
        app.textWithIdentifier(Selectors.FeatureList.registerCard)?.tap()
        app.fillWithStandardCardDetails()
        app.cardDetailsSubmitButton?.tap()
        tapCompleteButton(app)
        assertResultObject(app, "Register", "AuthCode: ", "Success")
    }

    func testSuccessfulCheckCardTransaction() {
        app.launch()
        app.textWithIdentifier(Selectors.FeatureList.checkCard)?.tap()
        app.fillWithStandardCardDetails()
        app.cardDetailsSubmitButton?.tap()
        tapCompleteButton(app)
        assertResultObject(app, "CheckCard", "AuthCode: ", "Success")
    }

    func testSuccessfulTokenPayment() {
        app.launchArguments += ["-should_ask_for_csc", "true"]
        app.launch()
        app.textWithIdentifier(Selectors.FeatureList.tokenPayment)?.tap()
        app.textWithIdentifier(Selectors.TokenPayments.tokenizeNewCardButtonSelector)?.tap()
        app.fillWithStandardCardDetails()
        app.cardDetailsSubmitButton?.tap()
        app.textWithIdentifier(Selectors.TokenPayments.tokenPaymentButtonSelector)?.tap()
        app.securityCodeTextField?.tapAndTypeText(Constants.CardDetails.cardSecurityCode)
        app.cardDetailsSubmitButton?.tap()
        tapCompleteButton(app)
        assertResultObject(app, "Payment", "AuthCode: ", "Success")
    }

    func testSuccessfulTokenPreauth() {
        app.launchArguments += ["-should_ask_for_csc", "true"]
        app.launch()
        app.textWithIdentifier(Selectors.FeatureList.tokenPayment)?.tap()
        app.textWithIdentifier(Selectors.TokenPayments.tokenizeNewCardButtonSelector)?.tap()
        app.fillWithStandardCardDetails()
        app.cardDetailsSubmitButton?.tap()
        app.textWithIdentifier(Selectors.TokenPayments.tokenPreAuthButton)?.tap()
        app.securityCodeTextField?.tapAndTypeText(Constants.CardDetails.cardSecurityCode)
        app.cardDetailsSubmitButton?.tap()
        tapCompleteButton(app)
        assertResultObject(app, "PreAuth", "AuthCode: ", "Success")
    }

    func testSuccessfulFrictionlessPayment() {
        app.launchArguments += ["-challenge_request_indicator", "noPreference"]
        app.launch()
        app.textWithIdentifier(Selectors.FeatureList.payWithCard)?.tap()
        app.fillCardSheetDetails(cardNumber: Constants.CardDetails.cardNumber,
                                 cardHolder: "Frictionless Successful",
                                 expiryDate: Constants.CardDetails.cardExpiry,
                                 securityCode: Constants.CardDetails.cardSecurityCode)
        app.cardDetailsSubmitButton?.tap()
        assertResultObject(app, "Payment", "AuthCode: ", "Success")
    }

    func testFrictionlessNoMethodPayment() {
        app.launchArguments += ["-challenge_request_indicator", "noPreference"]
        app.launch()
        app.textWithIdentifier(Selectors.FeatureList.payWithCard)?.tap()
        app.fillCardSheetDetails(cardNumber: Constants.CardDetails.cardNumber,
                                 cardHolder: "Frictionless NoMethod",
                                 expiryDate: Constants.CardDetails.cardExpiry,
                                 securityCode: Constants.CardDetails.cardSecurityCode)
        app.cardDetailsSubmitButton?.tap()
        assertResultObject(app, "Payment", "AuthCode: ", "Success")
    }

    func testFrictionlessAuthFailedPayment() {
        app.launchArguments += ["-challenge_request_indicator", "noPreference"]
        app.launch()
        app.textWithIdentifier(Selectors.FeatureList.payWithCard)?.tap()
        app.fillCardSheetDetails(cardNumber: Constants.CardDetails.cardNumber,
                                 cardHolder: "Frictionless AuthFailed",
                                 expiryDate: Constants.CardDetails.cardExpiry,
                                 securityCode: Constants.CardDetails.cardSecurityCode)
        app.cardDetailsSubmitButton?.tap()
    }

    func testSuccessfulPaymentMethodsCardPayment() {
        app.launchArguments += ["-should_ask_for_csc", "true"]
        app.launch()
        app.swipeUp()
        app.textWithIdentifier(Selectors.FeatureList.paymentMethods)?.tap()
        app.addCard?.tap()
        app.fillWithStandardCardDetails()
        app.cardDetailsSubmitButton?.tap()
        app.payNowButton?.tap()
        app.securityCodeTextField?.tapAndTypeText(Constants.CardDetails.cardSecurityCode)
        app.cardDetailsSubmitButton?.tap()
        tapCompleteButton(app)
        assertResultObject(app, "Payment", "AuthCode: ", "Success")
    }

    func testSuccessfulPreauthMethodsCardPayment() {
        app.launchArguments += ["-should_ask_for_csc", "true"]
        app.launch()
        app.swipeUp()
        app.textWithIdentifier(Selectors.FeatureList.preAuthMethods)?.tap()
        app.addCard?.tap()
        app.fillWithStandardCardDetails()
        app.cardDetailsSubmitButton?.tap()
        app.payNowButton?.tap()
        app.securityCodeTextField?.tapAndTypeText(Constants.CardDetails.cardSecurityCode)
        app.cardDetailsSubmitButton?.tap()
        tapCompleteButton(app)
        assertResultObject(app, "PreAuth", "AuthCode: ", "Success")
    }

    func testRemoveCardOnPaymentMethods() {
        app.launch()
        app.textWithIdentifier(Selectors.FeatureList.paymentMethods)?.tap()
        app.addCard?.tap()
        app.fillCardSheetDetails(cardNumber: "4222 0000 0122 7408",
                                 cardHolder: Constants.CardDetails.cardHolderName,
                                 expiryDate: Constants.CardDetails.cardExpiry,
                                 securityCode: Constants.CardDetails.cardSecurityCode)
        app.cardDetailsSubmitButton?.tap()
        let newCard = app.staticTexts["Visa Ending 7408 "]
        XCTAssert(newCard.waitForExistence(timeout: 5), "Unable to add a new card")
        newCard.swipeLeft()
        // Two taps are required to delete and confirm deletion of a card
        app.deleteCardButton?.tap()
        app.deleteCardButton?.tap()
        XCTAssertFalse(newCard.waitForExistence(timeout: 5), "Unable to delete card")
    }

    func testSuccessfulPaymentWithBillingDetails() {
        app.launchArguments += ["-should_ask_for_billing_information", "true"]
        app.launch()
        app.textWithIdentifier(Selectors.FeatureList.payWithCard)?.tap()
        app.fillWithStandardCardDetails()
        XCTAssertTrue(app.cardDetailsSubmitButton!.isEnabled)
        app.cardDetailsSubmitButton?.tap()
        app.fillBillingInfoDetails(email: Constants.BillingInfo.validEmail,
                                   phone: Constants.BillingInfo.validMobile,
                                   addressOne: Constants.BillingInfo.validAddress,
                                   addressTwo: Constants.BillingInfo.validAddressTwo,
                                   city: Constants.BillingInfo.validCity,
                                   postCode: Constants.BillingInfo.validPostcode)
        XCTAssertTrue(app.cardDetailsSubmitButton!.isEnabled)
        app.cardDetailsSubmitButton?.tap()
        tapCompleteButton(app)
        assertResultObject(app, "Payment", "AuthCode: ", "Success")
        assertBillingInfo(app, Constants.BillingInfo.validCity, Constants.BillingInfo.validAddress, Constants.BillingInfo.validAddressTwo, Constants.BillingInfo.validPostcode)
    }

    func testUKPostCodeValidation() {
        app.launchArguments += ["-should_ask_for_billing_information", "true"]
        app.launch()
        app.textWithIdentifier(Selectors.FeatureList.payWithCard)?.tap()
        app.fillWithStandardCardDetails()
        XCTAssertTrue(app.cardDetailsSubmitButton!.isEnabled)
        app.cardDetailsSubmitButton?.tap()
        app.fillBillingInfoDetails(email: Constants.BillingInfo.validEmail,
                                   phone: Constants.BillingInfo.validMobile,
                                   addressOne: Constants.BillingInfo.validAddress,
                                   addressTwo: Constants.BillingInfo.validAddressTwo,
                                   city: Constants.BillingInfo.validCity,
                                   postCode: Constants.BillingInfo.invalidPostcode)
        app.mobileField?.tap()
        XCTAssertEqual(app.fieldErrorLabel, Constants.BillingInfo.invalidPostcodeLabel)
        XCTAssertFalse(app.cardDetailsSubmitButton!.isEnabled)
    }

    func testUSPostCodeValidation() throws {
        guard #available(iOS 16, *) else {
            throw XCTSkip("Skipping due to picker wheel selection being buggy on lower versions of iOS")
        }
        app.launchArguments += ["-should_ask_for_billing_information", "true"]
        app.launch()
        app.textWithIdentifier(Selectors.FeatureList.payWithCard)?.tap()
        app.fillWithStandardCardDetails()
        XCTAssertTrue(app.cardDetailsSubmitButton!.isEnabled)
        app.cardDetailsSubmitButton?.tap()
        app.countryField?.tap()
        app.pickerWheels.element(boundBy: 0).adjust(toPickerWheelValue: "United States")
        app.stateField?.tap()
        app.pickerWheels.element(boundBy: 0).adjust(toPickerWheelValue: "California")

        app.fillBillingInfoDetails(email: Constants.BillingInfo.validEmail,
                                   phone: Constants.BillingInfo.validMobile,
                                   addressOne: Constants.BillingInfo.validAddress,
                                   addressTwo: Constants.BillingInfo.validAddressTwo,
                                   city: Constants.BillingInfo.validCity,
                                   postCode: Constants.BillingInfo.invalidPostcode)
        app.cityField?.tap()
        XCTAssertEqual(app.fieldErrorLabel, Constants.BillingInfo.invalidZIPCodeLabel)
        XCTAssertFalse(app.cardDetailsSubmitButton!.isEnabled)
    }

    func testCAPostCodeValidation() throws {
        guard #available(iOS 16, *) else {
            throw XCTSkip("Skipping due to picker wheel selection being buggy on lower versions of iOS")
        }
        app.launchArguments += ["-should_ask_for_billing_information", "true"]
        app.launch()
        app.textWithIdentifier(Selectors.FeatureList.payWithCard)?.tap()
        app.fillWithStandardCardDetails()
        XCTAssertTrue(app.cardDetailsSubmitButton!.isEnabled)
        app.cardDetailsSubmitButton?.tap()
        app.countryField?.tap()
        app.pickerWheels.element(boundBy: 0).adjust(toPickerWheelValue: "Canada")
        app.stateField?.tap()
        app.pickerWheels.element(boundBy: 0).adjust(toPickerWheelValue: "Ontario")
        app.fillBillingInfoDetails(email: Constants.BillingInfo.validEmail,
                                   phone: Constants.BillingInfo.validMobile,
                                   addressOne: Constants.BillingInfo.validAddress,
                                   addressTwo: Constants.BillingInfo.validAddressTwo,
                                   city: Constants.BillingInfo.validCity,
                                   postCode: Constants.BillingInfo.invalidPostcode)
        app.cityField?.tap()
        XCTAssertEqual(app.fieldErrorLabel, Constants.BillingInfo.invalidPostcodeLabel)
        XCTAssertFalse(app.cardDetailsSubmitButton!.isEnabled)
    }

    func testBillingFieldsInputValidation() {
        app.launchArguments += ["-should_ask_for_billing_information", "true"]
        app.launch()
        app.textWithIdentifier(Selectors.FeatureList.payWithCard)?.tap()
        app.fillWithStandardCardDetails()
        XCTAssertTrue(app.cardDetailsSubmitButton!.isEnabled)
        app.cardDetailsSubmitButton?.tap()
        validateBillingInfoFields(app)
    }

    func testStepUpPaymentTransaction() {
        app.launchArguments += ["-challenge_request_indicator", "noPreference", "-sca_exemption", "lowValue"]
        app.launch()
        app.textWithIdentifier(Selectors.FeatureList.payWithCard)?.tap()
        app.fillCardSheetDetails(cardNumber: Constants.CardDetails.cardNumber,
                             cardHolder: "Frictionless Successful",
                             expiryDate: Constants.CardDetails.cardExpiry,
                             securityCode: Constants.CardDetails.wrongCV2)
        app.cardDetailsSubmitButton?.tap()
        tapCompleteButton(app)
        assertResultObject(app, "Payment", "Card declined: CV2 policy", "Declined")
    }

    func testStepUpPreauthTransaction() {
        app.launchArguments += ["-challenge_request_indicator", "noPreference", "-sca_exemption", "lowValue"]
        app.launch()
        app.textWithIdentifier(Selectors.FeatureList.preAuthWithCard)?.tap()
        app.fillCardSheetDetails(cardNumber: Constants.CardDetails.cardNumber,
                             cardHolder: "Frictionless Successful",
                             expiryDate: Constants.CardDetails.cardExpiry,
                             securityCode: Constants.CardDetails.wrongCV2)
        app.cardDetailsSubmitButton?.tap()
        tapCompleteButton(app)
        assertResultObject(app, "PreAuth", "Card declined: CV2 policy", "Declined")
    }
}
