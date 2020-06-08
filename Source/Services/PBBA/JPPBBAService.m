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
#import "JPAmount.h"
#import "JPConfiguration.h"
#import "JPError+Additions.h"
#import "JPOrderDetails.h"
#import "JPPBBAConfiguration.h"
#import "JPReference.h"
#import "JPResponse.h"
#import "JPTransactionData.h"
#import "JPTransactionService.h"
#import "JPTransactionStatusView.h"
#import "JPUIConfiguration.h"
#import "NSBundle+Additions.h"
#import "UIApplication+Additions.h"
#import "UIView+Additions.h"

#pragma mark - Constants

static NSString *const kRedirectEndpoint = @"order/bank/sale";
static NSString *const kStatusRequestEndpoint = @"order/bank/statusrequest";
static NSString *const kPendingStatus = @"PENDING";
static const float kTimerDuration = 5.0F;
static const float kTimerDurationLimit = 60.0F;
static const int kNSPOSIXErrorDomainCode = 53;

@interface JPPBBAService ()
@property (nonatomic, strong) JPConfiguration *configuration;
@property (nonatomic, strong) JPTransactionService *transactionService;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) BOOL didTimeout;
@property (nonatomic, assign) int intTimer;
@property (nonatomic, strong) JPTransactionStatusView *transactionStatusView;
@end

@implementation JPPBBAService

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
    [self hideStatusView];
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
                                          completion:^(JPResponse *response, __unused JPError *error) {
                                              JPTransactionData *data = response.items.firstObject;

                                              if (data.orderDetails.orderId && data.redirectUrl) {
                                                  [weakSelf handlePBBAResponse:response completion:completion];
                                                  return;
                                              }

                                              completion(nil, JPError.judoResponseParseError);
                                          }];
}

- (void)handlePBBAResponse:(JPResponse *)response completion:(JPCompletionBlock)completion {

    if (response.items.firstObject.rawData[@"secureToken"] && response.items.firstObject.rawData[@"pbbaBrn"]) {
        NSString *secureToken = response.items.firstObject.rawData[@"secureToken"];
        NSString *brn = response.items.firstObject.rawData[@"pbbaBrn"];
        if ([PBBAAppUtils isCFIAppAvailable]) {
            [self pollTransactionStatusForOrderId:response.items.firstObject.orderDetails.orderId completion:completion];
        }

        [PBBAAppUtils showPBBAPopup:UIApplication.topMostViewController
                        secureToken:secureToken
                                brn:brn
                     expiryInterval:0
                           delegate:nil];
    } else {
        completion(nil, JPError.judoResponseParseError);
    }
}

- (void)pollTransactionStatusForOrderId:(NSString *)orderId
                             completion:(JPCompletionBlock)completion {

    __weak typeof(self) weakSelf = self;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:kTimerDuration
                                                 repeats:YES
                                                   block:^(__unused NSTimer *_Nonnull timer) {
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
                                              [weakSelf handleResponse:response
                                                                 error:error
                                                            completion:completion];
                                          }];
}

- (void)handleResponse:(JPResponse *)response
                 error:(JPError *)error
            completion:(JPCompletionBlock)completion {
    self.intTimer += kTimerDuration;
    if (self.intTimer > kTimerDurationLimit) {
        completion(nil, JPError.judoRequestTimeoutError);
        [self.timer invalidate];
        [self hideStatusView];
        self.intTimer = 0;
        return;
    }

    if (error && error.code != kNSPOSIXErrorDomainCode) {
        completion(nil, error);
        [self hideStatusView];
        [self.timer invalidate];
        return;
    }

    if ([response.items.firstObject.orderDetails.orderStatus isEqual:kPendingStatus]) {
        [self showStatusViewWith:JPTransactionStatusPending];
        return;
    }
    if (error == nil) {
        response.items.firstObject.receiptId = response.items.firstObject.orderDetails.orderId;
        completion(response, error);
        [self hideStatusView];
        [self.timer invalidate];
    }
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

    NSString *merchantRedirectUrl = self.configuration.pbbaConfiguration.deeplinkScheme ? self.configuration.pbbaConfiguration.deeplinkScheme : @"";

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

- (void)showStatusViewWith:(JPTransactionStatus)status {
    UIViewController *viewController = UIApplication.topMostViewController;

    [self hideStatusView];
    [viewController.view addSubview:self.transactionStatusView];
    [self.transactionStatusView pinToView:viewController.view withPadding:0.0];
    [self.transactionStatusView applyTheme:self.configuration.uiConfiguration.theme];
    [self.transactionStatusView changeToTransactionStatus:status];
}

- (void)hideStatusView {
    [self.transactionStatusView removeFromSuperview];
}

#pragma mark - lazy init transactionStatusView

- (JPTransactionStatusView *)transactionStatusView {
    if (!_transactionStatusView) {
        _transactionStatusView = [JPTransactionStatusView new];
        _transactionStatusView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _transactionStatusView;
}

- (NSString *__nullable)parseOrderIdFromURL:(NSURL *_Nonnull)url {
    NSURLComponents *components = [NSURLComponents componentsWithURL:url resolvingAgainstBaseURL:NO];
    NSArray *queryItems = [components queryItems];

    for (NSURLQueryItem *item in queryItems) {
        if ([item.name isEqualToString:@"orderId"]) {
            return item.value;
        }
    }
    return nil;
}

- (void)pollingOrderStatus:(nonnull JPCompletionBlock)completion {
    if ([self.configuration.pbbaConfiguration isDeeplinkURLExist]) {
        NSString *orderID = [self parseOrderIdFromURL:self.configuration.pbbaConfiguration.deeplinkURL];
        if (orderID.length > 0) {
            [self pollTransactionStatusForOrderId:orderID completion:completion];
        }
    }
}

@end
