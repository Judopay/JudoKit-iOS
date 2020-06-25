//
//  JPTransactionTest.swift
//  JudoKit_iOSTests
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import XCTest
@testable import JudoKit_iOS

class JPTransactionTest: XCTestCase {
    let amount = JPAmount(amount: "989", currency: "USD")
    let paymentTransactionSUT = JPTransaction(type: .payment)
    
    /*
     * GIVEN: Creating JPTransaction with Designated Init
     *
     * WHEN: insert receiptId and amount
     *
     * THEN: should create correct parameters fields
     */
    func test_InitWithType_WhenSetupAmountAndEReciep_ShouldPopulateParameters() {
        let transactionSUT = JPTransaction(type: .payment, receiptId: "recieptId", amount: amount)
        XCTAssertEqual(transactionSUT.amount?.amount, "989")
        XCTAssertEqual(transactionSUT.amount?.currency, "USD")
    }
    
    /*
     * GIVEN: Creating JPTransaction with class Init
     *
     * WHEN: insert receiptId and amount
     *
     * THEN: should create correct parameters fields
     */
    func test_TransactionWithType_WhenSetupAmountAndEReciep_ShouldPopulateParameters() {
        let transactionSUT = JPTransaction.init(type: .payment, receiptId: "recieptId", amount: amount)
        XCTAssertEqual(transactionSUT.amount?.amount, "989")
        XCTAssertEqual(transactionSUT.amount?.currency, "USD")
    }
    
    /*
     * GIVEN: Creating card and insert in JPTransaction object
     *
     * WHEN: card fields are valid
     *
     * THEN: should create correct properties from card fields
     */
    func test_SetCard_WhenCardPropertiesExist_ShouldPopulateParameters() {
        let transactionSUT = JPTransaction(type: .payment)
        let card = JPCard(cardNumber: "cardNumber", cardholderName: "cardholderName", expiryDate: "expiryDate", secureCode: "secureCode")
        transactionSUT.card = card
        
        XCTAssertEqual(transactionSUT.card?.cardNumber, "cardNumber")
        XCTAssertEqual(transactionSUT.card?.cardholderName, "cardholderName")
        XCTAssertEqual(transactionSUT.card?.expiryDate, "expiryDate")
        XCTAssertEqual(transactionSUT.card?.secureCode, "secureCode")
        XCTAssertEqual(transactionSUT.card?.startDate, nil)
        XCTAssertEqual(transactionSUT.card?.issueNumber, nil)
        XCTAssertEqual(transactionSUT.card?.cardAddress?.countryCode, JPAddress().countryCode)
    }
    
    /*
     * GIVEN: asking for parameters from transaction
     *
     * WHEN: paramenters are nil
     *
     * THEN: should return empty dictionary
     */
    func test_GetParameters_WhenInitWithType_ShouldReturnEmptyParameters() {
        XCTAssertEqual(paymentTransactionSUT.getParameters().count, 0)
    }
    
    /*
     * GIVEN: injecting card token in payment
     *
     * WHEN: CardToken is a string
     *
     * THEN: should return right CardToken
     */
    func test_CardToken_WhenInjectingToken_ShouldAddToParams() {
        paymentTransactionSUT.cardToken = "cardToken"
        XCTAssertEqual(paymentTransactionSUT.getParameters()["cardToken"] as! String, "cardToken")
    }
    
    /*
     * GIVEN: injecting SecurityCode in payment
     *
     * WHEN: SecurityCode is a string
     *
     * THEN: should return right SecurityCode
     */
    func test_SecurityCode_WhenInjectingToken_ShouldAddToParams() {
        paymentTransactionSUT.securityCode = "code"
        XCTAssertEqual(paymentTransactionSUT.getParameters()["cv2"] as! String, "code")
    }
    
    /*
     * GIVEN: injecting JPPrimaryAccountDetails in payment
     *
     * WHEN: JPPrimaryAccountDetails is a object from dictionary
     *
     * THEN: should return right JPPrimaryAccountDetails
     */
    func tets_PrimaryAccountDetails_WhenInjectAccountDetails_ShouldAddToParams() {
        let dic = ["name":"name",
                   "accountNumber":"accountNumber",
                   "dateOfBirth":"dateOfBirth",
                   "postCode":"postCode"]
        let accountDetails = JPPrimaryAccountDetails(from: dic)
        paymentTransactionSUT.primaryAccountDetails = accountDetails
        XCTAssertEqual(paymentTransactionSUT.getParameters()["name"] as! String, "name")
        XCTAssertEqual(paymentTransactionSUT.getParameters()["accountNumber"] as! String, "accountNumber")
        XCTAssertEqual(paymentTransactionSUT.getParameters()["dateOfBirth"] as! String, "dateOfBirth")
        XCTAssertEqual(paymentTransactionSUT.getParameters()["postCode"] as! String, "postCode")
        
        XCTAssertEqual(paymentTransactionSUT.primaryAccountDetails?.accountNumber, "accountNumber")
        XCTAssertEqual(paymentTransactionSUT.primaryAccountDetails?.dateOfBirth, "dateOfBirth")
        XCTAssertEqual(paymentTransactionSUT.primaryAccountDetails?.postCode, "postCode")
        XCTAssertEqual(paymentTransactionSUT.primaryAccountDetails?.name, "name")
    }
    
    /*
     * GIVEN: injecting JPPaymentToken in payment
     *
     * WHEN: JPPaymentToken is a object
     *
     * THEN: should return right JPPaymentToken
     */
    func test_PaymentToken_WhenInjectPaymentToken_ShouldAddToParams() {
        let paymentToken = JPPaymentToken(consumerToken: "consumer", cardToken: "card")
        paymentToken.secureCode = "code"
        paymentTransactionSUT.paymentToken = paymentToken
        XCTAssertEqual(paymentTransactionSUT.getParameters()["consumerToken"] as! String, "consumer")
        XCTAssertEqual(paymentTransactionSUT.getParameters()["cardToken"] as! String, "card")
        XCTAssertEqual(paymentTransactionSUT.getParameters()["cv2"] as! String, "code")
        
        XCTAssertEqual(paymentTransactionSUT.paymentToken?.consumerToken, "consumer")
        XCTAssertEqual(paymentTransactionSUT.paymentToken?.cardToken, "card")
        XCTAssertEqual(paymentTransactionSUT.paymentToken?.secureCode, "code")
    }
    
    /*
     * GIVEN: injecting mobileNumber in payment
     *
     * WHEN: mobileNumber is a String
     *
     * THEN: should return right mobileNumber
     */
    func test_MobileNumber_WhenInjectMobileNumber_ShouldAddToParams() {
        paymentTransactionSUT.mobileNumber = "12345"
        XCTAssertEqual(paymentTransactionSUT.getParameters()["mobileNumber"] as! String, "12345")
        XCTAssertEqual(paymentTransactionSUT.mobileNumber, "12345")
    }
    
    /*
     * GIVEN: injecting emailAddress in payment
     *
     * WHEN: emailAddress is a String
     *
     * THEN: should return right emailAddress
     */
    func test_EmailAddress_WhenInjectEmailAddress_ShouldAddToParams() {
        paymentTransactionSUT.emailAddress = "email@email.com"
        XCTAssertEqual(paymentTransactionSUT.getParameters()["emailAddress"] as! String, "email@email.com")
        XCTAssertEqual(paymentTransactionSUT.emailAddress, "email@email.com")
    }
    
    /*
     * GIVEN: injecting deviceSignal in payment
     *
     * WHEN: emailAddress is a dictionary
     *
     * THEN: should return right deviceSignal
     */
    func test_DeviceSignal_WhenInjectDeviceSignal_ShouldAddToParams() {
        paymentTransactionSUT.deviceSignal = ["device":"signal"]
        XCTAssertEqual((paymentTransactionSUT.getParameters()["clientDetails"] as! Dictionary)["device"], "signal")
        XCTAssertEqual(paymentTransactionSUT.deviceSignal!["device"] as! String, "signal")
    }
    
    /*
     * GIVEN: injecting siteId in payment
     *
     * WHEN: siteId is a string
     *
     * THEN: should return right siteId
     */
    func test_SiteId_WhenInjectSiteId_ShouldAddToParams() {
        paymentTransactionSUT.siteId = "siteId"
        XCTAssertEqual(paymentTransactionSUT.getParameters()["siteId"] as! String, "siteId")
        XCTAssertEqual(paymentTransactionSUT.siteId, "siteId")
    }
    
    /*
     * GIVEN: injecting judoId in payment
     *
     * WHEN: judoId is a string
     *
     * THEN: should return right judoId
     */
    func test_JudoId_WhenInjectJudoId_ShouldAddToParams() {
        paymentTransactionSUT.judoId = "judoId"
        XCTAssertEqual(paymentTransactionSUT.getParameters()["judoId"] as! String, "judoId")
        XCTAssertEqual(paymentTransactionSUT.judoId, "judoId")
    }
    
    /*
     * GIVEN: not injecting amount
     *
     * WHEN: amount is a nil
     *
     * THEN: should return nil amount
     */
    func test_Amount_WhenAmmountIsNil_ShouldReturnNil() {
        XCTAssertNil(paymentTransactionSUT.amount)
    }
    
    /*
     * GIVEN: not injecting reference
     *
     * WHEN: reference is a nil
     *
     * THEN: should return nil reference
     */
    func test_Reference_WhenReferencetIsNil_ShouldReturnNil() {
        XCTAssertNil(paymentTransactionSUT.reference)
    }
    
    /*
     * GIVEN: not injecting card
     *
     * WHEN: card is a nil
     *
     * THEN: should return nil card
     */
    func test_Card_WhenCardIsNil_ShouldReturnNil() {
        XCTAssertNil(paymentTransactionSUT.card)
    }
    
    /*
     * GIVEN: not injecting primaryAccountDetails
     *
     * WHEN: primaryAccountDetails is nil
     *
     * THEN: should return nil for primaryAccountDetails
     */
    func test_PrimaryAccountDetails_WhenPrimaryAccountDetailsIsNil_ShouldReturnNil() {
        XCTAssertNil(paymentTransactionSUT.primaryAccountDetails)
    }
    
    /*
     * GIVEN: not injecting paymentToken
     *
     * WHEN: paymentToken is nil
     *
     * THEN: should return nil
     */
    func test_PaymentToken_WhenPaymentTokenIsNil_ShouldReturnNil() {
        XCTAssertNil(paymentTransactionSUT.paymentToken)
    }
    
    /*
     * GIVEN: Creating JPTransaction with payment type
     *
     * WHEN: insert receiptId and amount
     *
     * THEN: should create correct params
     */
    func test_TransactionPathPayment_WhenSetupAmountAndEReciep_ShouldPopulateParameters() {
        let transactionSUT = JPTransaction(type: .payment, receiptId: "recieptId", amount: amount)
        XCTAssertEqual(transactionSUT.getParameters()["amount"] as! String, "989")
    }
    
    /*
     * GIVEN: Creating JPTransaction with preauth type
     *
     * WHEN: insert receiptId and amount
     *
     * THEN: should create correct params
     */
    func test_TransactionPathPreAuth_WhenSetupAmountAndEReciep_ShouldPopulateParameters() {
        let transactionSUT = JPTransaction(type: .preAuth, receiptId: "recieptId", amount: amount)
        XCTAssertEqual(transactionSUT.getParameters()["amount"] as! String, "989")
    }
    
    /*
     * GIVEN: Creating JPTransaction with refund type
     *
     * WHEN: insert receiptId and amount
     *
     * THEN: should create correct params
     */
    func test_TransactionPathRefund_WhenSetupAmountAndEReciep_ShouldPopulateParameters() {
        let transactionSUT = JPTransaction(type: .refund, receiptId: "recieptId", amount: amount)
        XCTAssertEqual(transactionSUT.getParameters()["amount"] as! String, "989")
    }
    
    /*
     * GIVEN: Creating JPTransaction with registerCard type
     *
     * WHEN: insert receiptId and amount
     *
     * THEN: should create correct params
     */
    func test_TransactionPathRegisterCard_WhenSetupAmountAndEReciep_ShouldPopulateParameters() {
        let transactionSUT = JPTransaction(type: .registerCard, receiptId: "recieptId", amount: amount)
        XCTAssertEqual(transactionSUT.getParameters()["amount"] as! String, "989")
    }
    
    /*
     * GIVEN: Creating JPTransaction with checkCard type
     *
     * WHEN: insert receiptId and amount
     *
     * THEN: should create correct params
     */
    func test_TransactionPathCheckCard_WhenSetupAmountAndEReciep_ShouldPopulateParameters() {
        let transactionSUT = JPTransaction(type: .checkCard, receiptId: "recieptId", amount: amount)
        XCTAssertEqual(transactionSUT.getParameters()["amount"] as! String, "989")
    }
    
    /*
     * GIVEN: Creating JPTransaction with saveCard type
     *
     * WHEN: insert receiptId and amount
     *
     * THEN: should create correct params
     */
    func test_TransactionPathSaveCard_WhenSetupAmountAndEReciep_ShouldPopulateParameters() {
        let transactionSUT = JPTransaction(type: .saveCard, receiptId: "recieptId", amount: amount)
        XCTAssertEqual(transactionSUT.getParameters()["amount"] as! String, "989")
    }
}
