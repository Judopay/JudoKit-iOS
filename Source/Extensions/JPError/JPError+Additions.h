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

@class JPTransactionData, JPCardNetwork, JPResponse, JP3DSProtocolErrorEvent, JP3DSRuntimeErrorEvent;

extern NSString *_Nonnull const JudoErrorDomain;

typedef NS_ENUM(NSUInteger, JudoError) {
    JudoParameterError,
    JudoRequestError,
    Judo3DSRequestError,
    JudoUserDidCancelError,
    JudoErrorThreeDSTwo
};

@interface JPError (Additions)

+ (nonnull JPError *)invalidTokenPaymentTransactionType;

/**
 * The transaction response returned without any data or there was an error while forming the request.
 */
+ (nonnull JPError *)requestFailedError;

/**
 * The response data could not be serialized into a JSON.
 */
+ (nonnull JPError *)JSONSerializationFailedWithError:(nullable NSError *)error;

/**
 * The user closed the transaction flow without completing the transaction.
 */
+ (nonnull JPError *)userDidCancelError;

/**
 * The request could not be sent due to no internet connection.
 */
+ (nonnull JPError *)internetConnectionError;

/**
 * The response did not contain some of the required parameters needed to complete the transaction.
 */
+ (nonnull JPError *)responseParseError;

/**
 * The request failed to complete in the allocated time frame.
 */
+ (nonnull JPError *)requestTimeoutError;

/**
 * The number entered is not a valid card number or is not supported by the SDK.
 */
+ (nonnull JPError *)invalidCardNumberError;

/**
 * The number entered belongs to a card network that is not allowed by the merchant.
 */
+ (nonnull JPError *)unsupportedCardNetwork:(JPCardNetworkType)network;

/**
 * The transaction required a 3D Secure authentication.
 */
+ (nonnull JPError *)threeDSRequestWithPayload:(nonnull NSDictionary *)payload;

/**
 * Invalid currency passed to iDEAL transaction configuration.
 */
+ (nonnull JPError *)invalidIDEALCurrencyError;

/**
 * An Apple Pay transaction was attempted on a device that either does not support, or does not have Apple Pay set up.
 */
+ (nonnull JPError *)applePayNotSupportedError;

/**
 * Some server errors come back as responses. This method maps them to our custom Judo Error object.
 */
+ (nonnull JPError *)errorFromDictionary:(nonnull NSDictionary *)dictionary;

/**
 * The Payment Items array of the Apple Pay configuration is either empty or missing.
 */
+ (nonnull JPError *)applePayMissingPaymentItemsError;

/**
 * Shipping methods must be set if the required shipping contact fields are specified.
 */
+ (nonnull JPError *)applePayMissingShippingMethodsError;

/**
 * The required Judo ID parameter has not been set in the Judo configuration.
 */
+ (nonnull JPError *)missingJudoIdError;

/**
 * The specified Judo ID parameter has an incorrect format.
 */
+ (nonnull JPError *)invalidJudoIdError;

/**
 * The required Currency parameter has not been set in the Judo configuration.
 */
+ (nonnull JPError *)missingCurrencyError;

/**
 * The currency code entered is either not a valid ISO 4217 code or is not supported by the SDK.
 */
+ (nonnull JPError *)invalidCurrencyError;

/**
 * Apple Pay needs a valid merchant ID to be able to identify your transaction.
 */
+ (nonnull JPError *)missingMerchantIdError;

/**
 * The country code entered is either not a valid ISO 3166 2-letter code or is not supported by the SDK.
 */
+ (nonnull JPError *)invalidCountryCodeError;

/**
 * No Apple Pay configuration was found in your Judo configuration object.
 */
+ (nonnull JPError *)missingApplePayConfigurationError;

/**
 * The amount parameter has either not been set or has an incorrect format.
 */
+ (nonnull JPError *)invalidAmountError;

/**
 * The consumer reference parameter has either not been set or has an incorrect format.
 */
+ (nonnull JPError *)invalidConsumerReferenceError;

+ (nonnull JPError *)threeDSTwoErrorFromException:(nonnull NSException *)exception;
+ (nonnull JPError *)threeDSTwoErrorFromProtocolErrorEvent:(nonnull JP3DSProtocolErrorEvent *)event;
+ (nonnull JPError *)threeDSTwoErrorFromRuntimeErrorEvent:(nonnull JP3DSRuntimeErrorEvent *)event;

@end
