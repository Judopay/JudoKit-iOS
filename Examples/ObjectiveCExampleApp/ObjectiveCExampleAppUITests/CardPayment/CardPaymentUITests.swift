//
//  CardPaymentUITests.swift
//  ObjectiveCExampleAppUITests
//
//  Copyright © 2023 Judopay. All rights reserved.
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

    func testOnValidCardDetailsInputSubmitButtonShouldBeEnabled() {
        app.launch()
        app.cellWithIdentifier(Selectors.FeatureList.payWithCard)?.tap()
        app.fillCardSheetDetails(cardNumber: TestData.CardDetails.cardNumber,
                             cardHolder: TestData.CardDetails.cardholderName,
                             expiryDate: TestData.CardDetails.cardExpiry,
                             securityCode: TestData.CardDetails.cardSecurityCode)
        XCTAssertTrue(app.cardDetailsSubmitButton!.isEnabled)
    }
    
    func testCancelledTransactionErrorPopupShouldBeDisplayed() {
        app.launch()
        app.cellWithIdentifier(Selectors.FeatureList.payWithCard)?.tap()
        app.cancelButton?.tap()
        sleep(1)
        let snackbar = app.textWithIdentifier(Selectors.Other.cancelledPaymentToastLabel)
        XCTAssert(snackbar!.exists, "Snackbar message not displayed")
    }
    
    func testSuccessfulTransaction() {
        app.launch()
        app.cellWithIdentifier(Selectors.FeatureList.payWithCard)?.tap()
        app.fillCardSheetDetails(cardNumber: TestData.CardDetails.cardNumber,
                             cardHolder: TestData.CardDetails.cardholderName,
                             expiryDate: TestData.CardDetails.cardExpiry,
                             securityCode: TestData.CardDetails.cardSecurityCode)
        tapCardDetailsPayNowButton(app)
        tapCompleteButton(app)
        assertResultObject(app, "Payment", "AuthCode: ", "Success")
    }
    
    func testDeclinedTransaction() {
        app.launch()
        app.cellWithIdentifier(Selectors.FeatureList.payWithCard)?.tap()
        app.fillCardSheetDetails(cardNumber: TestData.CardDetails.cardNumber,
                             cardHolder: TestData.CardDetails.cardholderName,
                             expiryDate: TestData.CardDetails.cardExpiry,
                             securityCode: "123")
        tapCardDetailsPayNowButton(app)
        tapCompleteButton(app)
        assertResultObject(app, "Payment", "Card declined: Additional customer authentication required", "Declined")
    }

    func testFailedTransaction() {
        app.launch()
        app.cellWithIdentifier(Selectors.FeatureList.payWithCard)?.tap()
        app.fillCardSheetDetails(cardNumber: "4111 1111 1111 1111",
                             cardHolder: TestData.CardDetails.cardholderName,
                             expiryDate: TestData.CardDetails.cardExpiry,
                             securityCode: "123")
        tapCardDetailsPayNowButton(app)
        tapCompleteButton(app)
        assertResultObject(app, "Payment", "The gateway reported an error", "Error")
    }
    
    func testCancel3DS2ChallengeScreenErrorPopupShouldBeDisplayed() {
        app.launch()
        app.cellWithIdentifier(Selectors.FeatureList.payWithCard)?.tap()
        app.fillCardSheetDetails(cardNumber: TestData.CardDetails.cardNumber,
                             cardHolder: TestData.CardDetails.cardholderName,
                             expiryDate: TestData.CardDetails.cardExpiry,
                             securityCode: TestData.CardDetails.cardSecurityCode)
        tapCardDetailsPayNowButton(app)
        let cancelButton = app.buttons["Cancel"]
        XCTAssert(cancelButton.waitForExistence(timeout: 10))
        app.cancelButton3DS2?.tap()
    }
    
    func testSuccessfulPreauthTransaction() {
        app.launch()
        app.cellWithIdentifier(Selectors.FeatureList.preAuthWithCard)?.tap()
        app.fillCardSheetDetails(cardNumber: TestData.CardDetails.cardNumber,
                             cardHolder: TestData.CardDetails.cardholderName,
                             expiryDate: TestData.CardDetails.cardExpiry,
                             securityCode: TestData.CardDetails.cardSecurityCode)
        tapCardDetailsPayNowButton(app)
        tapCompleteButton(app)
        assertResultObject(app, "PreAuth", "AuthCode: ", "Success")
    }
    
    func testSuccessfulCheckCardTransaction() {
        app.launch()
        app.cellWithIdentifier(Selectors.FeatureList.checkCard)?.tap()
        app.fillCardSheetDetails(cardNumber: TestData.CardDetails.cardNumber,
                             cardHolder: TestData.CardDetails.cardholderName,
                             expiryDate: TestData.CardDetails.cardExpiry,
                             securityCode: TestData.CardDetails.cardSecurityCode)
        tapCardDetailsPayNowButton(app)
        tapCompleteButton(app)
        assertResultObject(app, "CheckCard", "AuthCode: ", "Success")
    }
    
    func testSuccessfulTokenPayment() {
        app.launchArguments += ["-should_ask_for_csc", "true"]
        app.launch()
        app.cellWithIdentifier(Selectors.FeatureList.tokenPayment)?.tap()
        app.tokenizeNewCardButton?.tap()
        app.fillCardSheetDetails(cardNumber: TestData.CardDetails.cardNumber,
                             cardHolder: TestData.CardDetails.cardholderName,
                             expiryDate: TestData.CardDetails.cardExpiry,
                             securityCode: TestData.CardDetails.cardSecurityCode)
        tapCardDetailsPayNowButton(app)
        app.tokenPaymentButton?.tap()
        app.securityCodeTextField?.tapAndTypeText(TestData.CardDetails.cardSecurityCode)
        tapCardDetailsPayNowButton(app)
        tapCompleteButton(app)
        assertResultObject(app, "Payment", "AuthCode: ", "Success")
    }
    
    func testSuccessfulTokenPreauth() {
        app.launchArguments += ["-should_ask_for_csc", "true"]
        app.launch()
        app.cellWithIdentifier(Selectors.FeatureList.tokenPayment)?.tap()
        app.tokenizeNewCardButton?.tap()
        app.fillCardSheetDetails(cardNumber: TestData.CardDetails.cardNumber,
                             cardHolder: TestData.CardDetails.cardholderName,
                             expiryDate: TestData.CardDetails.cardExpiry,
                             securityCode: TestData.CardDetails.cardSecurityCode)
        tapCardDetailsPayNowButton(app)
        app.tokenPreauthButton?.tap()
        app.securityCodeTextField?.tapAndTypeText(TestData.CardDetails.cardSecurityCode)
        tapCardDetailsPayNowButton(app)
        tapCompleteButton(app)
        assertResultObject(app, "PreAuth", "AuthCode: ", "Success")
    }
    
    func testSuccessfulFrictionlessPayment() {
        app.launchArguments += ["-challenge_request_indicator", "noPreference"]
        app.launch()
        app.cellWithIdentifier(Selectors.FeatureList.payWithCard)?.tap()
        app.fillCardSheetDetails(cardNumber: TestData.CardDetails.cardNumber,
                             cardHolder: "Frictionless Successful",
                             expiryDate: TestData.CardDetails.cardExpiry,
                             securityCode: TestData.CardDetails.cardSecurityCode)
        tapCardDetailsPayNowButton(app)
        assertResultObject(app, "Payment", "AuthCode: ", "Success")
    }
    
    func testFrictionlessNoMethodPayment() {
        app.launchArguments += ["-challenge_request_indicator", "noPreference"]
        app.launch()
        app.cellWithIdentifier(Selectors.FeatureList.payWithCard)?.tap()
        app.fillCardSheetDetails(cardNumber: TestData.CardDetails.cardNumber,
                             cardHolder: "Frictionless NoMethod",
                             expiryDate: TestData.CardDetails.cardExpiry,
                             securityCode: TestData.CardDetails.cardSecurityCode)
        tapCardDetailsPayNowButton(app)
        assertResultObject(app, "Payment", "AuthCode: ", "Success")
    }
    
    func testFrictionlessAuthFailedPayment() {
        app.launchArguments += ["-challenge_request_indicator", "noPreference"]
        app.launch()
        app.cellWithIdentifier(Selectors.FeatureList.payWithCard)?.tap()
        app.fillCardSheetDetails(cardNumber: TestData.CardDetails.cardNumber,
                             cardHolder: "Frictionless AuthFailed",
                             expiryDate: TestData.CardDetails.cardExpiry,
                             securityCode: TestData.CardDetails.cardSecurityCode)
        tapCardDetailsPayNowButton(app)
    }
    
    func testSuccessfulPaymentMethodsCardPayment() {
        app.launchArguments += ["-should_ask_for_csc", "true"]
        app.launch()
        app.swipeUp()
        app.cellWithIdentifier(Selectors.FeatureList.paymentMethods)?.tap()
        app.addCard?.tap()
        app.fillCardSheetDetails(cardNumber: TestData.CardDetails.cardNumber,
                             cardHolder: TestData.CardDetails.cardholderName,
                             expiryDate: TestData.CardDetails.cardExpiry,
                             securityCode: TestData.CardDetails.cardSecurityCode)
        tapCardDetailsPayNowButton(app)
        tapPaymentMethodsPayNowButton(app)
        app.securityCodeTextField?.tapAndTypeText(TestData.CardDetails.cardSecurityCode)
        tapCardDetailsPayNowButton(app)
        tapCompleteButton(app)
        assertResultObject(app, "Payment", "AuthCode: ", "Success")
    }
    
    func testSuccessfulPreauthMethodsCardPayment() {
        app.launchArguments += ["-should_ask_for_csc", "true"]
        app.launch()
        app.swipeUp()
        app.cellWithIdentifier(Selectors.FeatureList.preAuthMethods)?.tap()
        app.addCard?.tap()
        app.fillCardSheetDetails(cardNumber: TestData.CardDetails.cardNumber,
                             cardHolder: TestData.CardDetails.cardholderName,
                             expiryDate: TestData.CardDetails.cardExpiry,
                             securityCode: TestData.CardDetails.cardSecurityCode)
        tapCardDetailsPayNowButton(app)
        tapPaymentMethodsPayNowButton(app)
        app.securityCodeTextField?.tapAndTypeText(TestData.CardDetails.cardSecurityCode)
        tapCardDetailsPayNowButton(app)
        tapCompleteButton(app)
        assertResultObject(app, "PreAuth", "AuthCode: ", "Success")
    }
    
    func testRemoveCardOnPaymentMethods() {
        app.launch()
        app.cellWithIdentifier(Selectors.FeatureList.paymentMethods)?.tap()
        app.addCard?.tap()
        app.fillCardSheetDetails(cardNumber: "4222 0000 0122 7408",
                             cardHolder: TestData.CardDetails.cardholderName,
                             expiryDate: TestData.CardDetails.cardExpiry,
                             securityCode: TestData.CardDetails.cardSecurityCode)
        tapCardDetailsPayNowButton(app)
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
        app.cellWithIdentifier(Selectors.FeatureList.payWithCard)?.tap()
        app.fillCardSheetDetails(cardNumber: TestData.CardDetails.cardNumber,
                             cardHolder: TestData.CardDetails.cardholderName,
                             expiryDate: TestData.CardDetails.cardExpiry,
                             securityCode: TestData.CardDetails.cardSecurityCode)
        XCTAssertTrue(app.cardDetailsSubmitButton!.isEnabled)
        tapCardDetailsPayNowButton(app)
        app.fillBillingInfoDetails(email: TestData.BillingInfo.validEmail,
                                   phone: TestData.BillingInfo.validMobile,
                                   addressOne: TestData.BillingInfo.validAddress,
                                   addressTwo: TestData.BillingInfo.validAddressTwo,
                                   city: TestData.BillingInfo.validCity,
                                   postCode: TestData.BillingInfo.validPostcode)
        XCTAssertTrue(app.cardDetailsSubmitButton!.isEnabled)
        tapCardDetailsPayNowButton(app)
        tapCompleteButton(app)
        assertResultObject(app, "Payment", "AuthCode: ", "Success")
        assertBillingInfo(app, TestData.BillingInfo.validCountryCode, TestData.BillingInfo.validCity, TestData.BillingInfo.validAddress, TestData.BillingInfo.validAddressTwo, TestData.BillingInfo.validPostcode)
    }
    
    func testUKPostCodeValidation() {
        app.launchArguments += ["-should_ask_for_billing_information", "true"]
        app.launch()
        app.cellWithIdentifier(Selectors.FeatureList.payWithCard)?.tap()
        app.fillCardSheetDetails(cardNumber: TestData.CardDetails.cardNumber,
                             cardHolder: TestData.CardDetails.cardholderName,
                             expiryDate: TestData.CardDetails.cardExpiry,
                             securityCode: TestData.CardDetails.cardSecurityCode)
        XCTAssertTrue(app.cardDetailsSubmitButton!.isEnabled)
        tapCardDetailsPayNowButton(app)
        app.fillBillingInfoDetails(email: TestData.BillingInfo.validEmail,
                                   phone: TestData.BillingInfo.validMobile,
                                   addressOne: TestData.BillingInfo.validAddress,
                                   addressTwo: TestData.BillingInfo.validAddressTwo,
                                   city: TestData.BillingInfo.validCity,
                                   postCode: TestData.BillingInfo.invalidPostcode)
        app.mobileField?.tap()
        XCTAssertEqual(app.fieldErrorLabel, TestData.BillingInfo.invalidPostcodeLabel)
        XCTAssertFalse(app.cardDetailsSubmitButton!.isEnabled)
    }
    
    func testUSPostCodeValidation() throws {
        guard #available(iOS 16, *) else {
            throw XCTSkip("Skipping due to picker wheel selection being buggy on lower versions of iOS")
        }
        app.launchArguments += ["-should_ask_for_billing_information", "true"]
        app.launch()
        app.cellWithIdentifier(Selectors.FeatureList.payWithCard)?.tap()
        app.fillCardSheetDetails(cardNumber: TestData.CardDetails.cardNumber,
                             cardHolder: TestData.CardDetails.cardholderName,
                             expiryDate: TestData.CardDetails.cardExpiry,
                             securityCode: TestData.CardDetails.cardSecurityCode)
        XCTAssertTrue(app.cardDetailsSubmitButton!.isEnabled)
        tapCardDetailsPayNowButton(app)
        app.countryField?.tap()
        app.pickerWheels.element(boundBy: 0).adjust(toPickerWheelValue: "United States")
        app.administrativeDivisionField?.tap()
        app.pickerWheels.element(boundBy: 0).adjust(toPickerWheelValue: "California")

        app.fillBillingInfoDetails(email: TestData.BillingInfo.validEmail,
                                   phone: TestData.BillingInfo.validMobile,
                                   addressOne: TestData.BillingInfo.validAddress,
                                   addressTwo: TestData.BillingInfo.validAddressTwo,
                                   city: TestData.BillingInfo.validCity,
                                   postCode: TestData.BillingInfo.invalidPostcode)
        app.cityField?.tap()
        XCTAssertEqual(app.fieldErrorLabel, TestData.BillingInfo.invalidPostcodeLabel)
        XCTAssertFalse(app.cardDetailsSubmitButton!.isEnabled)
    }
    
    func testCAPostCodeValidation() throws {
        guard #available(iOS 16, *) else {
            throw XCTSkip("Skipping due to picker wheel selection being buggy on lower versions of iOS")
        }
        app.launchArguments += ["-should_ask_for_billing_information", "true"]
        app.launch()
        app.cellWithIdentifier(Selectors.FeatureList.payWithCard)?.tap()
        app.fillCardSheetDetails(cardNumber: TestData.CardDetails.cardNumber,
                             cardHolder: TestData.CardDetails.cardholderName,
                             expiryDate: TestData.CardDetails.cardExpiry,
                             securityCode: TestData.CardDetails.cardSecurityCode)
        XCTAssertTrue(app.cardDetailsSubmitButton!.isEnabled)
        tapCardDetailsPayNowButton(app)
        app.countryField?.tap()
        app.pickerWheels.element(boundBy: 0).adjust(toPickerWheelValue: "Canada")
        app.administrativeDivisionField?.tap()
        app.pickerWheels.element(boundBy: 0).adjust(toPickerWheelValue: "Ontario")
        app.fillBillingInfoDetails(email: TestData.BillingInfo.validEmail,
                                   phone: TestData.BillingInfo.validMobile,
                                   addressOne: TestData.BillingInfo.validAddress,
                                   addressTwo: TestData.BillingInfo.validAddressTwo,
                                   city: TestData.BillingInfo.validCity,
                                   postCode: TestData.BillingInfo.invalidPostcode)
        app.cityField?.tap()
        XCTAssertEqual(app.fieldErrorLabel, TestData.BillingInfo.invalidPostcodeLabel)
        XCTAssertFalse(app.cardDetailsSubmitButton!.isEnabled)
    }
    
    func testBillingFieldsInputValidation() {
        app.launchArguments += ["-should_ask_for_billing_information", "true"]
        app.launch()
        app.cellWithIdentifier(Selectors.FeatureList.payWithCard)?.tap()
        app.fillCardSheetDetails(cardNumber: TestData.CardDetails.cardNumber,
                             cardHolder: TestData.CardDetails.cardholderName,
                             expiryDate: TestData.CardDetails.cardExpiry,
                             securityCode: TestData.CardDetails.cardSecurityCode)
        XCTAssertTrue(app.cardDetailsSubmitButton!.isEnabled)
        tapCardDetailsPayNowButton(app)
        
        app.emailField?.tapAndTypeText(TestData.BillingInfo.specialCharacters)
        app.addressLineOne?.tap()
        XCTAssertEqual(app.fieldErrorLabel, TestData.BillingInfo.invalidEmailLabel, "Email address input validation failed and/or error label is not displayed")
        XCTAssertFalse(app.cardDetailsSubmitButton!.isEnabled)
        app.clearTextFieldByIndex(index: 0)
        
        app.mobileField?.tapAndTypeText(TestData.BillingInfo.specialCharacters)
        app.emailField?.tap()
        XCTAssertEqual(app.fieldErrorLabel, TestData.BillingInfo.invalidPhoneLabel, "Mobile number input validation failed and/or error label is not displayed")
        XCTAssertFalse(app.cardDetailsSubmitButton!.isEnabled)
        app.clearTextFieldByIndex(index: 6)
        
        app.addressLineOne?.tapAndTypeText(TestData.BillingInfo.specialCharacters)
        app.emailField?.tap()
        XCTAssertEqual(app.fieldErrorLabel, TestData.BillingInfo.invalidAddressLabel, "Address line input validation failed and/or error label is not displayed")
        XCTAssertFalse(app.cardDetailsSubmitButton!.isEnabled)
        app.clearTextFieldByIndex(index: 2)
        
        app.cityField?.tapAndTypeText(TestData.BillingInfo.specialCharacters)
        app.mobileField?.tap()
        XCTAssertEqual(app.fieldErrorLabel, TestData.BillingInfo.invalidCityLabel, "City input validation failed and/or error label is not displayed")
        XCTAssertFalse(app.cardDetailsSubmitButton!.isEnabled)
        app.clearTextFieldByIndex(index: 3)
        
        app.postCodeField?.tapAndTypeText(TestData.BillingInfo.specialCharacters)
        app.emailField?.tap()
        XCTAssertEqual(app.fieldErrorLabel, TestData.BillingInfo.invalidPostcodeLabel, "Postcode input validation failed and/or error label is not displayed")
        XCTAssertFalse(app.cardDetailsSubmitButton!.isEnabled)
        app.clearTextFieldByIndex(index: 4)
    }
    
    func testStepUpPaymentTransaction() {
        app.launchArguments += ["-challenge_request_indicator", "noPreference", "-sca_exemption", "lowValue"]
        app.launch()
        app.cellWithIdentifier(Selectors.FeatureList.payWithCard)?.tap()
        app.fillCardSheetDetails(cardNumber: TestData.CardDetails.cardNumber,
                             cardHolder: "Frictionless Successful",
                             expiryDate: TestData.CardDetails.cardExpiry,
                             securityCode: TestData.CardDetails.wrongCV2)
        tapCardDetailsPayNowButton(app)
        tapCompleteButton(app)
        assertResultObject(app, "Payment", "Card declined: CV2 policy", "Declined")
    }
    
    func testStepUpPreauthTransaction() {
        app.launchArguments += ["-challenge_request_indicator", "noPreference", "-sca_exemption", "lowValue"]
        app.launch()
        app.cellWithIdentifier(Selectors.FeatureList.preAuthWithCard)?.tap()
        app.fillCardSheetDetails(cardNumber: TestData.CardDetails.cardNumber,
                             cardHolder: "Frictionless Successful",
                             expiryDate: TestData.CardDetails.cardExpiry,
                             securityCode: TestData.CardDetails.wrongCV2)
        tapCardDetailsPayNowButton(app)
        tapCompleteButton(app)
        assertResultObject(app, "PreAuth", "Card declined: CV2 policy", "Declined")
    }
    
    func testPrimaryAccountDetailsTransaction() {
        app.launchArguments += ["-is_primary_account_details_enabled", "true"]
        app.launch()
        app.cellWithIdentifier(Selectors.FeatureList.payWithCard)?.tap()
        app.fillCardSheetDetails(cardNumber: TestData.CardDetails.cardNumber,
                             cardHolder: TestData.CardDetails.cardholderName,
                             expiryDate: TestData.CardDetails.cardExpiry,
                             securityCode: TestData.CardDetails.cardSecurityCode)
        tapCardDetailsPayNowButton(app)
        tapCompleteButton(app)
        assertPADSent(app)
    }
    
    func testIndiaStateField() throws {
        guard #available(iOS 16, *) else {
            throw XCTSkip("Skipping due to picker wheel selection being buggy on lower versions of iOS")
        }
        app.launchArguments += ["-should_ask_for_billing_information", "true"]
        app.launch()
        app.cellWithIdentifier(Selectors.FeatureList.payWithCard)?.tap()
        app.fillCardSheetDetails(cardNumber: TestData.CardDetails.cardNumber,
                             cardHolder: TestData.CardDetails.cardholderName,
                             expiryDate: TestData.CardDetails.cardExpiry,
                             securityCode: TestData.CardDetails.cardSecurityCode)
        XCTAssertTrue(app.cardDetailsSubmitButton!.isEnabled)
        tapCardDetailsPayNowButton(app)
        app.countryField?.tap()
        app.pickerWheels.element(boundBy: 0).adjust(toPickerWheelValue: "India")
        app.administrativeDivisionField?.tap()
        app.pickerWheels.element(boundBy: 0).adjust(toPickerWheelValue: "Kerala")
        app.fillBillingInfoDetails(email: TestData.BillingInfo.validEmail,
                                   phone: TestData.BillingInfo.validMobile,
                                   addressOne: TestData.BillingInfo.validAddress,
                                   addressTwo: TestData.BillingInfo.validAddressTwo,
                                   city: TestData.BillingInfo.validCity,
                                   postCode: TestData.BillingInfo.validPostcode)
        tapCardDetailsPayNowButton(app)
        tapCompleteButton(app)
        assertResultObject(app, "Payment", "AuthCode: ", "Success")
    }
    
    func testChinaStateField() throws {
        guard #available(iOS 16, *) else {
            throw XCTSkip("Skipping due to picker wheel selection being buggy on lower versions of iOS")
        }
        app.launchArguments += ["-should_ask_for_billing_information", "true"]
        app.launch()
        app.cellWithIdentifier(Selectors.FeatureList.payWithCard)?.tap()
        app.fillCardSheetDetails(cardNumber: TestData.CardDetails.cardNumber,
                             cardHolder: TestData.CardDetails.cardholderName,
                             expiryDate: TestData.CardDetails.cardExpiry,
                             securityCode: TestData.CardDetails.cardSecurityCode)
        XCTAssertTrue(app.cardDetailsSubmitButton!.isEnabled)
        tapCardDetailsPayNowButton(app)
        app.countryField?.tap()
        app.pickerWheels.element(boundBy: 0).adjust(toPickerWheelValue: "China")
        app.administrativeDivisionField?.tap()
        app.pickerWheels.element(boundBy: 0).adjust(toPickerWheelValue: "Henan Sheng")
        app.fillBillingInfoDetails(email: TestData.BillingInfo.validEmail,
                                   phone: TestData.BillingInfo.validMobile,
                                   addressOne: TestData.BillingInfo.validAddress,
                                   addressTwo: TestData.BillingInfo.validAddressTwo,
                                   city: TestData.BillingInfo.validCity,
                                   postCode: TestData.BillingInfo.validPostcode)
        tapCardDetailsPayNowButton(app)
        tapCompleteButton(app)
        assertResultObject(app, "Payment", "AuthCode: ", "Success")
    }
    
    func testSuccessfulTokenPaymentWithDelay() {
        app.launchArguments += ["-should_ask_for_csc", "true"]
        app.launch()
        app.cellWithIdentifier(Selectors.FeatureList.tokenPayment)?.tap()
        app.tokenizeNewCardButton?.tap()
        app.fillCardSheetDetails(cardNumber: TestData.CardDetails.cardNumber,
                             cardHolder: TestData.CardDetails.cardholderName,
                             expiryDate: TestData.CardDetails.cardExpiry,
                             securityCode: TestData.CardDetails.cardSecurityCode)
        tapCardDetailsPayNowButton(app)
        tapDelayIncrementButton(app, presses: 5)
        app.tokenPaymentButton?.tap()
        waitForAndFillCSCField(app)
        tapCardDetailsPayNowButton(app)
        tapCompleteButton(app)
        assertResultObject(app, "Payment", "AuthCode: ", "Success")
    }
    
    func testSuccessfulTokenPaymentWithDelayAndAppInBackground() {
        app.launchArguments += ["-should_ask_for_csc", "true"]
        app.launch()
        app.cellWithIdentifier(Selectors.FeatureList.tokenPayment)?.tap()
        app.tokenizeNewCardButton?.tap()
        app.fillCardSheetDetails(cardNumber: TestData.CardDetails.cardNumber,
                             cardHolder: TestData.CardDetails.cardholderName,
                             expiryDate: TestData.CardDetails.cardExpiry,
                             securityCode: TestData.CardDetails.cardSecurityCode)
        tapCardDetailsPayNowButton(app)
        tapDelayIncrementButton(app, presses: 5)
        app.tokenPaymentButton?.tap()
        cycleBackgroundState(app, for: 5)
        waitForAndFillCSCField(app)
        tapCardDetailsPayNowButton(app)
        tapCompleteButton(app)
        assertResultObject(app, "Payment", "AuthCode: ", "Success")
    }
}
