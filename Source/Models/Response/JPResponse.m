//
//  JPResponse.m
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

#import "JPResponse.h"
#import "Functions.h"
#import "JPAmount.h"
#import "JPCardDetails.h"
#import "JPConsumer.h"
#import "JPOrderDetails.h"
#import "NSString+Additions.h"

static NSString *const kStatusDeclined = @"declined";
static NSString *const kStatusSuccess = @"success";
static NSString *const kStatusError = @"error";

static NSString *const kTransactionTypePayment = @"payment";
static NSString *const kTransactionTypePreAuth = @"preauth";
static NSString *const kTransactionTypeRegister __deprecated = @"register";
static NSString *const kTransactionTypeRegisterCard __deprecated = @"registercard";
static NSString *const kTransactionTypeSaveCard = @"save";
static NSString *const kTransactionTypeCheckCard = @"checkcard";

@implementation JPResponse

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        [self populateWith:dictionary];
    }
    return self;
}

- (void)populateWith:(NSDictionary *)dictionary {
    self.receiptId = dictionary[@"receiptId"];
    self.type = [self transactionTypeForString:dictionary[@"type"]];
    self.createdAt = dictionary[@"createdAt"];
    self.result = [self transactionResultForString:dictionary[@"result"]];
    self.message = dictionary[@"message"];
    self.redirectUrl = dictionary[@"redirectUrl"];
    self.merchantName = dictionary[@"merchantName"];
    self.emailAddress = dictionary[@"emailAddress"];
    self.appearsOnStatementAs = dictionary[@"appearsOnStatementAs"];
    self.paymentMethod = dictionary[@"paymentMethod"];
    self.judoId = getSafeStringRepresentation(dictionary[@"judoId"]);

    [self setupPaymentReferenceFromDictionary:dictionary];
    [self setupConsumerFromDictionary:dictionary];
    [self setupIDEALFromDictionary:dictionary];

    NSString *currency = dictionary[@"currency"];
    if (dictionary[@"refunds"]) {
        self.refunds = [[JPAmount alloc] initWithAmount:getSafeStringRepresentation(dictionary[@"refunds"])
                                               currency:currency];
    }

    self.originalAmount = getSafeStringRepresentation(dictionary[@"originalAmount"]);
    self.netAmount = getSafeStringRepresentation(dictionary[@"netAmount"]);

    NSString *amount = getSafeStringRepresentation(dictionary[@"amount"]);

    if (amount != nil) {
        self.amount = [[JPAmount alloc] initWithAmount:amount currency:currency];
    }

    NSDictionary *cardDetailsDictionary = dictionary[@"cardDetails"];
    if (cardDetailsDictionary) {
        self.cardDetails = [[JPCardDetails alloc] initWithDictionary:cardDetailsDictionary];
    }

    NSDictionary *yourPaymentMetaData = dictionary[@"yourPaymentMetaData"];
    if (yourPaymentMetaData) {
        self.yourPaymentMetaData = yourPaymentMetaData;
    }

    self.rawData = dictionary;
}

- (void)setupPaymentReferenceFromDictionary:(NSDictionary *)dictionary {
    if (dictionary[@"merchantPaymentReference"]) {
        self.paymentReference = dictionary[@"merchantPaymentReference"];
    } else {
        self.paymentReference = dictionary[@"yourPaymentReference"];
    }
}

- (void)setupConsumerFromDictionary:(NSDictionary *)dictionary {
    if (dictionary[@"merchantConsumerReference"]) {
        NSDictionary *consumerDictionary = @{
            @"yourConsumerReference" : dictionary[@"merchantConsumerReference"]
        };
        self.consumer = [[JPConsumer alloc] initWithDictionary:consumerDictionary];
    } else {
        self.consumer = [[JPConsumer alloc] initWithDictionary:dictionary[@"consumer"]];
    }
}

- (void)setupIDEALFromDictionary:(NSDictionary *)dictionary {

    NSDictionary *orderDetailsDict = dictionary[@"orderDetails"];
    NSString *orderId = dictionary[@"orderId"];

    if (orderDetailsDict) {
        self.orderDetails = [[JPOrderDetails alloc] initWithDictionary:orderDetailsDict];
    }

    if (orderId) {
        self.orderDetails = [JPOrderDetails new];
        self.orderDetails.orderId = orderId;
    }
}

- (JPTransactionResult)transactionResultForString:(NSString *)resultString {
    if ([resultString _jp_isEqualIgnoringCaseToString:kStatusSuccess]) {
        return JPTransactionResultSuccess;
    }

    if ([resultString _jp_isEqualIgnoringCaseToString:kStatusDeclined]) {
        return JPTransactionResultDeclined;
    }

    if ([resultString _jp_isEqualIgnoringCaseToString:kStatusError]) {
        return JPTransactionResultError;
    }

    return JPTransactionResultUnknown;
}

- (JPTransactionType)transactionTypeForString:(NSString *)typeString {
    if ([typeString _jp_isEqualIgnoringCaseToString:kTransactionTypePayment]) {
        return JPTransactionTypePayment;
    }

    if ([typeString _jp_isEqualIgnoringCaseToString:kTransactionTypePreAuth]) {
        return JPTransactionTypePreAuth;
    }

    if ([typeString _jp_isEqualIgnoringCaseToString:kTransactionTypeRegister] || [typeString _jp_isEqualIgnoringCaseToString:kTransactionTypeRegisterCard]) {
        return JPTransactionTypeRegisterCard;
    }

    if ([typeString _jp_isEqualIgnoringCaseToString:kTransactionTypeCheckCard]) {
        return JPTransactionTypeCheckCard;
    }

    if ([typeString _jp_isEqualIgnoringCaseToString:kTransactionTypeSaveCard]) {
        return JPTransactionTypeSaveCard;
    }

    return JPTransactionTypeUnknown;
}

@end
