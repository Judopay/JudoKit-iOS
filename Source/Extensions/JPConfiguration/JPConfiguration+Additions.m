//
//  JPConfiguration+Additions.m
//  JudoKit_iOS
//
//  Copyright (c) 2023 Alternative Payments Ltd
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

#import "JPConfiguration+Additions.h"
#import "JPUIConfiguration.h"

@implementation JPConfiguration (Additions)

- (JPPresentationMode)presentationModeForCardPayments {

    if (self.uiConfiguration.shouldAskForBillingInformation) {
        return JPPresentationModeCardAndBillingInfo;
    }

    // AVS is only shown in case billing info screen is not presented
    if (self.uiConfiguration.isAVSEnabled) {
        return JPPresentationModeCardInfoAndAVS;
    }

    return JPPresentationModeCardInfo;
}

- (JPPresentationMode)presentationModeForTokenPayments {
    return [self presentationModeForTokenPaymentsForPaymentMethods:NO];
}

- (JPPresentationMode)presentationModeForTokenPaymentsForPaymentMethods:(BOOL)forPaymentMethods {
    BOOL isBillingInfoOn = self.uiConfiguration.shouldAskForBillingInformation;
    BOOL shouldAskForCSC = self.uiConfiguration.shouldAskForCSC;

    if (shouldAskForCSC && self.uiConfiguration.shouldAskForCardholderName) {
        return isBillingInfoOn ? JPPresentationModeSecurityCodeAndCardholderNameAndBillingInfo : JPPresentationModeSecurityCodeAndCardholderName;
    }

    if (shouldAskForCSC) {
        return isBillingInfoOn ? JPPresentationModeSecurityCodeAndBillingInfo : JPPresentationModeSecurityCode;
    }

    if (self.uiConfiguration.shouldAskForCardholderName) {
        return isBillingInfoOn ? JPPresentationModeCardholderNameAndBillingInfo : JPPresentationModeCardholderName;
    }

    return isBillingInfoOn ? JPPresentationModeBillingInfo : JPPresentationModeNone;
}

@end
