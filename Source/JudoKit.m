//
//  JudoKit.m
//  JudoKitObjC
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

#import "JudoKit.h"
#import "JPTransactionEnricher.h"
#import "ApplePayManager.h"
#import "JPConfiguration.h"
#import "SliderTransitioningDelegate.h"
#import "JPTransactionService.h"
#import "JPTransactionBuilder.h"
#import "JPTransactionViewController.h"
#import "JPTransaction.h"
#import "JPReceipt.h"
#import "NSError+Additions.h"
#import "JPResponse.h"
#import "JPTheme.h"
#import "UIApplication+Additions.h"

@interface JudoKit ()
@property (nonatomic, strong) JPTransactionService *transactionService;
@property (nonatomic, strong) ApplePayManager *manager;
@property (nonatomic, strong) ApplePayConfiguration *configuration;
@property (nonatomic, strong) PKPaymentAuthorizationViewController *viewController;
@property (nonatomic, strong) JudoCompletionBlock completionBlock;
@property (nonatomic, strong) SliderTransitioningDelegate *transitioningDelegate;
@end

@implementation JudoKit

//---------------------------------------------------------------------------
#pragma mark - Initializers
//---------------------------------------------------------------------------

- (instancetype)initWithToken:(NSString *)token secret:(NSString *)secret {
    return [self initWithToken:token secret:secret allowJailbrokenDevices:YES];
}

- (instancetype)initWithToken:(NSString *)token
                       secret:(NSString *)secret
       allowJailbrokenDevices:(BOOL)jailbrokenDevicesAllowed {

    self = [super init];
    BOOL isDeviceSupported = !(!jailbrokenDevicesAllowed && UIApplication.isCurrentDeviceJailbroken);

    if (self && isDeviceSupported) {
        self.transactionService = [[JPTransactionService alloc] initWithToken:token
                                                                    andSecret:secret];
        return self;
    }
    
    return nil;
}

//---------------------------------------------------------------------------
#pragma mark - Public methods
//---------------------------------------------------------------------------

//TODO: Further investigate this

- (JPTransaction *)transactionWithType:(TransactionType)type
                         configuration:(JPConfiguration *)configuration
                            completion:(JudoCompletionBlock)completion {
    
    self.transactionService.transactionType = type;
    return [self.transactionService transactionWithConfiguration:configuration
                                                      completion:completion];
}

- (void)invokeTransactionWithType:(TransactionType)type
                    configuration:(JPConfiguration *)configuration
                       completion:(JudoCompletionBlock)completion {
    
    self.transactionService.transactionType = type;
    
    UIViewController *controller;
    controller = [JPTransactionBuilderImpl buildModuleWithTransactionService:self.transactionService
                                                               configuration:configuration
                                                                  completion:completion];
    controller.modalPresentationStyle = UIModalPresentationCustom;
    controller.transitioningDelegate = self.transitioningDelegate;
    [UIApplication.topMostViewController presentViewController:controller
                                                      animated:YES
                                                    completion:nil];
}

- (void)invokeApplePayWithMode:(TransactionMode)mode
                 configuration:(ApplePayConfiguration *)configuration
                    completion:(JudoCompletionBlock)completion {
    //TODO: Invoke Apple Pay
}

- (void)invokePaymentMethodScreenWithMode:(TransactionMode)mode
                            configuration:(JPConfiguration *)configuration
                               completion:(JudoCompletionBlock)completion {
    //TODO: Invoke Payment Method Screen
}

- (void)listTransactionsOfType:(TransactionType)type
                     paginated:(JPPagination *)pagination
                    completion:(JudoCompletionBlock)completion {
    [self.transactionService listTransactionsOfType:type
                                          paginated:pagination
                                         completion:completion];
}

- (JPReceipt *)receiptForReceiptId:(NSString *)receiptId {
    return [self.transactionService receiptForReceiptId:receiptId];
}

//---------------------------------------------------------------------------
#pragma mark - Lazy properties
//---------------------------------------------------------------------------

- (SliderTransitioningDelegate *)transitioningDelegate {
    if (!_transitioningDelegate) {
        _transitioningDelegate = [SliderTransitioningDelegate new];
    }
    return _transitioningDelegate;
}

- (void)setIsSandboxed:(BOOL)isSandboxed {
    _isSandboxed = isSandboxed;
    self.transactionService.isSandboxed = isSandboxed;
}

//---------------------------------------------------------------------------
#pragma mark - PKPaymentAuthorizationViewControllerDelegate methods
//---------------------------------------------------------------------------

//TODO: Consider moving logic to Apple Pay services
- (void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller
                       didAuthorizePayment:(PKPayment *)payment
                                completion:(void (^)(PKPaymentAuthorizationStatus))completion {

    JPTransaction *transaction;

    if (self.configuration.transactionType == TransactionTypePreAuth) {
        //TODO: Make a preAuth transaction
    } else {
        //TODO: Make a payment transaction
    }

    NSError *error;
    [transaction setPkPayment:payment error:&error];

    if (error) {
        self.completionBlock(nil, [NSError judoJSONSerializationFailedWithError:error]);
        completion(PKPaymentAuthorizationStatusFailure);
        return;
    }

    [transaction sendWithCompletion:^(JPResponse *response, NSError *error) {

            if (error || response.items.count == 0) {
                self.completionBlock(response, error);
                completion(PKPaymentAuthorizationStatusFailure);
                return;
            }

            if (self.configuration.returnedContactInfo & ReturnedInfoBillingContacts) {
                response.billingInfo = [self.manager contactInformationFromPaymentContact:payment.billingContact];
            }

            if (self.configuration.returnedContactInfo & ReturnedInfoShippingContacts) {
                response.shippingInfo = [self.manager contactInformationFromPaymentContact:payment.shippingContact];
            }

            self.completionBlock(response, error);
            completion(PKPaymentAuthorizationStatusSuccess);
    }];
}

- (void)paymentAuthorizationViewControllerDidFinish:(PKPaymentAuthorizationViewController *)controller {
    [controller dismissViewControllerAnimated:YES completion:nil];
}

@end
