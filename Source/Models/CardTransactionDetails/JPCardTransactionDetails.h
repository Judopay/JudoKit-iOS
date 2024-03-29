//
//  JPCardTransactionDetails.h
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

#import "JPCardNetworkType.h"
#import <Foundation/Foundation.h>

@class JPAddress, JPConfiguration, JPCardDetails, JPCard, JPStoredCardDetails;

@interface JPCardTransactionDetails : NSObject

@property (nonatomic, strong, nullable) NSString *cardNumber;
@property (nonatomic, strong, nullable) NSString *cardholderName;
@property (nonatomic, strong, nullable) NSString *expiryDate;
@property (nonatomic, strong, nullable) NSString *securityCode;
@property (nonatomic, strong, nullable) NSString *startDate;
@property (nonatomic, strong, nullable) NSString *issueNumber;

@property (nonatomic, strong, nullable) JPAddress *billingAddress;

@property (nonatomic, strong, nullable) NSString *emailAddress;
@property (nonatomic, strong, nullable) NSString *phoneCountryCode;
@property (nonatomic, strong, nullable) NSString *mobileNumber;

@property (nonatomic, strong, nullable) NSString *cardToken;
@property (nonatomic, strong, nullable) NSString *cardLastFour;
@property (nonatomic, assign) JPCardNetworkType cardType;
@property (nonatomic, strong, nullable) NSString *endDate;

+ (nonnull instancetype)detailsWithConfiguration:(nonnull JPConfiguration *)configuration;

- (nonnull instancetype)initWithConfiguration:(nonnull JPConfiguration *)configuration;

+ (nonnull instancetype)detailsWithConfiguration:(nonnull JPConfiguration *)configuration
                                  andCardDetails:(nonnull JPCardDetails *)details;

- (nonnull instancetype)initWithConfiguration:(nonnull JPConfiguration *)configuration
                               andCardDetails:(nonnull JPCardDetails *)details;

- (nonnull instancetype)initWithConfiguration:(nonnull JPConfiguration *)configuration
                         andStoredCardDetails:(nonnull JPStoredCardDetails *)details;

- (nonnull instancetype)initWithConfiguration:(nonnull JPConfiguration *)configuration
                                      andCard:(nonnull JPCard *)card;
@end
