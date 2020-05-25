//
//  JPPBBAService.h
//  JudoKit-iOS
//
//  Copyright (c) 2020 Alternative Payments Ltd
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

#import "JPPBBAService.h"
#import "JPPBBAConfiguration.h"
#import "JPAmount.h"
#import "JPOrderDetails.h"
#import "JPReference.h"
#import "JPResponse.h"
#import "JPTransactionData.h"
#import "JPError+Additions.h"
#import "UIApplication+Additions.h"
#import "UIView+Additions.h"
#import "JPConfiguration.h"
#import "JPTransactionService.h"
#import "NSBundle+Additions.h"

@interface JPPBBAService ()
@property (nonatomic, strong) JPConfiguration *configuration;
@property (nonatomic, strong) JPTransactionService *transactionService;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) BOOL didTimeout;
@property (nonatomic, assign) int intTimer;
@end

@implementation JPPBBAService

#pragma mark - Constants

static NSString *const kRedirectEndpoint = @"order/bank/sale";
static NSString *const kStatusRequestEndpoint = @"order/bank/statusrequest";
static NSString *const kPendingStatus = @"PENDING";
static const float kTimerDuration = 5.0f;
static const float kTimerDurationLimit = 60.0f;
static const int NSPOSIXErrorDomainCode = 53;

#pragma mark - Initializers

- (instancetype)initWithConfiguration:(JPConfiguration *)configuration
                   transactionService:(JPTransactionService *)transactionService {
    if (self = [super init]) {
        self.configuration = configuration;
        self.transactionService = transactionService;
    }
    return self;
}

- (void)dealloc {
    [self.statusViewDelegate hideStatusView];
    [self.timer invalidate];
}

#pragma mark - Public methods

- (void)openPBBAMerchantApp:(JPCompletionBlock)completion {
    NSDictionary *parameters = [self parametersForPBBA];

    if (!parameters) {
        completion(nil, JPError.judoSiteIDMissingError);
        return;
    }

    __weak typeof(self) weakSelf = self;
    [self.transactionService sendRequestWithEndpoint:kRedirectEndpoint
                                          httpMethod:JPHTTPMethodPOST
                                          parameters:parameters
                                          completion:^(JPResponse *response, JPError *error) {
        JPTransactionData *data = response.items.firstObject;

        if (data.orderDetails.orderId && data.redirectUrl) {
            [weakSelf handlePBBAResponse:response completion: completion];
            return;
        }

        completion(nil, JPError.judoResponseParseError);
    }];
}

- (void)handlePBBAResponse:(JPResponse *)response completion:(JPCompletionBlock)completion  {

    if (response.items.firstObject.rawData[@"secureToken"] && response.items.firstObject.rawData[@"pbbaBrn"])  {
        NSString *secureToken = response.items.firstObject.rawData[@"secureToken"];
        NSString *brn = response.items.firstObject.rawData[@"pbbaBrn"];
        if ([PBBAAppUtils isCFIAppAvailable]) {
            [self pollTransactionStatusForOrderId:response.items.firstObject.orderDetails.orderId completion: completion];
        }

        [PBBAAppUtils showPBBAPopup:UIApplication.topMostViewController secureToken:secureToken brn:brn delegate:nil];
    } else {
        completion(nil, JPError.judoResponseParseError);
    }
}

- (void)pollTransactionStatusForOrderId:(NSString *)orderId
                             completion:(JPCompletionBlock)completion {

    __weak typeof(self) weakSelf = self;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:kTimerDuration
                                                 repeats:YES
                                                   block:^(NSTimer *_Nonnull timer) {
        [weakSelf getStatusForOrderId:orderId completion:completion];
    }];
}

- (void)getStatusForOrderId:(NSString *)orderId
                 completion:(JPCompletionBlock)completion {

    if (self.didTimeout) {
        return;
    }

    NSString *statusEndpoint = [NSString stringWithFormat:@"%@/%@", kStatusRequestEndpoint, orderId];

    __weak typeof(self) weakSelf = self;
    [self.transactionService sendRequestWithEndpoint:statusEndpoint
                                          httpMethod:JPHTTPMethodGET
                                          parameters:nil
                                          completion:^(JPResponse *response, JPError *error) {
        self.intTimer += kTimerDuration;
        if (self.intTimer > kTimerDurationLimit) {
            completion(nil, JPError.judoRequestTimeoutError);
            [weakSelf.timer invalidate];
            [self.statusViewDelegate hideStatusView];
            self.intTimer = 0;
            return;
        }

        if (error && error.code != NSPOSIXErrorDomainCode) {
            completion(nil, error);
            [self.statusViewDelegate hideStatusView];
            [weakSelf.timer invalidate];
            return;
        }

        if ([response.items.firstObject.orderDetails.orderStatus isEqual:kPendingStatus]) {
            [self.statusViewDelegate showStatusViewWith:JPTransactionStatusPending];
            return;
        }
        if (error == nil) {
            response.items.firstObject.receiptId = response.items.firstObject.orderDetails.orderId;
            completion(response, error);
            [self.statusViewDelegate hideStatusView];
            [weakSelf.timer invalidate];
        }
    }];
}

- (void)stopPollingTransactionStatus {
    self.didTimeout = YES;
    [self.timer invalidate];
}

- (NSDictionary *)parametersForPBBA {

    if (!self.configuration.siteId) {
        return nil;
    }

    JPAmount *amount = self.configuration.amount;
    JPReference *reference = self.configuration.reference;

    NSString *merchantRedirectUrl = [NSString stringWithFormat:@"%@://", NSBundle.appURLScheme];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:@{
        @"paymentMethod" : @"PBBA",
        @"currency" : amount.currency,
        @"amount" : @(amount.amount.doubleValue),
        @"country" : @"GB",
        @"accountHolderName" : @"PBBA User",
        @"merchantPaymentReference" : reference.paymentReference,
        @"bic" : @"RABONL2U",
        @"merchantConsumerReference" : reference.consumerReference,
        @"siteId" : self.configuration.siteId,
        @"merchantRedirectUrl" : merchantRedirectUrl
    }];

    if (self.configuration.pbbaConfiguration.mobileNumber) {
        [parameters setValue:self.configuration.pbbaConfiguration.mobileNumber forKey:@"mobileNumber"];
    }
    if (self.configuration.pbbaConfiguration.emailAddress) {
        [parameters setValue:self.configuration.pbbaConfiguration.emailAddress forKey:@"emailAddress"];
    }
    if (self.configuration.pbbaConfiguration.appearsOnStatement) {
        [parameters setValue:self.configuration.pbbaConfiguration.mobileNumber forKey:@"appearsOnStatement"];
    }

    return parameters;
}

@end
