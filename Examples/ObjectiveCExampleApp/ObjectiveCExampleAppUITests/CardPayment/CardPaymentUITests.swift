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
        app.fillCardSheetDetails(cardNumber: TestData.CardDetails.CARD_NUMBER,
                             cardHolder: TestData.CardDetails.CARDHOLDER_NAME,
                             expiryDate: TestData.CardDetails.CARD_EXPIRY,
                             securityCode: TestData.CardDetails.CARD_SECURITY_CODE)
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
        app.fillCardSheetDetails(cardNumber: TestData.CardDetails.CARD_NUMBER,
                             cardHolder: TestData.CardDetails.CARDHOLDER_NAME,
                             expiryDate: TestData.CardDetails.CARD_EXPIRY,
                             securityCode: TestData.CardDetails.CARD_SECURITY_CODE)
        tapPayNowButton(app)
        tapCompleteButton(app)
        assertResultObject(app, "Payment", "AuthCode: ", "Success")
    }
    
    func testDeclinedTransaction() {
        app.launch()
        app.cellWithIdentifier(Selectors.FeatureList.payWithCard)?.tap()
        app.fillCardSheetDetails(cardNumber: TestData.CardDetails.CARD_NUMBER,
                             cardHolder: TestData.CardDetails.CARDHOLDER_NAME,
                             expiryDate: TestData.CardDetails.CARD_EXPIRY,
                             securityCode: "123")
        tapPayNowButton(app)
        tapCompleteButton(app)
        assertResultObject(app, "Payment", "Card declined: Additional customer authentication required", "Declined")
    }

    func testFailedTransaction() {
        app.launch()
        app.cellWithIdentifier(Selectors.FeatureList.payWithCard)?.tap()
        app.fillCardSheetDetails(cardNumber: "4111 1111 1111 1111",
                             cardHolder: TestData.CardDetails.CARDHOLDER_NAME,
                             expiryDate: TestData.CardDetails.CARD_EXPIRY,
                             securityCode: "123")
        tapPayNowButton(app)
        tapCompleteButton(app)
        assertResultObject(app, "Payment", "The gateway reported an error", "Error")
    }
    
    func testCancel3DS2ChallengeScreenErrorPopupShouldBeDisplayed() {
        app.launch()
        app.cellWithIdentifier(Selectors.FeatureList.payWithCard)?.tap()
        app.fillCardSheetDetails(cardNumber: TestData.CardDetails.CARD_NUMBER,
                             cardHolder: TestData.CardDetails.CARDHOLDER_NAME,
                             expiryDate: TestData.CardDetails.CARD_EXPIRY,
                             securityCode: TestData.CardDetails.CARD_SECURITY_CODE)
        tapPayNowButton(app)
        let cancelButton = app.buttons["Cancel"]
        XCTAssert(cancelButton.waitForExistence(timeout: 10))
        app.cancelButton3DS2?.tap()
    }
    
    func testSuccessfulPreauthTransaction() {
        app.launch()
        app.cellWithIdentifier(Selectors.FeatureList.preAuthWithCard)?.tap()
        app.fillCardSheetDetails(cardNumber: TestData.CardDetails.CARD_NUMBER,
                             cardHolder: TestData.CardDetails.CARDHOLDER_NAME,
                             expiryDate: TestData.CardDetails.CARD_EXPIRY,
                             securityCode: TestData.CardDetails.CARD_SECURITY_CODE)
        tapPayNowButton(app)
        tapCompleteButton(app)
        assertResultObject(app, "PreAuth", "AuthCode: ", "Success")
    }
    
    func testSuccessfulCheckCardTransaction() {
        app.launch()
        app.cellWithIdentifier(Selectors.FeatureList.checkCard)?.tap()
        app.fillCardSheetDetails(cardNumber: TestData.CardDetails.CARD_NUMBER,
                             cardHolder: TestData.CardDetails.CARDHOLDER_NAME,
                             expiryDate: TestData.CardDetails.CARD_EXPIRY,
                             securityCode: TestData.CardDetails.CARD_SECURITY_CODE)
        tapPayNowButton(app)
        tapCompleteButton(app)
        assertResultObject(app, "CheckCard", "AuthCode: ", "Success")
    }
    
    func testSuccessfulTokenPayment() {
        app.launchArguments += ["-should_ask_for_csc", "true"]
        app.launch()
        app.cellWithIdentifier(Selectors.FeatureList.tokenPayment)?.tap()
        app.tokenizeNewCardButton?.tap()
        app.fillCardSheetDetails(cardNumber: TestData.CardDetails.CARD_NUMBER,
                             cardHolder: TestData.CardDetails.CARDHOLDER_NAME,
                             expiryDate: TestData.CardDetails.CARD_EXPIRY,
                             securityCode: TestData.CardDetails.CARD_SECURITY_CODE)
        tapPayNowButton(app)
        app.tokenPaymentButton?.tap()
        app.securityCodeTextField?.tapAndTypeText(TestData.CardDetails.CARD_SECURITY_CODE)
        tapPayNowButton(app)
        tapCompleteButton(app)
        assertResultObject(app, "Payment", "AuthCode: ", "Success")
    }
    
    func testSuccessfulTokenPreauth() {
        app.launchArguments += ["-should_ask_for_csc", "true"]
        app.launch()
        app.cellWithIdentifier(Selectors.FeatureList.tokenPayment)?.tap()
        app.tokenizeNewCardButton?.tap()
        app.fillCardSheetDetails(cardNumber: TestData.CardDetails.CARD_NUMBER,
                             cardHolder: TestData.CardDetails.CARDHOLDER_NAME,
                             expiryDate: TestData.CardDetails.CARD_EXPIRY,
                             securityCode: TestData.CardDetails.CARD_SECURITY_CODE)
        tapPayNowButton(app)
        app.tokenPreauthButton?.tap()
        app.securityCodeTextField?.tapAndTypeText(TestData.CardDetails.CARD_SECURITY_CODE)
        tapPayNowButton(app)
        tapCompleteButton(app)
        assertResultObject(app, "PreAuth", "AuthCode: ", "Success")
    }
    
    func testSuccessfulFrictionlessPayment() {
        app.launchArguments += ["-challenge_request_indicator", "noPreference"]
        app.launch()
        app.cellWithIdentifier(Selectors.FeatureList.payWithCard)?.tap()
        app.fillCardSheetDetails(cardNumber: TestData.CardDetails.CARD_NUMBER,
                             cardHolder: "Frictionless Successful",
                             expiryDate: TestData.CardDetails.CARD_EXPIRY,
                             securityCode: TestData.CardDetails.CARD_SECURITY_CODE)
        tapPayNowButton(app)
        assertResultObject(app, "Payment", "AuthCode: ", "Success")
    }
    
    func testFrictionlessNoMethodPayment() {
        app.launchArguments += ["-challenge_request_indicator", "noPreference"]
        app.launch()
        app.cellWithIdentifier(Selectors.FeatureList.payWithCard)?.tap()
        app.fillCardSheetDetails(cardNumber: TestData.CardDetails.CARD_NUMBER,
                             cardHolder: "Frictionless NoMethod",
                             expiryDate: TestData.CardDetails.CARD_EXPIRY,
                             securityCode: TestData.CardDetails.CARD_SECURITY_CODE)
        tapPayNowButton(app)
        assertResultObject(app, "Payment", "AuthCode: ", "Success")
    }
    
    func testFrictionlessAuthFailedPayment() {
        app.launchArguments += ["-challenge_request_indicator", "noPreference"]
        app.launch()
        app.cellWithIdentifier(Selectors.FeatureList.payWithCard)?.tap()
        app.fillCardSheetDetails(cardNumber: TestData.CardDetails.CARD_NUMBER,
                             cardHolder: "Frictionless AuthFailed",
                             expiryDate: TestData.CardDetails.CARD_EXPIRY,
                             securityCode: TestData.CardDetails.CARD_SECURITY_CODE)
        tapPayNowButton(app)
    }
    
    func testSuccessfulPaymentMethodsCardPayment() {
        app.launchArguments += ["-should_ask_for_csc", "true"]
        app.launch()
        app.swipeUp()
        app.cellWithIdentifier(Selectors.FeatureList.paymentMethods)?.tap()
        app.addCard?.tap()
        app.fillCardSheetDetails(cardNumber: TestData.CardDetails.CARD_NUMBER,
                             cardHolder: TestData.CardDetails.CARDHOLDER_NAME,
                             expiryDate: TestData.CardDetails.CARD_EXPIRY,
                             securityCode: TestData.CardDetails.CARD_SECURITY_CODE)
        tapPayNowButton(app)
        app.payNowButton?.tap()
        app.payNowButton?.tap()
        app.securityCodeTextField?.tapAndTypeText(TestData.CardDetails.CARD_SECURITY_CODE)
        tapPayNowButton(app)
        tapCompleteButton(app)
        assertResultObject(app, "Payment", "AuthCode: ", "Success")
    }
    
    func testSuccessfulPreauthMethodsCardPayment() {
        app.launchArguments += ["-should_ask_for_csc", "true"]
        app.launch()
        app.swipeUp()
        app.cellWithIdentifier(Selectors.FeatureList.preAuthMethods)?.tap()
        app.addCard?.tap()
        app.fillCardSheetDetails(cardNumber: TestData.CardDetails.CARD_NUMBER,
                             cardHolder: TestData.CardDetails.CARDHOLDER_NAME,
                             expiryDate: TestData.CardDetails.CARD_EXPIRY,
                             securityCode: TestData.CardDetails.CARD_SECURITY_CODE)
        tapPayNowButton(app)
        app.payNowButton?.tap()
        app.payNowButton?.tap()
        app.securityCodeTextField?.tapAndTypeText(TestData.CardDetails.CARD_SECURITY_CODE)
        tapPayNowButton(app)
        tapCompleteButton(app)
        assertResultObject(app, "PreAuth", "AuthCode: ", "Success")
    }
    
    func testRemoveCardOnPaymentMethods() {
        app.launch()
        app.cellWithIdentifier(Selectors.FeatureList.paymentMethods)?.tap()
        app.addCard?.tap()
        app.fillCardSheetDetails(cardNumber: "4222 0000 0122 7408",
                             cardHolder: TestData.CardDetails.CARDHOLDER_NAME,
                             expiryDate: TestData.CardDetails.CARD_EXPIRY,
                             securityCode: TestData.CardDetails.CARD_SECURITY_CODE)
        tapPayNowButton(app)
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
        app.fillCardSheetDetails(cardNumber: TestData.CardDetails.CARD_NUMBER,
                             cardHolder: TestData.CardDetails.CARDHOLDER_NAME,
                             expiryDate: TestData.CardDetails.CARD_EXPIRY,
                             securityCode: TestData.CardDetails.CARD_SECURITY_CODE)
        XCTAssertTrue(app.cardDetailsSubmitButton!.isEnabled)
        tapPayNowButton(app)
        app.fillBillingInfoDetails(email: TestData.BillingInfo.VALID_EMAIL,
                                   phone: TestData.BillingInfo.VALID_MOBILE,
                                   addressOne: TestData.BillingInfo.VALID_ADDRESS,
                                   addressTwo: TestData.BillingInfo.VALID_ADDRESS_TWO,
                                   city: TestData.BillingInfo.VALID_CITY,
                                   postCode: TestData.BillingInfo.VALID_POSTCODE)
        XCTAssertTrue(app.cardDetailsSubmitButton!.isEnabled)
        tapPayNowButton(app)
        tapCompleteButton(app)
        assertResultObject(app, "Payment", "AuthCode: ", "Success")
        assertBillingInfo(app, TestData.BillingInfo.VALID_COUNTRY_CODE, TestData.BillingInfo.VALID_CITY, TestData.BillingInfo.VALID_ADDRESS, TestData.BillingInfo.VALID_ADDRESS_TWO, TestData.BillingInfo.VALID_POSTCODE)
    }
    
    func testUKPostCodeValidation() {
        app.launchArguments += ["-should_ask_for_billing_information", "true"]
        app.launch()
        app.cellWithIdentifier(Selectors.FeatureList.payWithCard)?.tap()
        app.fillCardSheetDetails(cardNumber: TestData.CardDetails.CARD_NUMBER,
                             cardHolder: TestData.CardDetails.CARDHOLDER_NAME,
                             expiryDate: TestData.CardDetails.CARD_EXPIRY,
                             securityCode: TestData.CardDetails.CARD_SECURITY_CODE)
        XCTAssertTrue(app.cardDetailsSubmitButton!.isEnabled)
        tapPayNowButton(app)
        app.fillBillingInfoDetails(email: TestData.BillingInfo.VALID_EMAIL,
                                   phone: TestData.BillingInfo.VALID_MOBILE,
                                   addressOne: TestData.BillingInfo.VALID_ADDRESS,
                                   addressTwo: TestData.BillingInfo.VALID_ADDRESS_TWO,
                                   city: TestData.BillingInfo.VALID_CITY,
                                   postCode: TestData.BillingInfo.INVALID_POSTCODE)
        app.mobileField?.tap()
        XCTAssertEqual(app.fieldErrorLabel, TestData.BillingInfo.INVALID_POSTCODE_LABEL)
        XCTAssertFalse(app.cardDetailsSubmitButton!.isEnabled)
    }
    
    func testUSPostCodeValidation() throws {
        guard #available(iOS 16, *) else {
            throw XCTSkip("Skipping due to picker wheel selection being buggy on lower versions of iOS")
        }
        app.launchArguments += ["-should_ask_for_billing_information", "true"]
        app.launch()
        app.cellWithIdentifier(Selectors.FeatureList.payWithCard)?.tap()
        app.fillCardSheetDetails(cardNumber: TestData.CardDetails.CARD_NUMBER,
                             cardHolder: TestData.CardDetails.CARDHOLDER_NAME,
                             expiryDate: TestData.CardDetails.CARD_EXPIRY,
                             securityCode: TestData.CardDetails.CARD_SECURITY_CODE)
        XCTAssertTrue(app.cardDetailsSubmitButton!.isEnabled)
        tapPayNowButton(app)
        app.countryField?.tap()
        app.pickerWheels.element(boundBy: 0).adjust(toPickerWheelValue: "United States")
        app.administrativeDivisionField?.tap()
        app.pickerWheels.element(boundBy: 0).adjust(toPickerWheelValue: "California")

        app.fillBillingInfoDetails(email: TestData.BillingInfo.VALID_EMAIL,
                                   phone: TestData.BillingInfo.VALID_MOBILE,
                                   addressOne: TestData.BillingInfo.VALID_ADDRESS,
                                   addressTwo: TestData.BillingInfo.VALID_ADDRESS_TWO,
                                   city: TestData.BillingInfo.VALID_CITY,
                                   postCode: TestData.BillingInfo.INVALID_POSTCODE)
        app.cityField?.tap()
        XCTAssertEqual(app.fieldErrorLabel, TestData.BillingInfo.INVALID_ZIPCODE_LABEL)
        XCTAssertFalse(app.cardDetailsSubmitButton!.isEnabled)
    }
    
    func testCAPostCodeValidation() throws {
        guard #available(iOS 16, *) else {
            throw XCTSkip("Skipping due to picker wheel selection being buggy on lower versions of iOS")
        }
        app.launchArguments += ["-should_ask_for_billing_information", "true"]
        app.launch()
        app.cellWithIdentifier(Selectors.FeatureList.payWithCard)?.tap()
        app.fillCardSheetDetails(cardNumber: TestData.CardDetails.CARD_NUMBER,
                             cardHolder: TestData.CardDetails.CARDHOLDER_NAME,
                             expiryDate: TestData.CardDetails.CARD_EXPIRY,
                             securityCode: TestData.CardDetails.CARD_SECURITY_CODE)
        XCTAssertTrue(app.cardDetailsSubmitButton!.isEnabled)
        tapPayNowButton(app)
        app.countryField?.tap()
        app.pickerWheels.element(boundBy: 0).adjust(toPickerWheelValue: "Canada")
        app.administrativeDivisionField?.tap()
        app.pickerWheels.element(boundBy: 0).adjust(toPickerWheelValue: "Ontario")
        app.fillBillingInfoDetails(email: TestData.BillingInfo.VALID_EMAIL,
                                   phone: TestData.BillingInfo.VALID_MOBILE,
                                   addressOne: TestData.BillingInfo.VALID_ADDRESS,
                                   addressTwo: TestData.BillingInfo.VALID_ADDRESS_TWO,
                                   city: TestData.BillingInfo.VALID_CITY,
                                   postCode: TestData.BillingInfo.INVALID_POSTCODE)
        app.cityField?.tap()
        XCTAssertEqual(app.fieldErrorLabel, TestData.BillingInfo.INVALID_POSTCODE_LABEL)
        XCTAssertFalse(app.cardDetailsSubmitButton!.isEnabled)
    }
    
    func testBillingFieldsInputValidation() {
        app.launchArguments += ["-should_ask_for_billing_information", "true"]
        app.launch()
        app.cellWithIdentifier(Selectors.FeatureList.payWithCard)?.tap()
        app.fillCardSheetDetails(cardNumber: TestData.CardDetails.CARD_NUMBER,
                             cardHolder: TestData.CardDetails.CARDHOLDER_NAME,
                             expiryDate: TestData.CardDetails.CARD_EXPIRY,
                             securityCode: TestData.CardDetails.CARD_SECURITY_CODE)
        XCTAssertTrue(app.cardDetailsSubmitButton!.isEnabled)
        tapPayNowButton(app)
        
        app.emailField?.tapAndTypeText(TestData.BillingInfo.SPECIAL_CHARACTERS)
        app.addressLineOne?.tap()
        XCTAssertEqual(app.fieldErrorLabel, TestData.BillingInfo.INVALID_EMAIL_LABEL, "Email address input validation failed and/or error label is not displayed")
        XCTAssertFalse(app.cardDetailsSubmitButton!.isEnabled)
        app.clearTextFieldByIndex(index: 0)
        
        app.mobileField?.tapAndTypeText(TestData.BillingInfo.SPECIAL_CHARACTERS)
        app.emailField?.tap()
        XCTAssertEqual(app.fieldErrorLabel, TestData.BillingInfo.INVALID_PHONE_LABEL, "Mobile number input validation failed and/or error label is not displayed")
        XCTAssertFalse(app.cardDetailsSubmitButton!.isEnabled)
        app.clearTextFieldByIndex(index: 6)
        
        app.addressLineOne?.tapAndTypeText(TestData.BillingInfo.SPECIAL_CHARACTERS)
        app.emailField?.tap()
        XCTAssertEqual(app.fieldErrorLabel, TestData.BillingInfo.INVALID_ADDRESS_LABEL, "Address line input validation failed and/or error label is not displayed")
        XCTAssertFalse(app.cardDetailsSubmitButton!.isEnabled)
        app.clearTextFieldByIndex(index: 2)
        
        app.cityField?.tapAndTypeText(TestData.BillingInfo.SPECIAL_CHARACTERS)
        app.mobileField?.tap()
        XCTAssertEqual(app.fieldErrorLabel, TestData.BillingInfo.INVALID_CITY_LABEL, "City input validation failed and/or error label is not displayed")
        XCTAssertFalse(app.cardDetailsSubmitButton!.isEnabled)
        app.clearTextFieldByIndex(index: 3)
        
        app.postCodeField?.tapAndTypeText(TestData.BillingInfo.SPECIAL_CHARACTERS)
        app.emailField?.tap()
        XCTAssertEqual(app.fieldErrorLabel, TestData.BillingInfo.INVALID_POSTCODE_LABEL, "Postcode input validation failed and/or error label is not displayed")
        XCTAssertFalse(app.cardDetailsSubmitButton!.isEnabled)
        app.clearTextFieldByIndex(index: 4)
    }
    
    func testStepUpPaymentTransaction() {
        app.launchArguments += ["-challenge_request_indicator", "noPreference", "-sca_exemption", "lowValue"]
        app.launch()
        app.cellWithIdentifier(Selectors.FeatureList.payWithCard)?.tap()
        app.fillCardSheetDetails(cardNumber: TestData.CardDetails.CARD_NUMBER,
                             cardHolder: "Frictionless Successful",
                             expiryDate: TestData.CardDetails.CARD_EXPIRY,
                             securityCode: TestData.CardDetails.WRONG_CV2)
        tapPayNowButton(app)
        tapCompleteButton(app)
        assertResultObject(app, "Payment", "Card declined: CV2 policy", "Declined")
    }
    
    func testStepUpPreauthTransaction() {
        app.launchArguments += ["-challenge_request_indicator", "noPreference", "-sca_exemption", "lowValue"]
        app.launch()
        app.cellWithIdentifier(Selectors.FeatureList.preAuthWithCard)?.tap()
        app.fillCardSheetDetails(cardNumber: TestData.CardDetails.CARD_NUMBER,
                             cardHolder: "Frictionless Successful",
                             expiryDate: TestData.CardDetails.CARD_EXPIRY,
                             securityCode: TestData.CardDetails.WRONG_CV2)
        tapPayNowButton(app)
        tapCompleteButton(app)
        assertResultObject(app, "PreAuth", "Card declined: CV2 policy", "Declined")
    }
    
    func testPrimaryAccountDetailsTransaction() {
        app.launchArguments += ["-is_primary_account_details_enabled", "true"]
        app.launch()
        app.cellWithIdentifier(Selectors.FeatureList.payWithCard)?.tap()
        app.fillCardSheetDetails(cardNumber: TestData.CardDetails.CARD_NUMBER,
                             cardHolder: TestData.CardDetails.CARDHOLDER_NAME,
                             expiryDate: TestData.CardDetails.CARD_EXPIRY,
                             securityCode: TestData.CardDetails.CARD_SECURITY_CODE)
        tapPayNowButton(app)
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
        app.fillCardSheetDetails(cardNumber: TestData.CardDetails.CARD_NUMBER,
                             cardHolder: TestData.CardDetails.CARDHOLDER_NAME,
                             expiryDate: TestData.CardDetails.CARD_EXPIRY,
                             securityCode: TestData.CardDetails.CARD_SECURITY_CODE)
        XCTAssertTrue(app.cardDetailsSubmitButton!.isEnabled)
        tapPayNowButton(app)
        app.countryField?.tap()
        app.pickerWheels.element(boundBy: 0).adjust(toPickerWheelValue: "India")
        app.administrativeDivisionField?.tap()
        app.pickerWheels.element(boundBy: 0).adjust(toPickerWheelValue: "Kerala")
        app.fillBillingInfoDetails(email: TestData.BillingInfo.VALID_EMAIL,
                                   phone: TestData.BillingInfo.VALID_MOBILE,
                                   addressOne: TestData.BillingInfo.VALID_ADDRESS,
                                   addressTwo: TestData.BillingInfo.VALID_ADDRESS_TWO,
                                   city: TestData.BillingInfo.VALID_CITY,
                                   postCode: TestData.BillingInfo.VALID_POSTCODE)
        tapPayNowButton(app)
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
        app.fillCardSheetDetails(cardNumber: TestData.CardDetails.CARD_NUMBER,
                             cardHolder: TestData.CardDetails.CARDHOLDER_NAME,
                             expiryDate: TestData.CardDetails.CARD_EXPIRY,
                             securityCode: TestData.CardDetails.CARD_SECURITY_CODE)
        XCTAssertTrue(app.cardDetailsSubmitButton!.isEnabled)
        tapPayNowButton(app)
        app.countryField?.tap()
        app.pickerWheels.element(boundBy: 0).adjust(toPickerWheelValue: "China")
        app.administrativeDivisionField?.tap()
        app.pickerWheels.element(boundBy: 0).adjust(toPickerWheelValue: "Henan Sheng")
        app.fillBillingInfoDetails(email: TestData.BillingInfo.VALID_EMAIL,
                                   phone: TestData.BillingInfo.VALID_MOBILE,
                                   addressOne: TestData.BillingInfo.VALID_ADDRESS,
                                   addressTwo: TestData.BillingInfo.VALID_ADDRESS_TWO,
                                   city: TestData.BillingInfo.VALID_CITY,
                                   postCode: TestData.BillingInfo.VALID_POSTCODE)
        tapPayNowButton(app)
        tapCompleteButton(app)
        assertResultObject(app, "Payment", "AuthCode: ", "Success")
    }
}
