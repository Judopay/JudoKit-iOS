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
#import "JPError+Additions.h"

NSString *const kPaymentEndpoint = @"transactions/payments";
NSString *const kPreauthEndpoint = @"transactions/preauths";
NSString *const kRegisterCardEndpoint = @"transactions/registercard";
NSString *const kSaveCardEndpoint = @"transactions/savecard";

static NSString *const kCollectionPathKey = @"/transactions/collections";
static NSString *const kVoidTransactionPathKey = @"/transactions/voids";
static NSString *const kCheckCardPathKey = @"transactions/checkcard";
static NSString *const kRefundPathKey = @"/transactions/refunds";

@interface JPTransactionService ()
@property (nonatomic, strong) JPSession *session;
@property (nonatomic, strong) JPTransactionEnricher *enricher;
@property (nonatomic, strong, readwrite) NSString *_Nullable transactionPath;
@property (nonatomic, strong) NSArray *enricheablePaths;
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

- (JPTransaction *)transactionWithConfiguration:(JPConfiguration *)configuration andType:(JPTransactionType)type {
    
    JPTransaction *transaction = [JPTransaction transactionWithType:type];
    transaction.judoId = configuration.judoId;
    transaction.amount = [self amountForTransactionType:configuration andType:type];
    transaction.reference = configuration.reference;
    
#if DEBUG
    // TODO: Temporary duplicate transaction solution
    // Generates a new payment reference for each Payment/PreAuth transaction
    JPReference *_Nonnull oldReference = configuration.reference;
    transaction.reference = [[JPReference alloc] initWithConsumerReference:oldReference.consumerReference
                                                          paymentReference:[JPReference generatePaymentReference]];
#endif
    
    transaction.primaryAccountDetails = configuration.primaryAccountDetails;
    return transaction;
}

- (nullable JPAmount *)amountForTransactionType:(JPConfiguration *)configuration andType:(JPTransactionType)type {
    switch (type) {
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

- (void)enrichAndPost:(JPTransaction *)transaction
              fullURL:(NSString *)fullURL
           completion:(nullable JPCompletionBlock)completion {
    if ([self.enricheablePaths containsObject:[self pathForTransaction:transaction]]) {
        [self.enricher enrichTransaction:transaction
                          withCompletion:^{
            [self.session POST:fullURL
                    parameters:[transaction getParameters]
                    completion:completion];
        }];
    } else {
        [self.session POST:fullURL
                parameters:[transaction getParameters]
                completion:completion];
    }
}

- (void)sendWithTransaction:(nonnull JPTransaction *)transaction
              andCompletion:(nonnull JPCompletionBlock)completion {
    
    if (!completion) {
        return;
    }
    
    JPError *validationError = [self validateTransaction: transaction];
    
    if (validationError) {
        completion(nil, validationError);
        return;
    }
    
    NSString *fullURL = [NSString stringWithFormat:@"%@%@", self.session.baseURL, [self pathForTransaction:transaction]];
    [self enrichAndPost:transaction fullURL:fullURL completion:completion];
}


- (JPError *)validateTransaction:(nonnull JPTransaction *)transaction {
    if (!transaction.judoId) {
        return JPError.judoJudoIdMissingError;
    }
    
    if (!transaction.card && !transaction.paymentToken && !transaction.pkPayment && !transaction.vcoResult) {
        return JPError.judoPaymentMethodMissingError;
    }
    
    if (!transaction.reference) {
        return JPError.judoReferenceMissingError;
    }
    
    BOOL isRegisterCard = (transaction.transactionType == JPTransactionTypeRegisterCard);
    BOOL isCheckCard = (transaction.transactionType == JPTransactionTypeCheckCard);
    BOOL isSaveCard = (transaction.transactionType == JPTransactionTypeSaveCard);
    if (!isRegisterCard && !isCheckCard && !isSaveCard && !transaction.amount) {
        return JPError.judoAmountMissingError;
    }
    return nil;
}


#pragma mark - Setters

- (void)setIsSandboxed:(BOOL)isSandboxed {
    _isSandboxed = isSandboxed;
    self.session.sandboxed = isSandboxed;
}

- (NSString *)pathForTransaction:(JPTransaction *)transaction {
    switch (transaction.transactionType) {
        case JPTransactionTypePayment:
            return kPaymentEndpoint;
            
        case JPTransactionTypePreAuth:
            return kPreauthEndpoint;
            
        case JPTransactionTypeRegisterCard:
            return kRegisterCardEndpoint;
            
        case JPTransactionTypeSaveCard:
            return kSaveCardEndpoint;
            
        case JPTransactionTypeCheckCard:
            return kCheckCardPathKey;
            
        case JPTransactionTypeRefund:
            return kRefundPathKey;
            
        case JPTransactionTypeCollection:
            return kCollectionPathKey;
            
        case JPTransactionTypeVoid:
            return kVoidTransactionPathKey;
            
        default:
            return nil;
    }
}

- (NSArray *)enricheablePaths {
    if (!_enricheablePaths) {
        _enricheablePaths = @[ kPaymentEndpoint,
                               kPreauthEndpoint,
                               kRegisterCardEndpoint,
                               kSaveCardEndpoint ];
    }
    return _enricheablePaths;
}

@end
