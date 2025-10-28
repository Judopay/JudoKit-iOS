//
//  JudoKit_iOS.h
//  JudoKit_iOS
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

#import "JPAddress.h"
#import "JPAdministrativeDivision.h"
#import "JPAmount.h"
#import "JPApplePayConfiguration.h"
#import "JPBillingCountry.h"
#import "JPBrowser.h"
#import "JPCard.h"
#import "JPCardDetails.h"
#import "JPCardExpirationStatus.h"
#import "JPCardNetwork.h"
#import "JPCardPattern.h"
#import "JPCardStorage.h"
#import "JPClientDetails.h"
#import "JPConfiguration.h"
#import "JPConstants.h"
#import "JPConsumer.h"
#import "JPConsumerDevice.h"
#import "JPContactInformation.h"
#import "JPCountry.h"
#import "JPEnhancedPaymentDetail.h"
#import "JPError+Additions.h"
#import "JPError.h"
#import "JPNetworkTimeout.h"
#import "JPNetworkTokenisationDetails.h"
#import "JPPaymentMethod.h"
#import "JPPaymentMethodType.h"
#import "JPPaymentMethods.h"
#import "JPPostalAddress.h"
#import "JPPrimaryAccountDetails.h"
#import "JPReachability.h"
#import "JPRecurringPaymentRequest.h"
#import "JPRecurringPaymentSummaryItem.h"
#import "JPReference.h"
#import "JPRequestEnricher.h"
#import "JPResponse.h"
#import "JPSDKInfo.h"
#import "JPSection.h"
#import "JPSession.h"
#import "JPStoredCardDetails.h"
#import "JPSubProductInfo.h"
#import "JPThemable.h"
#import "JPTheme.h"
#import "JPThreeDSecure.h"
#import "JPUIConfiguration.h"
#import "JPValidationResult.h"
#import "JPVirtualPan.h"
#import "JudoKit.h"
#import "Typedefs.h"

#import "JPApiService.h"
#import "JPApplePayRequest.h"
#import "JPApplePayWrappers.h"
#import "JPComplete3DS2Request.h"
#import "JPPaymentRequest.h"
#import "JPPreAuthApplePayRequest.h"
#import "JPPreAuthRequest.h"
#import "JPRequest.h"

#import "JP3DSecureAuthenticationResult.h"
#import "JPCheckCardRequest.h"
#import "JPPreAuthTokenRequest.h"
#import "JPRequest.h"
#import "JPSaveCardRequest.h"
#import "JPTokenRequest.h"

#import "JPAuthorization.h"
#import "JPBasicAuthorization.h"
#import "JPLoadingButton.h"
#import "JPSessionAuthorization.h"
#import "UIColor+Additions.h"
#import "UIFont+Additions.h"

#import "JP3DSConfiguration.h"
#import "JPCardTransactionDetails.h"
#import "JPCardTransactionService.h"

#import "JPRecommendationConfiguration.h"

#import "NSBundle+Additions.h"
#import "NSNumber+Additions.h"
#import "NSString+Additions.h"

//! Project version number for JudoKit_iOS.
FOUNDATION_EXPORT double JudoKit_iOSVersionNumber;

//! Project version string for JudoKit_iOS.
FOUNDATION_EXPORT const unsigned char JudoKit_iOSVersionString[];
