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

@implementation NSError (Judo)

+ (NSError *)judoRequestFailedError {
    // TODO:
    return [NSError errorWithDomain:@"Request Failed Error" code:1 userInfo:@{}];
}

+ (NSError *)judoJSONSerializationFailedError {
    // TODO:
    return [NSError errorWithDomain:@"JSON Serialization Failed" code:1 userInfo:@{}];
}

+ (NSError *)judoJudoIdMissingError {
    // TODO:
    return [NSError errorWithDomain:@"JudoId missing" code:1 userInfo:@{}];
}

+ (NSError *)judoAmountMissingError {
    // TODO:
    return [NSError errorWithDomain:@"Amount missing" code:1 userInfo:@{}];
}

+ (NSError *)judoPaymentMethodMissingError {
    // TODO:
    return [NSError errorWithDomain:@"Payment method missing" code:1 userInfo:@{}];
}

+ (NSError *)judoReferenceMissingError {
    // TODO:
    return [NSError errorWithDomain:@"Reference missing" code:1 userInfo:@{}];
}

+ (NSError *)judoDuplicateTransactionError {
    // TODO:
    return [NSError errorWithDomain:@"duplicate transaction" code:1 userInfo:@{}];
}

+ (NSError *)judoErrorFromErrorCode:(NSInteger)code {
    // TODO:
    return [NSError errorWithDomain:@"NaN" code:1 userInfo:@{}];
}

+ (NSError *)judo3DSRequestWithPayload:(NSDictionary *)payload {
    // TODO:
    return [NSError errorWithDomain:@"NaN" code:1 userInfo:@{}];
}

@end
