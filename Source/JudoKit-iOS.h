//
//  JudoKit-iOS.h
//  JudoKit-iOS
//
//  Copyright (c) 2016 Alternative Payments Ltd
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

#import <UIKit/UIKit.h>

//! Project version number for JudoKit.
FOUNDATION_EXPORT double JudoKitVersionNumber;

//! Project version string for JudoKit.
FOUNDATION_EXPORT const unsigned char JudoKitVersionString[];

#import <JudoKit/JP3DSService.h>
#import <JudoKit/JP3DSViewController.h>
#import <JudoKit/JPAddress.h>
#import <JudoKit/JPAmount.h>
#import <JudoKit/JPApplePayConfiguration.h>
#import <JudoKit/JPApplePayService.h>
#import <JudoKit/JPBillingCountry.h>
#import <JudoKit/JPBrowser.h>
#import <JudoKit/JPCard.h>
#import <JudoKit/JPCardDetails.h>
#import <JudoKit/JPCardNetwork.h>
#import <JudoKit/JPCardStorage.h>
#import <JudoKit/JPClientDetails.h>
#import <JudoKit/JPConstants.h>
#import <JudoKit/JPConsumer.h>
#import <JudoKit/JPConsumerDevice.h>
#import <JudoKit/JPContactInformation.h>
#import <JudoKit/JPCountry.h>
#import <JudoKit/JPEnhancedPaymentDetail.h>
#import <JudoKit/JPError+Additions.h>
#import <JudoKit/JPIDEALBank.h>
#import <JudoKit/JPIDEALService.h>
#import <JudoKit/JPOrderDetails.h>
#import <JudoKit/JPPagination.h>
#import <JudoKit/JPPaymentMethods.h>
#import <JudoKit/JPPaymentToken.h>
#import <JudoKit/JPPrimaryAccountDetails.h>
#import <JudoKit/JPReachability.h>
#import <JudoKit/JPReceipt.h>
#import <JudoKit/JPReference.h>
#import <JudoKit/JPResponse.h>
#import <JudoKit/JPSDKInfo.h>
#import <JudoKit/JPSession.h>
#import <JudoKit/JPStoredCardDetails.h>
#import <JudoKit/JPTheme.h>
#import <JudoKit/JPThreeDSecure.h>
#import <JudoKit/JPTransaction.h>
#import <JudoKit/JPTransactionData.h>
#import <JudoKit/JPTransactionEnricher.h>
#import <JudoKit/JPTransactionService.h>
#import <JudoKit/JPVCOResult.h>
#import <JudoKit/JPValidationResult.h>
#import <JudoKit/JudoKit.h>
#import <JudoKit/JPConfiguration.h>
#import <JudoKit/JPPaymentMethod.h>
#import <JudoKit/JPPostalAddress.h>
#import <JudoKit/JPThemable.h>
#import <JudoKit/JPUIConfiguration.h>
#import <JudoKit/JPPaymentMethodType.h>
#import <JudoKit/Typedefs.h>
