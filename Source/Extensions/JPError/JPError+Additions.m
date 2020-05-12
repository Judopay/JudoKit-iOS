//
//  JPError+Additions.m
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

#import "JPCardNetwork.h"
#import "JPError+Additions.h"
#import "JPTransactionData.h"
#import "NSString+Additions.h"
#import "JPError.h"

NSString *const JudoErrorDomain = @"com.judo.error";
NSString *const UnableToProcessRequestErrorDesc = @"unable_to_process_request_error_desc";
NSString *const UnableToProcessRequestErrorTitle = @"unable_to_process_request_error_title";
NSString *const ErrorUnsupportedCardNetworkTitle = @"error_unsupported_card_network_title";
NSString *const ErrorUnsupportedCardNetworkDescription = @"error_unsupported_card_network_desc";
NSString *const JPErrorTitleKey = @"JPErrorTitleKey";
NSString *const ErrorRequestFailed = @"error_request_failed";
NSString *const ErrorPaymentMethodMissing = @"error_payment_method_missing";
NSString *const ErrorAmountMissing = @"error_amount_missing";
NSString *const ErrorReferenceMissing = @"error_reference_missing";
NSString *const ErrorTokenMissing = @"error_token_missing";
NSString *const ErrorResponseParseError = @"error_response_parse_error";
NSString *const ErrorUserDidCancel = @"error_user_did_cancel";
NSString *const ErrorParameterError = @"error_parameter_error";
NSString *const ErrorFailed3DSRequest = @"error_failed_3DS_request";
NSString *const ErrorJailbrokenDeviceDisallowed = @"error_jailbroken_device_disallowed";
NSString *const Error3DSRequest = @"error_3DS_request";
NSString *const ErrorUnderlyingError = @"error_underlying_error";
NSString *const ErrorTransactionDeclined = @"error_transaction_declined";
NSString *const ErrorInvalidIDEALCurrency = @"error_invalid_ideal_currency";
NSString *const ErrorApplePayNotSupported = @"error_apple_pay_unsupported";
NSString *const ErrorSiteIDMissing = @"error_site_id_missing";

@implementation JPError (Additions)

+ (JPError *)judoSiteIDMissingError {
    NSDictionary *userInfo = [self userDataDictWithDescription:ErrorSiteIDMissing.localized
                                                 failureReason:nil
                                                         title:nil];
    return [JPError errorWithDomain:JudoErrorDomain
                               code:JudoErrorParameterError
                           userInfo:userInfo];
}

+ (JPError *)judoInvalidIDEALCurrencyError {

    NSDictionary *userInfo = [self userDataDictWithDescription:ErrorInvalidIDEALCurrency.localized
                                                 failureReason:nil
                                                         title:nil];

    return [JPError errorWithDomain:JudoErrorDomain
                               code:JudoErrorParameterError
                           userInfo:userInfo];
}

+ (JPError *)judoApplePayNotSupportedError {

    NSDictionary *userInfo = [self userDataDictWithDescription:ErrorApplePayNotSupported.localized
                                                 failureReason:nil
                                                         title:nil];

    return [JPError errorWithDomain:JudoErrorDomain
                               code:JudoErrorGeneral_Error
                           userInfo:userInfo];
}

+ (JPError *)judoJailbrokenDeviceDisallowedError {
    return [JPError errorWithDomain:JudoErrorDomain
                               code:JudoErrorJailbrokenDeviceDisallowed
                           userInfo:[self userDataDictWithDescription:UnableToProcessRequestErrorDesc.localized
                                                        failureReason:ErrorJailbrokenDeviceDisallowed.localized
                                                                title:UnableToProcessRequestErrorTitle.localized]];
}

+ (JPError *)judoRequestFailedError {
    return [JPError errorWithDomain:JudoErrorDomain
                               code:JudoErrorRequestFailed
                           userInfo:[self userDataDictWithDescription:UnableToProcessRequestErrorDesc.localized
                                                        failureReason:ErrorRequestFailed.localized
                                                                title:UnableToProcessRequestErrorTitle.localized]];
}

+ (JPError *)judoRequestTimeoutError {
    return [JPError errorWithDomain:JudoErrorDomain
                               code:JudoErrorRequestFailed
                           userInfo:[self userDataDictWithDescription:@"error_timeout_description".localized
                                                        failureReason:@"error_timeout_description".localized
                                                                title:@"error_timeout_title".localized]];
}

+ (JPError *)judoJSONSerializationFailedWithError:(nullable JPError *)error {
    return [JPError errorWithDomain:JudoErrorDomain
                               code:JudoErrorJSONSerializationFailed
                           userInfo:@{NSUnderlyingErrorKey : error}];
}

+ (JPError *)judoJudoIdMissingError {
    return [JPError errorWithDomain:JudoErrorDomain
                               code:JudoErrorJudoIdMissing
                           userInfo:@{}];
}

+ (JPError *)judoAmountMissingError {
    return [JPError errorWithDomain:JudoErrorDomain
                               code:JudoErrorAmountMissing
                           userInfo:[self userDataDictWithDescription:UnableToProcessRequestErrorDesc.localized
                                                        failureReason:ErrorAmountMissing.localized
                                                                title:UnableToProcessRequestErrorTitle.localized]];
}

+ (JPError *)judoPaymentMethodMissingError {
    return [JPError errorWithDomain:JudoErrorDomain
                               code:JudoErrorPaymentMethodMissing
                           userInfo:[self userDataDictWithDescription:UnableToProcessRequestErrorDesc.localized
                                                        failureReason:ErrorPaymentMethodMissing.localized
                                                                title:UnableToProcessRequestErrorTitle.localized]];
}

+ (JPError *)judoReferenceMissingError {
    return [JPError errorWithDomain:JudoErrorDomain
                               code:JudoErrorReferenceMissing
                           userInfo:[self userDataDictWithDescription:UnableToProcessRequestErrorDesc.localized
                                                        failureReason:ErrorReferenceMissing.localized
                                                                title:UnableToProcessRequestErrorTitle.localized]];
}

+ (JPError *)judoTokenMissingError {
    return [JPError errorWithDomain:JudoErrorDomain
                               code:JudoErrorTokenMissing
                           userInfo:[self userDataDictWithDescription:UnableToProcessRequestErrorDesc.localized
                                                        failureReason:ErrorTokenMissing.localized
                                                                title:UnableToProcessRequestErrorTitle.localized]];
}

+ (JPError *)judoDuplicateTransactionError {
    return [JPError errorWithDomain:JudoErrorDomain
                               code:JudoErrorDuplicateTransaction
                           userInfo:@{}];
}

+ (JPError *)judo3DSRequestFailedErrorWithUnderlyingError:(JPError *)underlyingError {
    if (underlyingError) {
        return [JPError errorWithDomain:JudoErrorDomain
                                   code:JudoErrorFailed3DSRequest
                               userInfo:[self userDataDictWithDescription:UnableToProcessRequestErrorDesc.localized
                                                            failureReason:ErrorFailed3DSRequest.localized
                                                                    title:UnableToProcessRequestErrorTitle.localized
                                                              currentDict:@{NSUnderlyingErrorKey : underlyingError}]];
    }
    return [JPError errorWithDomain:JudoErrorDomain
                               code:JudoErrorFailed3DSRequest
                           userInfo:[self userDataDictWithDescription:UnableToProcessRequestErrorDesc.localized
                                                        failureReason:ErrorFailed3DSRequest.localized
                                                                title:UnableToProcessRequestErrorTitle.localized]];
}

+ (JPError *)judoErrorFromTransactionData:(JPTransactionData *)data {
    return [JPError errorWithDomain:JudoErrorDomain
                               code:JudoErrorTransactionDeclined
                           userInfo:data.rawData];
}

+ (JPError *)judoErrorFromDictionary:(NSDictionary *)dict {
    NSString *messageFromDict = dict[@"message"];
    NSString *errorMessage = messageFromDict == nil ? UnableToProcessRequestErrorDesc.localized : messageFromDict;
    return [JPError errorWithDomain:JudoErrorDomain
                               code:[dict[@"code"] integerValue]
                           userInfo:[self userDataDictWithDescription:errorMessage
                                                        failureReason:nil
                                                                title:UnableToProcessRequestErrorTitle.localized
                                                          currentDict:dict]];
}

+ (JPError *)judoErrorFromError:(JPError *)error {
    return [JPError errorWithDomain:JudoErrorDomain
                               code:JudoErrorUnderlyingError
                           userInfo:@{NSUnderlyingErrorKey : error}];
}

+ (JPError *)judoUserDidCancelError {
    return [JPError errorWithDomain:JudoErrorDomain
                               code:JudoErrorUserDidCancel
                           userInfo:[self userDataDictWithDescription:nil
                                                        failureReason:ErrorUserDidCancel.localized
                                                                title:nil]];
}

+ (JPError *)judoParameterError {
    return [JPError errorWithDomain:JudoErrorDomain
                               code:JudoErrorParameterError
                           userInfo:[self userDataDictWithDescription:UnableToProcessRequestErrorDesc.localized
                                                        failureReason:ErrorParameterError.localized
                                                                title:UnableToProcessRequestErrorTitle.localized]];
}

+ (JPError *)judoInternetConnectionError {
    return [JPError errorWithDomain:JudoErrorDomain
                               code:JudoErrorGeneral_Error
                           userInfo:[self userDataDictWithDescription:@"no_internet_error_description".localized
                                                        failureReason:@"no_internet_error_description".localized
                                                                title:@"no_internet_error_title".localized]];
}

+ (JPError *)judoJPApplePayConfigurationError {
    return [JPError errorWithDomain:JudoErrorDomain
                               code:JudoErrorInvalidJPApplePayConfiguration
                           userInfo:@{NSLocalizedDescriptionKey : @"Invalid Apple Pay configuration"}];
}

+ (JPError *)judoInvalidCardNumberError {
    return [JPError errorWithDomain:JudoErrorDomain
                               code:JudoErrorInvalidCardNumberError
                           userInfo:@{NSLocalizedDescriptionKey : @"check_card_number".localized}];
}

+ (JPError *)judoUnsupportedCardNetwork:(JPCardNetworkType)network {

    NSString *cardNetworkName = [JPCardNetwork nameOfCardNetwork:network];
    NSString *description = [NSString stringWithFormat:ErrorUnsupportedCardNetworkDescription.localized, cardNetworkName];

    return [JPError errorWithDomain:JudoErrorDomain
                               code:JudoErrorUnsupportedCardNetwork
                           userInfo:[self userDataDictWithDescription:description
                                                        failureReason:description
                                                                title:ErrorUnsupportedCardNetworkTitle.localized]];
}

+ (JPError *)judoResponseParseError {
    return [JPError errorWithDomain:JudoErrorDomain
                               code:JudoErrorResponseParseError
                           userInfo:[self userDataDictWithDescription:UnableToProcessRequestErrorDesc.localized
                                                        failureReason:ErrorResponseParseError.localized
                                                                title:UnableToProcessRequestErrorTitle.localized]];
}

+ (JPError *)judoMissingChecksumError {

    NSDictionary *userInfo = [self userDataDictWithDescription:@"error_checksum_missing_description".localized
                                                 failureReason:@"error_checksum_missing_description".localized
                                                         title:@"error_checksum_missing_title".localized];

    return [JPError errorWithDomain:JudoErrorDomain
                               code:JudoErrorGeneral_Error
                           userInfo:userInfo];
}

+ (JPError *)judo3DSRequestWithPayload:(NSDictionary *)payload {
    return [JPError errorWithDomain:JudoErrorDomain code:JudoError3DSRequest userInfo:payload];
}

+ (JPError *)judoInputMismatchErrorWithMessage:(NSString *)message {
    if (message) {
        return [JPError errorWithDomain:JudoErrorDomain
                                   code:JudoErrorInputMismatchError
                               userInfo:@{NSLocalizedDescriptionKey : message}];
    }

    return [JPError errorWithDomain:JudoErrorDomain code:JudoErrorInputMismatchError userInfo:nil];
}

+ (NSDictionary *)userDataDictWithDescription:(NSString *)description
                                failureReason:(NSString *)failureReason
                                        title:(NSString *)title {
    NSDictionary *newDict = [NSDictionary new];
    return [self userDataDictWithDescription:description
                               failureReason:failureReason
                                       title:title
                                 currentDict:newDict];
}

+ (NSDictionary *)userDataDictWithDescription:(NSString *)description
                                failureReason:(NSString *)failureReason
                                        title:(NSString *)title
                                  currentDict:(NSDictionary *)currentDict {
    NSMutableDictionary *mutableDict = [currentDict mutableCopy];
    if (description) {
        mutableDict[NSLocalizedDescriptionKey] = description;
    }
    if (failureReason) {
        mutableDict[NSLocalizedFailureReasonErrorKey] = failureReason;
    }

    if (title) {
        mutableDict[JPErrorTitleKey] = title;
    }

    return [mutableDict copy];
}

@end
