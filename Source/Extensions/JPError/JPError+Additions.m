//
//  JPError+Additions.m
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

#import "JPCardNetwork.h"
#import "JPError+Additions.h"
#import "JPResponse.h"
#import "NSString+Additions.h"
#import <Judo3DS2_iOS/Judo3DS2_iOS.h>

NSString *const JudoErrorDomain = @"com.judo.error";

@implementation JPError (Additions)

+ (JPError *)invalidTokenPaymentTransactionType {
    return [self errorWithDescription:@"error_invalid_token_payment_transaction_type_desc"._jp_localized
                        failureReason:@"error_invalid_token_payment_transaction_type_reason"._jp_localized
                               ofType:JudoParameterError];
}

+ (JPError *)invalidIDEALCurrencyError {
    return [self errorWithDescription:@"error_invalid_ideal_currency_desc"._jp_localized
                        failureReason:@"error_invalid_ideal_currency_reason"._jp_localized
                               ofType:JudoParameterError];
}

+ (JPError *)applePayNotSupportedError {
    return [self errorWithDescription:@"error_apple_pay_not_supported_desc"._jp_localized
                        failureReason:@"error_apple_pay_not_supported_reason"._jp_localized
                               ofType:JudoParameterError];
}

+ (JPError *)requestFailedError {
    return [self errorWithDescription:@"error_request_failed_desc"._jp_localized
                        failureReason:@"error_request_failed_reason"._jp_localized
                               ofType:JudoRequestError];
}

+ (JPError *)requestTimeoutError {
    return [self errorWithDescription:@"error_request_timeout_desc"._jp_localized
                        failureReason:@"error_request_timeout_reason"._jp_localized
                               ofType:JudoRequestError];
}

+ (JPError *)JSONSerializationFailedWithError:(JPError *)error {
    return [self errorWithDescription:@"error_json_serialization_desc"._jp_localized
                        failureReason:@"error_json_serialization_reason"._jp_localized
                               ofType:JudoRequestError];
}

+ (JPError *)userDidCancelError {
    return [self errorWithDescription:@"error_user_cancelled_desc"._jp_localized
                        failureReason:@"error_user_cancelled_reason"._jp_localized
                               ofType:JudoUserDidCancelError];
}

+ (JPError *)internetConnectionError {
    return [self errorWithDescription:@"error_internet_connection_desc"._jp_localized
                        failureReason:@"error_internet_connection_reason"._jp_localized
                               ofType:JudoRequestError];
}

+ (JPError *)invalidCardNumberError {
    return [self errorWithDescription:@"error_invalid_card_number_desc"._jp_localized
                        failureReason:@"error_invalid_card_number_reason"._jp_localized
                               ofType:JudoParameterError];
}

+ (JPError *)applePayMissingPaymentItemsError {
    return [self errorWithDescription:@"error_apple_pay_missing_items_desc"._jp_localized
                        failureReason:@"error_apple_pay_missing_items_reason"._jp_localized
                               ofType:JudoParameterError];
}

+ (JPError *)applePayMissingShippingMethodsError {
    return [self errorWithDescription:@"error_apple_pay_missing_shipping_desc"._jp_localized
                        failureReason:@"error_apple_pay_missing_shipping_reason"._jp_localized
                               ofType:JudoParameterError];
}

+ (JPError *)missingJudoIdError {
    return [self errorWithDescription:@"error_judo_id_missing_desc"._jp_localized
                        failureReason:@"error_judo_id_missing_reason"._jp_localized
                               ofType:JudoParameterError];
}

+ (JPError *)invalidJudoIdError {
    return [self errorWithDescription:@"error_invalid_judo_id_desc"._jp_localized
                        failureReason:@"error_invalid_judo_id_reason"._jp_localized
                               ofType:JudoParameterError];
}

+ (JPError *)missingCurrencyError {
    return [self errorWithDescription:@"error_currency_missing_desc"._jp_localized
                        failureReason:@"error_currency_missing_reason"._jp_localized
                               ofType:JudoParameterError];
}

+ (JPError *)invalidCurrencyError {
    return [self errorWithDescription:@"error_invalid_currency_desc"._jp_localized
                        failureReason:@"error_invalid_currency_reason"._jp_localized
                               ofType:JudoParameterError];
}

+ (JPError *)missingMerchantIdError {
    return [self errorWithDescription:@"error_apple_pay_merchant_id_missing_desc"._jp_localized
                        failureReason:@"error_apple_pay_merchant_id_missing_reason"._jp_localized
                               ofType:JudoParameterError];
}

+ (JPError *)invalidCountryCodeError {
    return [self errorWithDescription:@"error_invalid_country_code_desc"._jp_localized
                        failureReason:@"error_invalid_country_code_reason"._jp_localized
                               ofType:JudoParameterError];
}

+ (JPError *)missingApplePayConfigurationError {
    return [self errorWithDescription:@"error_apple_pay_config_missing_desc"._jp_localized
                        failureReason:@"error_apple_pay_config_missing_reason"._jp_localized
                               ofType:JudoParameterError];
}

+ (JPError *)invalidAmountError {
    return [self errorWithDescription:@"error_invalid_amount_desc"._jp_localized
                        failureReason:@"error_invalid_amount_reason"._jp_localized
                               ofType:JudoParameterError];
}

+ (JPError *)invalidConsumerReferenceError {
    return [self errorWithDescription:@"error_invalid_consumer_ref_desc"._jp_localized
                        failureReason:@"error_invalid_consumer_ref_reason"._jp_localized
                               ofType:JudoParameterError];
}

+ (JPError *)responseParseError {
    return [self errorWithDescription:@"error_response_parse_desc"._jp_localized
                        failureReason:@"error_response_parse_reason"._jp_localized
                               ofType:JudoRequestError];
}

+ (JPError *)unsupportedCardNetwork:(JPCardNetworkType)network {
    NSString *cardNetworkName = [JPCardNetwork nameOfCardNetwork:network];
    NSString *description = [NSString stringWithFormat:@"error_unsupported_card_desc"._jp_localized, cardNetworkName];

    return [self errorWithDescription:description
                        failureReason:@"error_unsupported_card_reason"._jp_localized
                               ofType:JudoParameterError];
}

+ (JPError *)errorFromDictionary:(NSDictionary *)dictionary {
    NSString *defaultMessage = @"error_no_message_desc"._jp_localized;

    NSString *parsedMessage;
    NSObject *parsedDetails = [dictionary valueForKey:@"details"];

    if ([parsedDetails isKindOfClass:NSArray.class]) {
        NSArray *parsedArray = (NSArray *)parsedDetails;

        if ([parsedArray.firstObject isKindOfClass:NSDictionary.class]) {
            NSDictionary *parsedDictionary = (NSDictionary *)parsedArray.firstObject;
            parsedMessage = [parsedDictionary valueForKey:@"message"];
        }
    }

    if ([parsedDetails isKindOfClass:NSDictionary.class]) {
        NSDictionary *parsedDictionary = (NSDictionary *)parsedDetails;
        parsedMessage = [parsedDictionary valueForKey:@"message"];
    }

    if (parsedMessage == nil) {
        parsedMessage = [dictionary valueForKey:@"message"];
    }

    NSString *message = parsedMessage == nil ? defaultMessage : parsedMessage;

    return [self errorWithDescription:message
                        failureReason:@"error_no_message_reason"._jp_localized
                               ofType:[dictionary[@"code"] integerValue]];
}

+ (JPError *)threeDSRequestWithPayload:(NSDictionary *)payload {
    return [JPError errorWithDomain:JudoErrorDomain
                               code:Judo3DSRequestError
                           userInfo:payload];
}

+ (JPError *)errorWithDescription:(NSString *)description
                    failureReason:(NSString *)failureReason
                           ofType:(JudoError)type {

    NSDictionary *userInfo = [self userDataDictWithDescription:description
                                                 failureReason:failureReason];

    return [JPError errorWithDomain:JudoErrorDomain
                               code:type
                           userInfo:userInfo];
}

+ (NSDictionary *)userDataDictWithDescription:(NSString *)description
                                failureReason:(NSString *)failureReason {
    NSMutableDictionary *newDict = [NSMutableDictionary new];

    if (description) {
        newDict[NSLocalizedDescriptionKey] = description;
    }

    if (failureReason) {
        newDict[NSLocalizedFailureReasonErrorKey] = failureReason;
    }

    return [newDict copy];
}

+ (JPError *)threeDSTwoErrorFromException:(NSException *)exception {
    NSMutableDictionary *info = [NSMutableDictionary new];

    if (exception.name) {
        info[NSUnderlyingErrorKey] = exception.name;
    }

    if (exception.reason) {
        info[NSLocalizedDescriptionKey] = exception.reason;
    }

    return [JPError judoThreeDSTwoErrorWithUserInfo:[NSDictionary dictionaryWithDictionary:info]];
}

+ (JPError *)threeDSTwoErrorFromProtocolErrorEvent:(JP3DSProtocolErrorEvent *)event {
    JP3DSErrorMessage *message = event.errorMessage;
    NSString *details = message.errorDetails;

    NSDictionary *info = @{
        NSLocalizedDescriptionKey : details
    };

    return [JPError judoThreeDSTwoErrorWithUserInfo:info];
}

+ (JPError *)threeDSTwoErrorFromRuntimeErrorEvent:(JP3DSRuntimeErrorEvent *)event {
    NSDictionary *info = @{
        NSLocalizedDescriptionKey : event.errorMessage
    };

    return [JPError judoThreeDSTwoErrorWithUserInfo:info];
}

+ (JPError *)judoThreeDSTwoErrorWithUserInfo:(NSDictionary *)userInfo {
    return [[JPError alloc] initWithDomain:JudoErrorDomain
                                      code:JudoErrorThreeDSTwo
                                  userInfo:userInfo];
}

@end
