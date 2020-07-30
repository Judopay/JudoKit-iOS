//
//  JPIDEALService.m
//  JudoKit_iOS
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

#import "JPIDEALService.h"
#import "JPApiService.h"
#import "JPBankOrderSaleRequest.h"
#import "JPConfiguration.h"
#import "JPError+Additions.h"
#import "JPIDEALBank.h"
#import "JPOrderDetails.h"
#import "JPReference.h"
#import "JPResponse.h"

#pragma mark - Constants

static const float kTimerDuration = 60.0F;

@interface JPIDEALService ()
@property (nonatomic, strong) JPConfiguration *configuration;
@property (nonatomic, strong) JPApiService *apiService;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) BOOL didTimeout;
@end

@implementation JPIDEALService

#pragma mark - Initializers

- (instancetype)initWithConfiguration:(JPConfiguration *)configuration apiService:(JPApiService *)apiService {
    if (self = [super init]) {
        self.configuration = configuration;
        self.apiService = apiService;
    }
    return self;
}

- (void)dealloc {
    [self.timer invalidate];
}

#pragma mark - Public methods

- (void)redirectURLForIDEALBank:(JPIDEALBank *)iDealBank completion:(JPCompletionBlock)completion {

    if (self.configuration.siteId.length == 0) {
        completion(nil, JPError.judoSiteIDMissingError);
        return;
    }

    JPBankOrderSaleRequest *request = [JPBankOrderSaleRequest idealRequestWithConfiguration:self.configuration
                                                                                     andBIC:iDealBank.bankIdentifierCode];

#if DEBUG
    // TODO: Temporary duplicate transaction solution
    // Generates a new payment reference for each iDEAL redirect transaction
    request.merchantPaymentReference = [JPReference generatePaymentReference];
#endif

    [self.apiService invokeBankSaleWithRequest:request
                                 andCompletion:^(JPResponse *response, NSError *error) {
                                     if (response.orderDetails.orderId && response.redirectUrl) {
                                         response.receiptId = response.orderDetails.orderId;
                                         completion(response, (JPError *)error);
                                         return;
                                     }

                                     completion(nil, JPError.judoResponseParseError);
                                 }];
}

- (void)pollTransactionStatusForOrderId:(NSString *)orderId
                               checksum:(NSString *)checksum
                             completion:(JPCompletionBlock)completion {
    __weak typeof(self) weakSelf = self;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:kTimerDuration
                                                 repeats:NO
                                                   block:^(NSTimer *_Nonnull timer) {
                                                       weakSelf.didTimeout = true;
                                                       completion(nil, JPError.judoRequestTimeoutError);
                                                       return;
                                                   }];

    [self getStatusForOrderId:orderId checksum:checksum completion:completion];
}

- (void)getStatusForOrderId:(NSString *)orderId
                   checksum:(NSString *)checksum
                 completion:(JPCompletionBlock)completion {

    if (self.didTimeout) {
        return;
    }

    __weak typeof(self) weakSelf = self;
    [self.apiService invokeOrderStatusWithOrderId:orderId
                                    andCompletion:^(JPResponse *response, NSError *error) {
                                        if (error) {
                                            completion(nil, (JPError *)error);
                                            [weakSelf.timer invalidate];
                                            return;
                                        }

                                        if ([response.orderDetails.orderStatus isEqual:@"PENDING"]) {
                                            dispatch_time_t timeInterval = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10.0 * NSEC_PER_SEC));
                                            dispatch_after(timeInterval, dispatch_get_main_queue(), ^{
                                                [weakSelf getStatusForOrderId:orderId checksum:checksum completion:completion];
                                            });
                                            return;
                                        }

                                        response.receiptId = response.orderDetails.orderId;
                                        completion(response, nil);
                                        [weakSelf.timer invalidate];
                                    }];
}

- (void)stopPollingTransactionStatus {
    self.didTimeout = YES;
    [self.timer invalidate];
}

@end
