//
//  JPPaymentMethodsRouterMock.swift
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

import Foundation

class JPPaymentMethodsRouterImplMock: JPPaymentMethodsRouter {
    var caledCardCustomization = false
    var dismissController = false
    var navigatedToIdealPay = false
    var navigateToTransactionModule = false
    
    func navigateToTransactionModule(with mode: JPCardDetailsMode, cardNetwork: JPCardNetworkType, andTransactionType: JPTransactionType) {
        navigateToTransactionModule = true
    }
    
    func navigateToCardCustomization(with index: UInt) {
        caledCardCustomization = true
    }
    
    func navigateToIDEALModule(with bank:JPIDEALBank, andCompletion completion: JPCompletionBlock) {
        navigatedToIdealPay = true
        let response = JPResponse()
        completion(response, nil)
    }
    
    func dismissViewController(completion: (() -> Void)? = nil) {
        completion!()
        dismissController = true
    }
}
