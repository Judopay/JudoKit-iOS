//
//  JPError+Additions.h
//  JudoKit_iOS
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

#import "JPCardNetworkType.h"
#import "JPError.h"
#import <Foundation/Foundation.h>

@class JPTransactionData, JPCardNetwork, JPResponse;

extern NSString *_Nonnull const JudoErrorDomain;

typedef NS_ENUM(NSUInteger, JudoError) {
    JudoErrorGeneral_Error = 0,
    JudoErrorRequestFailed,
    JudoErrorJSONSerializationFailed,
    JudoErrorTokenMissing,
    JudoError3DSRequest,
    JudoErrorUnderlyingError,
    JudoErrorTransactionDeclined,
    JudoErrorFailed3DSRequest,
    JudoErrorInputMismatchError,
    JudoErrorUserDidCancel,
    JudoErrorParameterError,
    JudoErrorResponseParseError,
    JudoErrorInvalidCardNumberError,
    JudoErrorUnsupportedCardNetwork,
};

@interface JPError (Additions)

/**
 * In JPSession:
 *   - Called if the request URL could not be generated
 *   - Called if the request responded with error or no data
 */
+ (nonnull JPError *)judoRequestFailedError;

/**
 * In JPSession:
 *   - Called if the response data could not be deserialized into JSON
 */
+ (nonnull JPError *)judoJSONSerializationFailedWithError:(nullable NSError *)error;

/**
 * In JPTransactionPresenter:
 *   - Called if no card token was returned from a Save Card transaction
 */
+ (nonnull JPError *)judoTokenMissingError;

/**
 * In JPIDEALViewController:
 *   - Called if the user cancelled during the IDEAL bank flow
 *
 * In JP3DSViewController:
 *   - Called if the user tapped on the Cancel button on the 3DS modal controller
 *
 * In JPTransactionPresenter:
 *   - Called if the user tapped on the Cancel button in the Judo transaction UI
 *
 * In JPTransactionInteractor:
 *   - There's a condition that checks if the error is `judoUserDidCancelError`.
 *    If yes, returns the stored transaction errors back to the merchant.
 *
 * In JPPaymentMethodsInteractor:
 *   - There's a condition that checks if the error is `judoUserDidCancelError`.
 *    If yes, returns the stored transaction errors back to the merchant.
 *
 * In JPPaymentMethodsPresenter:
 *   - Called if the user tapped on the Back button in the Judo Wallet
 */
+ (nonnull JPError *)judoUserDidCancelError;

/**
 * In JPApiService:
 *   - Called if the HTTP request method is not GET, POST or PUT
 */
+ (nonnull JPError *)judoParameterError;

/**
 * In JPSession:
 *   - Called if during the request the Reachability service returns false
 */
+ (nonnull JPError *)judoInternetConnectionError;

/**
 * In JPPBBAService:
 *   - Called if the PBBA response does not contain an orderId or the redirect URL
 *   - Called if the PBBA response does not contain a secureToken and pbbaBrn
 *
 * In JPIDEALService:
 *   - Called if the IDEAL request does not return an orderId or the redirect URL
 */
+ (nonnull JPError *)judoResponseParseError;

/**
 * In JPIDEALViewController:
 *   - Called if the IDEAL redirect URL does not contain a checksum parameter
 */
+ (nonnull JPError *)judoMissingChecksumError;

/**
 * In JPPBBAService:
 *   - Called if the PBBA flow exceeds the maximum time limit
 *
 * In JPIDEALService:
 *   - Called if the iDEAL flow exceeds the maximum time limit
 *
 * In JPIDEALViewController:
 *   - Referenced when displaying the timeout status view during polling
 */
+ (nonnull JPError *)judoRequestTimeoutError;

/**
 * In JPCardValidatorService:
 *   - Called if the card number is not valid once all digits have been entered
 */
+ (nonnull JPError *)judoInvalidCardNumberError;

/**
 * In JPCardValidatorService:
 *   - Called if the card number is not part of the allowed card types
 */
+ (nonnull JPError *)judoUnsupportedCardNetwork:(JPCardNetworkType)network;

/**
 * In JPSession:
 *   - Called if the transaction result is neither success nor declined
 */
+ (nonnull JPError *)judoErrorFromResponse:(nonnull JPResponse *)data;

/**
 * In JPSession:
 *   - Called if the transaction response contains the 'code' property
 */
+ (nonnull JPError *)judoErrorFromDictionary:(nonnull NSDictionary *)dict;

/**
 * In JPSession:
 *   - Called if the transaction response contains 'acsUrl' and `paReq`
 */
+ (nonnull JPError *)judo3DSRequestWithPayload:(nonnull NSDictionary *)payload;

/**
 * In JPPaymentMethodsBuilder:
 *   - Called if iDEAL is the only payment method and currency is not EUR
 */
+ (nonnull JPError *)judoInvalidIDEALCurrencyError;

/**
 * In JPPaymentMethodsBuilder:
 *   - Called if PBBA is the only payment method and currency is not GBP
 */
+ (nonnull JPError *)judoInvalidPBBACurrency;

/**
 * In JPPaymentMethodsBuilder:
 *   - Called if PBBA is the only payment method and 'deeplinkScheme' is missing
 */
+ (nonnull JPError *)judoPBBAURLSchemeMissing;

/**
 * In JPPaymentMethodsBuilder:
 *   - Called if ApplePay is the only payment method but is not supported
 */
+ (nonnull JPError *)judoApplePayNotSupportedError;

/**
 * In JPSession:
 *   - Called if the transaction result returns the 'Declined' status
 */
+ (nonnull JPError *)judoErrorCardDeclined;

@end
