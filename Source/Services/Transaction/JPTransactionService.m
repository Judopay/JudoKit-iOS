//
//  JPTransactionService.m
//  JudoKit-iOS
//
//  Copyright (c) 2019 Alternative Payments Ltd
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

#import "JPTransactionService.h"
#import "JPAmount.h"
#import "JPCard.h"
#import "JPConfiguration.h"
#import "JPReference.h"
#import "JPSession.h"
#import "JPTransaction.h"
#import "JPTransactionEnricher.h"

@interface JPTransactionService ()
@property (nonatomic, strong) JPSession *session;
@property (nonatomic, strong) JPTransactionEnricher *enricher;
@end

@implementation JPTransactionService

#pragma mark - Initializers

- (instancetype)initWithToken:(NSString *)token
                    andSecret:(NSString *)secret {
    if (self = [super init]) {
        [self setupSessionWithToken:token andSecret:secret];
        [self setupTransactionEnricherWithToken:token andSecret:secret];
    }
    return self;
}

#pragma mark - Setup methods

- (void)setupTransactionEnricherWithToken:(NSString *)token
                                andSecret:(NSString *)secret {
    self.enricher = [[JPTransactionEnricher alloc] initWithToken:token
                                                          secret:secret];
}

- (void)setupSessionWithToken:(NSString *)token
                    andSecret:(NSString *)secret {

    NSString *formattedString = [NSString stringWithFormat:@"%@:%@", token, secret];
    NSData *encodedStringData = [formattedString dataUsingEncoding:NSISOLatin1StringEncoding];
    NSString *base64String = [encodedStringData base64EncodedStringWithOptions:0];

    NSString *authorizationHeader = [NSString stringWithFormat:@"Basic %@", base64String];
    self.session = [JPSession sessionWithAuthorizationHeader:authorizationHeader];
}

#pragma mark - Public methods

- (JPTransaction *)transactionWithConfiguration:(JPConfiguration *)configuration {

    JPTransaction *transaction = [JPTransaction transactionWithType:self.transactionType];
    transaction.judoId = configuration.judoId;
    transaction.amount = [self amountForTransactionType:configuration];
    transaction.reference = configuration.reference;
    
    #if DEBUG
        // TODO: Temporary duplicate transaction solution
        // Generates a new payment reference for each Payment/PreAuth transaction
        JPReference *oldReference = configuration.reference;
        transaction.reference = [[JPReference alloc] initWithConsumerReference:oldReference.consumerReference
                                                              paymentReference:[JPReference generatePaymentReference]];
    #endif
    
    transaction.primaryAccountDetails = configuration.primaryAccountDetails;
    transaction.apiSession = self.session;
    transaction.enricher = self.enricher;

    return transaction;
}

- (nullable JPAmount *)amountForTransactionType:(JPConfiguration *)configuration {
    switch (self.transactionType) {
        case JPTransactionTypeCheckCard:
            return [JPAmount amount:@"0.00" currency:@"GBP"];
        case JPTransactionTypeSaveCard:
            return nil;
        case JPTransactionTypeRegisterCard:
            return configuration.amount ? configuration.amount : [JPAmount amount:@"0.01" currency:@"GBP"];
        default:
            return configuration.amount;
    }
}

- (void)sendRequestWithEndpoint:(NSString *)endpoint
                     httpMethod:(JPHTTPMethod)httpMethod
                     parameters:(NSDictionary *)parameters
                     completion:(JPCompletionBlock)completion {

    NSString *url = [NSString stringWithFormat:@"%@%@", self.session.baseURL, endpoint];

    if (httpMethod == JPHTTPMethodPOST) {
        [self.session POST:url parameters:parameters completion:completion];
        return;
    }

    [self.session GET:url parameters:parameters completion:completion];
}

#pragma mark - Setters

- (void)setIsSandboxed:(BOOL)isSandboxed {
    _isSandboxed = isSandboxed;
    self.session.sandboxed = isSandboxed;
}

@end
