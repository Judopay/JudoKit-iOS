//
//  BillingInfoUITests.swift
//  SwiftExampleAppUITests
//
//  Created by Eugene Zhernakov on 05/03/2025.
//  Copyright © 2025 Judopay. All rights reserved.
//

import XCTest

final class BillingInfoUITests: XCTestCase {
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
        assertBillingInfo(app, Constants.BillingInfo.validCity,
                               Constants.BillingInfo.validAddress,
                               Constants.BillingInfo.validAddressTwo,
                               Constants.BillingInfo.validPostcode)
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
        app.administrativeDivisionField?.tap()
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
        app.administrativeDivisionField?.tap()
        app.pickerWheels.element(boundBy: 0).adjust(toPickerWheelValue: "Ontario")
        app.fillBillingInfoDetails(email: Constants.BillingInfo.validEmail,
                                   phone: Constants.BillingInfo.validMobile,
                                   addressOne: Constants.BillingInfo.validAddress,
                                   addressTwo: Constants.BillingInfo.validAddressTwo,
                                   city: Constants.BillingInfo.validCity,
                                   postCode: Constants.BillingInfo.invalidPostcode)
        app.cityField?.tap()
        sleep(1)
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

    func testIndiaStateField() throws {
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
        app.pickerWheels.element(boundBy: 0).adjust(toPickerWheelValue: "India")
        app.administrativeDivisionField?.tap()
        app.pickerWheels.element(boundBy: 0).adjust(toPickerWheelValue: "Kerala")
        app.fillBillingInfoDetails(email: Constants.BillingInfo.validEmail,
                                   phone: Constants.BillingInfo.validMobile,
                                   addressOne: Constants.BillingInfo.validAddress,
                                   addressTwo: Constants.BillingInfo.validAddressTwo,
                                   city: Constants.BillingInfo.validCity,
                                   postCode: Constants.BillingInfo.validPostcode)
        app.cardDetailsSubmitButton?.tap()
        tapCompleteButton(app)
        assertResultObject(app, "Payment", "AuthCode: ", "Success")
    }

    func testChinaStateField() throws {
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
        app.pickerWheels.element(boundBy: 0).adjust(toPickerWheelValue: "China")
        app.administrativeDivisionField?.tap()
        app.pickerWheels.element(boundBy: 0).adjust(toPickerWheelValue: "Henan Sheng")
        app.fillBillingInfoDetails(email: Constants.BillingInfo.validEmail,
                                   phone: Constants.BillingInfo.validMobile,
                                   addressOne: Constants.BillingInfo.validAddress,
                                   addressTwo: Constants.BillingInfo.validAddressTwo,
                                   city: Constants.BillingInfo.validCity,
                                   postCode: Constants.BillingInfo.validPostcode)
        app.cardDetailsSubmitButton?.tap()
        tapCompleteButton(app)
        assertResultObject(app, "Payment", "AuthCode: ", "Success")
    }
}
