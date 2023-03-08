//
//  JPTransactionViewDelegate.m
//  JudoKit_iOS
//
//  Copyright (c) 2023 Alternative Payments Ltd
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

#import "JPTransactionViewDelegate.h"
#import "JPCardTransactionDetails.h"
#import "JPCardTransactionService.h"
#import "JPConfiguration.h"
#import "JPTransactionType.h"

@interface JPTransactionViewDelegateTokenPaymentImpl ()

@property (strong, nonatomic) JPApiService *apiService;
@property (nonatomic, assign) JPTransactionType transactionType;
@property (nonatomic, strong) JPConfiguration *configuration;
@property (nonatomic, strong) JPCardTransactionDetails *cardDetails;
@property (nonatomic, strong) JPCompletionBlock completionBlock;

@end

@implementation JPTransactionViewDelegateTokenPaymentImpl

- (nonnull instancetype)initWithAPIService:(JPApiService *)apiService
                                      type:(JPTransactionType)type
                             configuration:(JPConfiguration *)configuration
                                   details:(JPCardTransactionDetails *)details
                                completion:(JPCompletionBlock)completion {
    if (self = [super init]) {
        self.apiService = apiService;
        self.transactionType = type;
        self.configuration = configuration;
        self.cardDetails = details;
        self.completionBlock = completion;
    }
    return self;
}

- (void)executeTokenPaymentTransaction {
    JPCardTransactionService *transactionService = [[JPCardTransactionService alloc] initWithAPIService:self.apiService andConfiguration:self.configuration];
    switch (self.transactionType) {
        case JPTransactionTypePayment:
            [transactionService invokeTokenPaymentWithDetails:self.cardDetails andCompletion:self.completionBlock];
            break;

        case JPTransactionTypePreAuth:
            [transactionService invokePreAuthTokenPaymentWithDetails:self.cardDetails andCompletion:self.completionBlock];
            break;

        default:
            // noop
            break;
    }
}

@end

@implementation JPTransactionViewDelegateTokenPaymentImpl (TransactionDelegate)

- (void)didFinishAddingCard {
    // noop
}

- (void)didInputSecurityCode:(NSString *)csc andCardholderName:(NSString *)cardholderName {
    if (csc != nil) {
        self.cardDetails.secureCode = csc;
    }
    if (cardholderName != nil) {
        self.cardDetails.cardholderName = cardholderName;
    }
    [self executeTokenPaymentTransaction];
}

- (void)didCancel {
    // noop
}

@end
