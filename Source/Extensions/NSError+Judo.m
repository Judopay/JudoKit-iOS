//
//  NSError+Judo.m
//  JudoKitObjC
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

#import "NSError+Judo.h"
#import "JPTransactionData.h"

NSString * const JudoErrorDomain = @"com.judo.error";

@implementation NSError (Judo)

+ (NSError *)judoRequestFailedError {
    // TODO: userInfo
    return [NSError errorWithDomain:JudoErrorDomain code:JudoErrorRequestFailed userInfo:@{}];
}

+ (NSError *)judoJSONSerializationFailedWithError:(NSError *)error {
    return [NSError errorWithDomain:JudoErrorDomain code:JudoErrorJSONSerializationFailed userInfo:@{NSUnderlyingErrorKey:error}];
}

+ (NSError *)judoJudoIdMissingError {
    // TODO: userInfo
    return [NSError errorWithDomain:JudoErrorDomain code:JudoErrorJudoIdMissing userInfo:@{}];
}

+ (NSError *)judoAmountMissingError {
    // TODO: userInfo
    return [NSError errorWithDomain:JudoErrorDomain code:JudoErrorAmountMissing userInfo:@{}];
}

+ (NSError *)judoPaymentMethodMissingError {
    // TODO: userInfo
    return [NSError errorWithDomain:JudoErrorDomain code:JudoErrorPaymentMethodMissing userInfo:@{}];
}

+ (NSError *)judoReferenceMissingError {
    // TODO: userInfo
    return [NSError errorWithDomain:JudoErrorDomain code:JudoErrorReferenceMissing userInfo:@{}];
}

+ (NSError *)judoDuplicateTransactionError {
    // TODO: userInfo
    return [NSError errorWithDomain:JudoErrorDomain code:JudoErrorDuplicateTransaction userInfo:@{}];
}

+ (NSError *)judo3DSRequestFailedErrorWithUnderlyingError:(NSError *)underlyingError {
    if (underlyingError) {
        return [NSError errorWithDomain:JudoErrorDomain code:JudoErrorFailed3DSRequest userInfo:@{NSUnderlyingErrorKey:underlyingError}];
    }
    return [NSError errorWithDomain:JudoErrorDomain code:JudoErrorFailed3DSRequest userInfo:@{}];
}

+ (NSError *)judoErrorFromTransactionData:(JPTransactionData *)data {
    return [NSError errorWithDomain:JudoErrorDomain code:JudoErrorTransactionDeclined userInfo:data.rawData];
}

+ (NSError *)judoErrorFromDictionary:(NSDictionary *)dict {
    return [NSError errorWithDomain:JudoErrorDomain code:[dict[@"code"] integerValue] userInfo:dict];
}

+ (NSError *)judoErrorFromError:(NSError *)error {
    return [NSError errorWithDomain:JudoErrorDomain code:JudoErrorUnderlyingError userInfo:@{NSUnderlyingErrorKey:error}];
}

+ (NSError *)judoUserDidCancelError {
    return [NSError errorWithDomain:JudoErrorDomain code:JudoErrorUserDidCancel userInfo:nil];
}

+ (NSError *)judoParameterError {
    return [NSError errorWithDomain:JudoErrorDomain code:JudoErrorParameterError userInfo:nil];
}

+ (NSError *)judoInvalidCardNumberError {
    return [NSError errorWithDomain:JudoErrorDomain code:JudoErrorInvalidCardNumberError userInfo:@{NSLocalizedDescriptionKey:@"Check card number"}];
}

+ (NSError *)judoResponseParseError {
    return [NSError errorWithDomain:JudoErrorDomain code:JudoErrorResponseParseError userInfo:@{}];
}

+ (NSError *)judo3DSRequestWithPayload:(NSDictionary *)payload {
    return [NSError errorWithDomain:JudoErrorDomain code:JudoError3DSRequest userInfo:payload];
}

+ (NSError *)judoInputMismatchErrorWithMessage:(NSString *)message {
    if (message) {
        return [NSError errorWithDomain:JudoErrorDomain code:JudoErrorInputMismatchError userInfo:@{NSLocalizedDescriptionKey:message}];
    } else {
        return [NSError errorWithDomain:JudoErrorDomain code:JudoErrorInputMismatchError userInfo:nil];
    }
}

@end
