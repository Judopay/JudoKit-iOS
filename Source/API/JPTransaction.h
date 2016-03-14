//
//  JPTransaction.h
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

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <PassKit/PassKit.h>

@class JPResponse, JPPagination, JPSession, JPPaymentToken, JPCard, JPAmount, JPReference;

@interface JPTransaction : NSObject

@property (nonatomic, strong, readonly) NSString * _Nullable transactionPath;

@property (nonatomic, strong) NSString * __nonnull judoId;
@property (nonatomic, strong) JPReference * __nonnull reference;
@property (nonatomic, strong) JPAmount * __nonnull amount;

@property (nonatomic, strong) JPCard * _Nullable card;
@property (nonatomic, strong) JPPaymentToken * _Nullable paymentToken;
@property (nonatomic, strong, readonly) PKPayment * _Nullable pkPayment;

@property (nonatomic, assign) CLLocationCoordinate2D location;
@property (nonatomic, strong) NSDictionary * _Nullable deviceSignal;

@property (nonatomic, strong) NSString * _Nullable mobileNumber;
@property (nonatomic, strong) NSString * _Nullable emailAddress;

@property (nonatomic, strong) JPSession * _Nullable apiSession;

- (void)setPkPayment:(nonnull PKPayment *)pkPayment error:(NSError * __autoreleasing _Nullable * _Nullable)error;

- (nullable NSError *)validateTransaction;

- (void)sendWithCompletion:(nonnull void(^)(JPResponse * _Nullable, NSError * _Nullable))completion;

- (void)threeDSecureWithParameters:(nonnull NSDictionary *)parameters completion:(nonnull void (^)(JPResponse * _Nullable, NSError * _Nullable))completion;

- (void)listWithCompletion:(nonnull void(^)(JPResponse * _Nullable, NSError * _Nullable))completion;

- (void)listWithPagination:(nullable JPPagination *)pagination completion:(nonnull void(^)(JPResponse * _Nullable, NSError * _Nullable))completion;

@end
