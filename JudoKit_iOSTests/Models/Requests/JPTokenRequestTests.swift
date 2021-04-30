//
//  JPTokenRequestTests.swift
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

class JPTokenRequestTests: XCTestCase {
    
    var configuration: JPConfiguration {
        let amount = JPAmount("1.01", currency: "EUR")
        
        let reference = JPReference(consumerReference: "consumer", paymentReference: "payment")
        reference.metaData = ["exampleKey": "exampleValue"];
        
        let configuration = JPConfiguration(judoID: "judoID", amount: amount, reference: reference)
        
        return configuration
    }
    
    var threeDSecure: JPThreeDSecureTwo {
        let bundle = Bundle(for: type(of: self))
        let path = bundle.path(forResource: "ThreeDSecureTwo", ofType: "json")!
        let data = try! Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        let jsonResult = try! JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
        let dictionary = jsonResult as? Dictionary<String, AnyObject>
        return JPThreeDSecureTwo(dictionary: dictionary)
    }
    
    /*
     * GIVEN: A [JPTokenRequest] is being initialized
     *
     *  WHEN: A valid [JPConfiguration] instance and a card token are passed as parameters
     *
     *  THEN: The properties are set with the correct values
     */
    func test_onInitialization_SetValidProperties() {
        let tokenRequest = JPTokenRequest(configuration: configuration, andCardToken: "token")
        
        XCTAssertEqual(tokenRequest.judoId, "judoID")
        
        XCTAssertEqual(tokenRequest.amount, "1.01")
        XCTAssertEqual(tokenRequest.currency, configuration.amount.currency)
        
        XCTAssertEqual(tokenRequest.yourConsumerReference, configuration.reference.consumerReference)
        XCTAssertEqual(tokenRequest.yourPaymentReference, configuration.reference.paymentReference)
        XCTAssertEqual(tokenRequest.yourPaymentMetaData, configuration.reference.metaData)
        
        XCTAssertEqual(tokenRequest.cardToken, "token")
    }
    
    /*
     * GIVEN: A [JPTokenRequest] is being initialized
     *
     *  WHEN: A valid [JPThreeDSecureTwo] instance and a card token are passed as parameters
     *
     *  THEN: The properties are set with the correct values
     */
    func test_onInitialization_SetValid_ThreeDSecure() {
        let tokenRequest = JPTokenRequest(configuration: configuration,
                                          andCardToken: "token",
                                          threeDSecure: threeDSecure)
        
        XCTAssertEqual(tokenRequest.threeDSecure?.challengeRequestIndicator, threeDSecure.challengeRequestIndicator)
        XCTAssertEqual(tokenRequest.threeDSecure?.scaExemption, threeDSecure.scaExemption)
        XCTAssertEqual(tokenRequest.threeDSecure?.authenticationSource, threeDSecure.authenticationSource)
    }
}
