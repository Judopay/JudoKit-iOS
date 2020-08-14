//
//  JPPBBAService.h
//  JudoKit_iOS
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
#import "JPApiService.h"
#import "JPBankOrderSaleRequest.h"
#import "JPConfiguration.h"
#import "JPError+Additions.h"
#import "JPOrderDetails.h"
#import "JPPBBAConfiguration.h"
#import "JPResponse.h"
#import "JPUIConfiguration.h"
#import "UIApplication+Additions.h"
#import "UIView+Additions.h"

#pragma mark - Constants

static NSString *const kPendingStatus = @"PENDING";
static const NSTimeInterval kTimerDuration = 5;
static const NSTimeInterval kTimerDurationLimit = 60;
static const int kNSPOSIXErrorDomainCode = 53;

@interface JPPBBAService ()
@property (nonatomic, strong) JPConfiguration *configuration;
@property (nonatomic, strong) JPApiService *apiService;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSTimeInterval intTimer;
@property (nonatomic, strong) JPTransactionStatusView *transactionStatusView;
@end

@implementation JPPBBAService

#pragma mark - Initializers

- (instancetype)initWithConfiguration:(JPConfiguration *)configuration
                           apiService:(JPApiService *)apiService {
    if (self = [super init]) {
        self.configuration = configuration;
        self.apiService = apiService;
    }
    return self;
}

- (void)dealloc {
    [self hideStatusView];
    [self.timer invalidate];
}

#pragma mark - Public methods

- (void)openPBBAMerchantApp:(JPCompletionBlock)completion {

    JPBankOrderSaleRequest *request = [JPBankOrderSaleRequest pbbaRequestWithConfiguration:self.configuration];

    __weak typeof(self) weakSelf = self;

    [self.apiService invokeBankSaleWithRequest:request
                                 andCompletion:^(JPResponse *response, __unused JPError *error) {
                                     if (response.orderDetails.orderId && response.redirectUrl) {
                                         [weakSelf handlePBBAResponse:response completion:completion];
                                         return;
                                     }
                                     completion(nil, JPError.judoResponseParseError);
                                 }];
}

- (void)handlePBBAResponse:(JPResponse *)response completion:(JPCompletionBlock)completion {
    if (response.rawData[@"secureToken"] && response.rawData[@"pbbaBrn"]) {
        NSString *secureToken = response.rawData[@"secureToken"];
        NSString *brn = response.rawData[@"pbbaBrn"];

        [PBBAAppUtils showPBBAPopup:UIApplication.topMostViewController
                        secureToken:secureToken
                                brn:brn
                     expiryInterval:0
                           delegate:nil];
        
        completion(response, nil);
    } else {
        completion(nil, JPError.judoResponseParseError);
    }
}

- (void)pollTransactionStatusForOrderId:(NSString *)orderId completion:(JPCompletionBlock)completion {
    [self showStatusViewWith:JPTransactionStatusPending];
    [self getStatusForOrderId:orderId completion:completion];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:kTimerDuration
                                                 repeats:YES
                                                   block:^(__unused NSTimer *_Nonnull timer) {
                                                       [self getStatusForOrderId:orderId completion:completion];
                                                   }];
}

- (void)getStatusForOrderId:(NSString *)orderId completion:(JPCompletionBlock)completion {
    [self.apiService invokeOrderStatusWithOrderId:orderId
                                    andCompletion:^(JPResponse *response, JPError *error) {
                                        [self handleResponse:response
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

    if (error == nil) {
        response.receiptId = response.orderDetails.orderId;
        completion(response, error);
        [self hideStatusView];
        [self.timer invalidate];
    }
}

- (void)stopPollingTransactionStatus {
    [self.timer invalidate];
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
    if ([self.configuration.pbbaConfiguration hasDeepLinkURL]) {
        NSString *orderID = [self parseOrderIdFromURL:self.configuration.pbbaConfiguration.deeplinkURL];
        if (orderID.length > 0) {
            [self pollTransactionStatusForOrderId:orderID completion:completion];
        }
    }
}

@end
