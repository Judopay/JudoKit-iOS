//
//  JPContactInformationTest.swift
//  JudoKit-iOSTests
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

class JPContactInformationTest: XCTestCase {
    
    /*
     * GIVEN: Creating JPContactInformation
     *
     * WHEN: fields are passed in designated init
     *
     * THEN: should create correct fields in JPContactInformation object
     */
    func test_InitWithDictionary_WhenInitWithPersonalDataPostalAddress_ShouldPopulateFields() {
        var personalData = PersonNameComponents()
        personalData.namePrefix = "namePrefix"
        personalData.nameSuffix = "nameSuffix"
        personalData.familyName = "familyName"
        personalData.givenName = "givenName"
        
        let postalAdress = JPPostalAddress(steet: "street",
                                           city: "city",
                                           state: "state",
                                           postalCode: "postalcode",
                                           country: "country",
                                           isoCode: "isoCode",
                                           subAdministrativeArea: "subAdministrativeArea",
                                           sublocality: "sublocality")
        
        let cardDetails = JPContactInformation(emailAddress: "email@gmail.com",
                                               name: personalData,
                                               phoneNumber: "9999999",
                                               postalAddress: postalAdress)
        
        XCTAssertEqual(cardDetails.emailAddress, "email@gmail.com")
        XCTAssertEqual(cardDetails.toString(), "Email: email@gmail.com\nName: namePrefix givenName familyName nameSuffix\nPhone: 9999999\nPostal Address: street city country state postalcode \n")
        XCTAssertEqual(cardDetails.name, personalData)
        XCTAssertEqual(cardDetails.phoneNumber, "9999999")
        XCTAssertEqual(cardDetails.postalAddress, postalAdress)
    }
}

