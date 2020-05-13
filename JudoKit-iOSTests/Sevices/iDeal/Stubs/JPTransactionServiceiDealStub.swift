//
//  JPTransactionServiceiDealStub.swift
//  JudoKit_iOSTests
//
//  Copyright (c) 2020 Alternative Payments Ltd
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

class JPTransactionServiceiDealStub: JPTransactionService {
    override init() {
        super.init(token: "TOKEN", andSecret: "SECRET")
        saveStubs()
    }
    
    
    func saveStubs() {
        let stubObjectSale = ["paymentMethod":"IDEAL",
                              "siteId": "xxx-xxx-siteId",
                              "redirectUrl": "redirectUrl",
                              "orderDetails": ["orderId": "xxx-orderid",
                                               "orderStatus": "SUCCESS",
                                               "timestamp": "2020-05-05T07:29:04.663Z",
                                               "currency": "GBP",
                                               "amount": 0.15,
                                               "refundedAmount": 0.0],
                              "merchantPaymentReference": "xxx-xxx-ref_id",
                              "merchantConsumerReference": "reference"] as [String : Any]
        
        let stubObjectStatusPending = ["paymentMethod":"IDEAL",
                                "siteId": "xxx-xxx-siteId",
                                "redirectUrl": "redirectUrl",
                                "orderDetails": ["orderId": "xxx-orderid",
                                                 "orderStatus": "PENDING",
                                                 "timestamp": "2020-05-05T07:29:04.663Z",
                                                 "currency": "GBP",
                                                 "amount": 0.15,
                                                 "refundedAmount": 0.0],
                                "merchantPaymentReference": "xxx-xxx-ref_id",
                                "merchantConsumerReference": "reference"] as [String : Any]
    
        
        let stubObjectStatusSuccess = ["paymentMethod":"IDEAL",
                                       "siteId": "xxx-xxx-siteId",
                                       "redirectUrl": "redirectUrl",
                                       "orderDetails": ["orderId": "123456",
                                                        "orderStatus": "SUCCESS",
                                                        "timestamp": "2020-05-05T07:29:04.663Z",
                                                        "currency": "GBP",
                                                        "amount": 0.15,
                                                        "refundedAmount": 0.0],
                                       "merchantPaymentReference": "xxx-xxx-ref_id",
                                       "merchantConsumerReference": "reference"] as [String : Any]
        
        stub(condition: isPath("/order/bank/sale")) { _ in
            return HTTPStubsResponse(jsonObject: stubObjectSale, statusCode: 200, headers: nil)
        }
        
        stub(condition: isPath("/order/bank/statusrequest")) { _ in
            return HTTPStubsResponse(jsonObject: stubObjectStatusPending, statusCode: 200, headers: nil)
        }
        
        stub(condition: isPath("/order/bank/statusrequest/123456")) { _ in
            return HTTPStubsResponse(jsonObject: stubObjectStatusSuccess, statusCode: 200, headers: nil)
        }
    }
    
    
}
