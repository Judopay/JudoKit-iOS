//
//  JPCReqParameters.m
//  JudoKit_iOS
//
//  Copyright (c) 2022 Alternative Payments Ltd
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

#import "JPCReqParameters.h"

NS_ASSUME_NONNULL_BEGIN

@implementation JPCReqParameters

- (instancetype)initWithString:(NSString *)cReq {
    if (self = [super init]) {
        NSMutableString *decodedString = [cReq mutableCopy];
        switch (decodedString.length % 4) {
            case 0:
                break; // no padding
            case 2:
                [decodedString appendString:@"=="]; // pad with 2
                break;
            case 3:
                [decodedString appendString:@"="]; // pad with 1
                break;
            default:
                return nil; // invalid base64url string
        }
        NSData *data = [[NSData alloc] initWithBase64EncodedString:decodedString options:0];
        NSError *error = nil;
        NSDictionary *json = @{};
        if (data) {
            json = [NSJSONSerialization JSONObjectWithData:data
                                                   options:NSJSONReadingAllowFragments
                                                     error:&error];
        }

        _messageVersion = @"2.1.0";

        if (!error && json) {
            _messageType = json[@"messageType"];
            _messageVersion = json[@"messageVersion"];
            _threeDSServerTransID = json[@"threeDSServerTransID"];
            _acsTransID = json[@"acsTransID"];
        }
    }

    return self;
}

@end

NS_ASSUME_NONNULL_END
