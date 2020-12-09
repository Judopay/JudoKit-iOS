//
//  FeatureRepository.swift
//  SwiftExampleApp
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

import Foundation

class FeatureRepository {
    
    let features = [
        FeatureViewModel(type: .payment,
                         title: "Pay with card",
                         subtitle: "by entering card details"),
        
        FeatureViewModel(type: .preAuth,
                         title: "PreAuth with card",
                         subtitle: "by entering card details"),
        
        FeatureViewModel(type: .registerCard,
                         title: "Register card",
                         subtitle: "to be stored for future transactions"),
        
        FeatureViewModel(type: .checkCard,
                         title: "Check card",
                         subtitle: "to validate card"),
        
        FeatureViewModel(type: .saveCard,
                         title: "Save card",
                         subtitle: "to be stored for future transactions"),
        
        FeatureViewModel(type: .applePay,
                         title: "Apple Pay payment",
                         subtitle: "with a wallet card"),
        
        FeatureViewModel(type: .applePreAuth,
                         title: "Apple Pay preAuth",
                         subtitle: "with a wallet card"),
        
        FeatureViewModel(type: .paymentMethods,
                         title: "Payment methods",
                         subtitle: "with default payment methods"),
        
        FeatureViewModel(type: .preAuthMethods,
                         title: "PreAuth methods",
                         subtitle: "with default pre-auth methods"),
        
        FeatureViewModel(type: .serverToServer,
                         title: "Server-to-Server payment methods",
                         subtitle: "with default server-to-server payment methods"),
        
        FeatureViewModel(type: .payByBank,
                         title: "Pay By Bank App",
                         subtitle: "by using your existing Bank app"),
        
        FeatureViewModel(type: .tokenPayments,
                         title: "Token payments",
                         subtitle: "by using your stored card token"),
        
        FeatureViewModel(type: .transactionDetails,
                         title: "Get transaction details",
                         subtitle: "by using your receipt ID"),
    ]
    
}
