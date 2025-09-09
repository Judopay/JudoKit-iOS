//
//  JudoKitTest.swift
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

class JudoKitTest: XCTestCase {
    var judoKit: JudoKit! = JudoKit(authorization: JPBasicAuthorization(token: "token", andSecret: "secret"))!
    let configuration = JPConfiguration(judoID: "123456789",
                                        amount: JPAmount("0.01", currency: "EUR"),
                                        reference: JPReference(consumerReference: "consumerReference"))
    
    let items = [JPPaymentSummaryItem(label: "item 1", amount: 0.01),
                 JPPaymentSummaryItem(label: "item 2", amount: 0.02),
                 JPPaymentSummaryItem(label: "Judo Pay", amount: 0.03)]
    
    var jsonResult: [String: Any]!
    
    override func setUp() {
        super.setUp()
        HTTPStubs.setEnabled(true)
        configuration.applePayConfiguration = JPApplePayConfiguration(merchantId: "1234", currency: "USD", countryCode: "DE", paymentSummaryItems: items)
        
        let path = Bundle(for: type(of: self)).path(forResource: "TransactionData", ofType: "json")!
        let data = try! Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        jsonResult = try! JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as! [String: Any]
    }
    
    override func tearDown() {
        HTTPStubs.removeAllStubs()
        super.tearDown()
    }
    
    /*
     * GIVEN: Creating JudoKit object
     *
     * WHEN: setup sandbox env
     *
     * THEN: should update sandbox parameter in JudoKit object
     */
    func test_isSandboxed_WhenSetUpSandBox_ShouldSaveInJudoObject() {
        XCTAssertFalse(judoKit.isSandboxed)
        judoKit.isSandboxed = true
        XCTAssertTrue(judoKit.isSandboxed)
    }
    
    /*
     * GIVEN: Invoke Apple Pay With Mode
     *
     * WHEN: No applePayConfiguration is present in the JPConfiguration object
     *
     * THEN: should not pass validation and throw error
     */
    func test_InvokeApplePayWithMode_WhenCurrencyIsEUR_ShouldNotPassValidation() {
        judoKit.invokeApplePay(with: .payment, configuration: configuration) { (res, error) in
            XCTAssertEqual(error?.localizedDescription ?? "", "Apple Configuration is empty")
        }
    }
    
    /*
     * GIVEN: Invoke Transaction With Mode
     *
     * WHEN: JudoId is not valid
     *
     * THEN: should not pass validation and throw error
     */
    func test_InvokeTransactionWithType_WhenJudoIdIsInvalid_ShouldNotValidate() {
        let configuration = JPConfiguration(judoID: "123",
                                            amount: JPAmount("0.01", currency: "EUR"),
                                            reference: JPReference.init(consumerReference: "consumerReference"))
        judoKit.invokeTransaction(with: .payment, configuration: configuration) { (res, error) in
            XCTAssertEqual(error?.localizedDescription ?? "", "The Judo ID entered is invalid.")
        }
    }
    
    /*
     * GIVEN: Invoke Transaction With Mode
     *
     * WHEN: reference is not valid
     *
     * THEN: should not pass validation and throw error
     */
    func test_InvokeTransactionWithType_WhenRefernceBig_ShouldNotValidate() {
        configuration.reference = JPReference(consumerReference: "1234567890123456789012345678901234567890123456789012345678901")
        judoKit.invokeTransaction(with: .payment, configuration: configuration) { (res, error) in
            XCTAssertEqual(error?.localizedDescription ?? "", "The consumer reference entered is invalid.")
        }
    }
    
    /*
     * GIVEN: Invoke Transaction With Mode
     *
     * WHEN: amount is not a number
     *
     * THEN: should not pass validation and throw error
     */
    func test_InvokeTransactionWithType_WhenAmountNotNumber_ShouldNotValidate() {
        configuration.amount = JPAmount("aaa", currency: "USD")
        judoKit.invokeTransaction(with: .payment, configuration: configuration) { (res, error) in
            XCTAssertEqual(error?.localizedDescription ?? "", "The amount specified should be a positive number.")
        }
    }
    
    /*
     * GIVEN: Invoke apple pay With Mode
     *
     * WHEN: country Code is not supported
     *
     * THEN: should not pass validation and throw error
     */
    func test_InvokeApplePayWithMode_WhenCountryError_ShouldNotPassValidation() {
        configuration.applePayConfiguration?.countryCode = "MD"
        judoKit.invokeApplePay(with: .payment, configuration: configuration) { (res, error) in
            XCTAssertEqual(error?.localizedDescription ?? "", "Country Code is invalid")
        }
    }
    
    /*
     * GIVEN: Invoke apple pay With Mode
     *
     * WHEN: merchantId is empty
     *
     * THEN: should not pass validation and throw error
     */
    func test_InvokeApplePayWithMode_WhenMerchant_ShouldNotPassValidation() {
        configuration.applePayConfiguration?.merchantId = ""
        judoKit.invokeApplePay(with: .payment, configuration: configuration) { (res, error) in
            XCTAssertEqual(error?.localizedDescription ?? "", "The Apple Pay merchant ID cannot be null or empty.")
        }
    }
    
    /*
     * GIVEN: Invoke apple pay With Mode
     *
     * WHEN: currency is empty
     *
     * THEN: should not pass validation and throw error
     */
    func test_InvokeApplePayWithMode_WhenCurrenctEmpty_ShouldNotPassValidation() {
        configuration.applePayConfiguration?.currency = ""
        judoKit.invokeApplePay(with: .payment, configuration: configuration) { (res, error) in
            XCTAssertEqual(error?.localizedDescription ?? "", "Currency cannot be null or empty.")
        }
    }
    
    /*
     * GIVEN: Invoke apple pay With Mode
     *
     * WHEN: currency is Unsupported
     *
     * THEN: should not pass validation and throw error
     */
    func test_InvokeApplePayWithMode_WhenCurrenctNotValid_ShouldNotPassValidation() {
        configuration.applePayConfiguration?.currency = "MDL"
        judoKit.invokeApplePay(with: .payment, configuration: configuration) { (res, error) in
            XCTAssertEqual(error?.localizedDescription ?? "", "The specified currency code is not supported.")
        }
    }
    
    /*
     * GIVEN: Invoke apple pay With Mode
     *
     * WHEN: empty Payment items
     *
     * THEN: should not pass validation and throw error
     */
    func test_InvokeApplePayWithMode_WhenNoItems_ShouldNotPassValidation() {
        configuration.applePayConfiguration?.paymentSummaryItems = [JPPaymentSummaryItem()]
        judoKit.invokeApplePay(with: .payment, configuration: configuration) { (res, error) in
            XCTAssertEqual(error?.localizedDescription ?? "", "Payment items couldn't be empty")
        }
    }
    
    /*
     * GIVEN: Invoke fetch transaction with receipt Id
     *
     * WHEN: receipt Id is valid string
     *
     * THEN: should return transaction details
     */
    func test_FetchTransaction_WhenReceiptIdValid_ShouldReturnTransactionDetails() {
        stub(condition: isPath("/transactions/receiptId")) { _ in
            return HTTPStubsResponse(fileAtPath: OHPathForFile("TransactionData.json", type(of: self))!, statusCode: 200, headers: nil)
        }
        let expectation = self.expectation(description: "await transaction response")

        judoKit.fetchTransaction(withReceiptId: "receiptId", completion:{ (res, error) in
            XCTAssertNotNil(res)
            expectation.fulfill()
        })
        waitForExpectations(timeout: 3, handler: nil)
    }
    
    /*
     * GIVEN: Invoke fetch transaction with receipt Id
     *
     * WHEN: transaction is declined
     *
     * THEN: should return response with Declined result
     */
    func test_FetchTransaction_WhenTransactionDeclined_ShouldReturnRightError() {
        jsonResult["result"] = "Declined"
        stub(condition: isPath("/transactions/receiptId")) { _ in
            let theJSONData = try! JSONSerialization.data(
                withJSONObject: self.jsonResult! ,
                options: JSONSerialization.WritingOptions(rawValue: 0))
            return HTTPStubsResponse(data: theJSONData, statusCode: 200, headers: nil)
        }
        
        let expectation = self.expectation(description: "await declined transaction response")
        
        judoKit.fetchTransaction(withReceiptId: "receiptId", completion:{ (res, error) in
            XCTAssertNotNil(res)
            XCTAssertEqual(res?.result, JPTransactionResult.declined)
            XCTAssertNil(error)
            expectation.fulfill()
        })
        waitForExpectations(timeout: 3, handler: nil)
    }
    
    /*
     * GIVEN: Invoke fetch transaction with receipt Id
     *
     * WHEN: transaction type is PreAuth
     *
     * THEN: should return result type of: PreAuth
     */
    func test_FetchTransaction_WhenTransactionPreAuth_ShouldReturnRightTransactionType() {
        jsonResult["type"] = "PreAuth"
        stub(condition: isPath("/transactions/receiptId")) { _ in
            let theJSONData = try! JSONSerialization.data(
                withJSONObject: self.jsonResult! ,
                options: JSONSerialization.WritingOptions(rawValue: 0))
            return HTTPStubsResponse(data: theJSONData, statusCode: 200, headers: nil)
        }
        
        let expectation = self.expectation(description: "await preauth transaction response")
        
        judoKit.fetchTransaction(withReceiptId: "receiptId", completion:{ (res, error) in
            XCTAssertEqual(res?.type, .preAuth)
            expectation.fulfill()
        })
        waitForExpectations(timeout: 3, handler: nil)
    }
    
    /*
     * GIVEN: Invoke fetch transaction with receipt Id
     *
     * WHEN: transaction type is save card
     *
     * THEN: should return result type of: saveCard
     */
    func test_FetchTransaction_WhenTransactionSave_ShouldReturnRightTransactionType() {
        jsonResult["type"] = "Save"
        stub(condition: isPath("/transactions/receiptId")) { _ in
            let theJSONData = try! JSONSerialization.data(
                withJSONObject: self.jsonResult! ,
                options: JSONSerialization.WritingOptions(rawValue: 0))
            return HTTPStubsResponse(data: theJSONData, statusCode: 200, headers: nil)
        }
        
        let expectation = self.expectation(description: "await save transaction response")
        
        judoKit.fetchTransaction(withReceiptId: "receiptId", completion:{ (res, error) in
            XCTAssertEqual(res?.type, .saveCard)
            expectation.fulfill()
        })
        waitForExpectations(timeout: 3, handler: nil)
    }
    
    /*
     * GIVEN: Invoke fetch transaction with receipt Id
     *
     * WHEN: transaction type is check card
     *
     * THEN: should return result type of: checkCard
     */
    func test_FetchTransaction_WhenTransactionCheckCard_ShouldReturnRightTransactionType() {
        jsonResult["type"] = "CheckCard"
        stub(condition: isPath("/transactions/receiptId")) { _ in
            let theJSONData = try! JSONSerialization.data(
                withJSONObject: self.jsonResult! ,
                options: JSONSerialization.WritingOptions(rawValue: 0))
            return HTTPStubsResponse(data: theJSONData, statusCode: 200, headers: nil)
        }
        
        let expectation = self.expectation(description: "await check card transaction response")
        
        judoKit.fetchTransaction(withReceiptId: "receiptId", completion:{ (res, error) in
            XCTAssertEqual(res?.type, .checkCard)
            expectation.fulfill()
        })
        waitForExpectations(timeout: 3, handler: nil)
    }
    
}
