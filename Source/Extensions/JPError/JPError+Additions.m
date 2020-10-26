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

NSString *const JudoErrorDomain = @"com.judo.error";

@implementation JPError (Additions)

+ (JPError *)judoInvalidIDEALCurrencyError {
    return [self errorWithDescription:@"error_invalid_ideal_currency_desc".localized
                        failureReason:@"error_invalid_ideal_currency_reason".localized
                               ofType:JudoParameterError];
}

+ (JPError *)judoInvalidPBBACurrencyError {
    return [self errorWithDescription:@"error_invalid_pbba_currency_desc".localized
                        failureReason:@"error_invalid_pbba_currency_reason".localized
                               ofType:JudoParameterError];
}

+ (NSError *)judoPBBAURLSchemeMissingError {
    return [self errorWithDescription:@"error_invalid_pbba_url_scheme_desc".localized
                        failureReason:@"error_invalid_pbba_url_scheme_reason".localized
                               ofType:JudoParameterError];
}

+ (JPError *)judoApplePayNotSupportedError {
    return [self errorWithDescription:@"error_apple_pay_not_supported_desc".localized
                        failureReason:@"error_apple_pay_not_supported_reason".localized
                               ofType:JudoParameterError];
}

+ (JPError *)judoRequestFailedError {
    return [self errorWithDescription:@"error_request_failed_desc".localized
                        failureReason:@"error_request_failed_reason".localized
                               ofType:JudoRequestError];
}

+ (JPError *)judoRequestTimeoutError {
    return [self errorWithDescription:@"error_request_timeout_desc".localized
                        failureReason:@"error_request_timeout_reason".localized
                               ofType:JudoRequestError];
}

+ (JPError *)judoJSONSerializationFailedWithError:(JPError *)error {
    return [self errorWithDescription:@"error_json_serialization_desc".localized
                        failureReason:@"error_json_serialization_reason".localized
                               ofType:JudoRequestError];
}

+ (JPError *)judoUserDidCancelError {
    return [self errorWithDescription:@"error_user_cancelled_desc".localized
                        failureReason:@"error_user_cancelled_reason".localized
                               ofType:JudoUserDidCancelError];
}

+ (JPError *)judoInternetConnectionError {
    return [self errorWithDescription:@"error_internet_connection_desc".localized
                        failureReason:@"error_internet_connection_reason".localized
                               ofType:JudoRequestError];
}

+ (JPError *)judoInvalidCardNumberError {
    return [self errorWithDescription:@"error_invalid_card_number_desc".localized
                        failureReason:@"error_invalid_card_number_reason".localized
                               ofType:JudoParameterError];
}

+ (JPError *)judoApplePayMissingPaymentItemsError {
    return [self errorWithDescription:@"error_apple_pay_missing_items_desc".localized
                        failureReason:@"error_apple_pay_missing_items_reason".localized
                               ofType:JudoParameterError];
}

+ (JPError *)judoApplePayMissingShippingMethodsError {
    return [self errorWithDescription:@"error_apple_pay_missing_shipping_desc".localized
                        failureReason:@"error_apple_pay_missing_shipping_reason".localized
                               ofType:JudoParameterError];
}

+ (JPError *)judoMissingJudoIdError {
    return [self errorWithDescription:@"error_judo_id_missing_desc".localized
                        failureReason:@"error_judo_id_missing_reason".localized
                               ofType:JudoParameterError];
}

+ (JPError *)judoInvalidJudoIdError {
    return [self errorWithDescription:@"error_invalid_judo_id_desc".localized
                        failureReason:@"error_invalid_judo_id_reason".localized
                               ofType:JudoParameterError];
}

+ (JPError *)judoMissingCurrencyError {
    return [self errorWithDescription:@"error_currency_missing_desc".localized
                        failureReason:@"error_currency_missing_reason".localized
                               ofType:JudoParameterError];
}

+ (JPError *)judoInvalidCurrencyError {
    return [self errorWithDescription:@"error_invalid_currency_desc".localized
                        failureReason:@"error_invalid_currency_reason".localized
                               ofType:JudoParameterError];
}

+ (JPError *)judoMissingMerchantIdError {
    return [self errorWithDescription:@"error_apple_pay_merchant_id_missing_desc".localized
                        failureReason:@"error_apple_pay_merchant_id_missing_reason".localized
                               ofType:JudoParameterError];
}

+ (JPError *)judoInvalidCountryCodeError {
    return [self errorWithDescription:@"error_invalid_country_code_desc".localized
                        failureReason:@"error_invalid_country_code_reason".localized
                               ofType:JudoParameterError];
}

+ (JPError *)judoMissingApplePayConfigurationError {
    return [self errorWithDescription:@"error_apple_pay_config_missing_desc".localized
                        failureReason:@"error_apple_pay_config_missing_reason".localized
                               ofType:JudoParameterError];
}

+ (JPError *)judoInvalidAmountError {
    return [self errorWithDescription:@"error_invalid_amount_desc".localized
                        failureReason:@"error_invalid_amount_reason".localized
                               ofType:JudoParameterError];
}

+ (JPError *)judoInvalidConsumerReferenceError {
    return [self errorWithDescription:@"error_invalid_consumer_ref_desc".localized
                        failureReason:@"error_invalid_consumer_ref_reason".localized
                               ofType:JudoParameterError];
}

+ (JPError *)judoResponseParseError {
    return [self errorWithDescription:@"error_response_parse_desc".localized
                        failureReason:@"error_response_parse_reason".localized
                               ofType:JudoRequestError];
}

+ (JPError *)judoUnsupportedCardNetwork:(JPCardNetworkType)network {
    NSString *cardNetworkName = [JPCardNetwork nameOfCardNetwork:network];
    NSString *description = [NSString stringWithFormat:@"error_unsupported_card_desc".localized, cardNetworkName];

    return [self errorWithDescription:description
                        failureReason:@"error_unsupported_card_reason".localized
                               ofType:JudoParameterError];
}

+ (JPError *)judoErrorFromDictionary:(NSDictionary *)dictionary {
    NSString *defaultMessage = @"error_no_message_desc".localized;

    NSString *parsedMessage;
    NSObject *parsedDetails = [dictionary valueForKey:@"details"];

    if ([parsedDetails isKindOfClass:NSArray.class]) {
        NSArray *parsedArray = (NSArray *)parsedDetails;
        parsedMessage = [parsedArray.firstObject valueForKey:@"message"];
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
                        failureReason:@"error_no_message_reason".localized
                               ofType:[dictionary[@"code"] integerValue]];
}

+ (JPError *)judo3DSRequestWithPayload:(NSDictionary *)payload {
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

@end
