//
//  JPCardTransactionDetails.m
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

#import "JPCardTransactionDetails.h"
#import "JPCard.h"
#import "JPCardDetails.h"
#import "JPConfiguration.h"
#import "JPStoredCardDetails.h"

@implementation JPCardTransactionDetails

+ (instancetype)detailsWithConfiguration:(JPConfiguration *)configuration {
    return [[JPCardTransactionDetails alloc] initWithConfiguration:configuration];
}

- (instancetype)initWithConfiguration:(JPConfiguration *)configuration {
    if (self = [super init]) {
        [self setConfiguration:configuration];
    }
    return self;
}

+ (instancetype)detailsWithConfiguration:(JPConfiguration *)configuration andCardDetails:(JPCardDetails *)details {
    return [[JPCardTransactionDetails alloc] initWithConfiguration:configuration andCardDetails:details];
}

- (instancetype)initWithConfiguration:(JPConfiguration *)configuration andCardDetails:(JPCardDetails *)details {
    if (self = [super init]) {
        [self setConfiguration:configuration];
        [self setCardDetails:details];
    }
    return self;
}

- (instancetype)initWithConfiguration:(JPConfiguration *)configuration andCard:(JPCard *)card {
    if (self = [super init]) {
        [self setConfiguration:configuration];
        [self setCard:card];
        _cardType = [JPCardNetwork cardNetworkForCardNumber:card.cardNumber];
    }
    return self;
}

- (instancetype)initWithConfiguration:(JPConfiguration *)configuration
                 andStoredCardDetails:(JPStoredCardDetails *)details {
    if (self = [super init]) {
        [self setConfiguration:configuration];
        [self setStoredCardDetails:details];
    }
    return self;
}

- (void)setStoredCardDetails:(JPStoredCardDetails *)details {
    _cardToken = details.cardToken;
    _cardType = details.cardNetwork;
    _cardLastFour = details.cardLastFour;
    _endDate = details.expiryDate;
}

- (void)setConfiguration:(JPConfiguration *)configuration {
    _billingAddress = configuration.cardAddress;
    _emailAddress = configuration.emailAddress;
    _phoneCountryCode = configuration.phoneCountryCode;
    _mobileNumber = configuration.mobileNumber;
}

- (void)setCardDetails:(JPCardDetails *)details {
    _cardToken = details.cardToken;
    _cardType = details.cardNetwork;
    _cardLastFour = details.cardLastFour;
    _endDate = details.endDate;
}

- (void)setCard:(JPCard *)card {
    _cardNumber = card.cardNumber;
    _cardholderName = card.cardholderName;
    _expiryDate = card.expiryDate;
    _secureCode = card.secureCode;
    _startDate = card.startDate;
    _issueNumber = card.issueNumber;
    _billingAddress = card.cardAddress;
}

@end
