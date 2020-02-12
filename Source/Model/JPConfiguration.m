//
//  JPConfiguration.m
//  JudoKitObjC
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

#import "JPConfiguration.h"
#import "JPAmount.h"
#import "JPReference.h"
#import "JPPaymentMethod.h"

@interface JPConfiguration ()

@property (nonatomic, strong) NSString *_Nonnull judoId;
@property (nonatomic, strong) JPAmount *_Nonnull amount;
@property (nonatomic, strong) JPReference *_Nonnull reference;
@property (nonatomic, strong) JudoCompletionBlock _Nonnull completion;
@property (nonatomic, strong) NSArray<JPPaymentMethod *> *paymentMethods;
@property (nonatomic, strong) ApplePayConfiguration *applePayConfiguration;

@end

@implementation JPConfiguration

- (instancetype)initWithJudoID:(nonnull NSString *)judoId
                        amount:(nonnull JPAmount *)amount
                     reference:(nonnull JPReference *)reference
                    completion:(nonnull JudoCompletionBlock)completion {
    if (self = [super init]) {
        self.judoId = judoId;
        self.amount = amount;
        self.reference = reference;
        self.completion = completion;
    }
    return self;
}

- (void)addPaymentMethods:(NSArray<JPPaymentMethod *> *)methods {
    self.paymentMethods = methods;
}

- (void)addSupportedCardNetworks:(CardNetwork)networks {
    self.cardNetworks = networks;
}

- (void)configureApplePayWithMerchantId:(NSString *)merchantId
                            countryCode:(NSString *)countryCode
                    paymentSummaryItems:(NSArray<PaymentSummaryItem *> *)items {
    
    self.applePayConfiguration = [[ApplePayConfiguration alloc] initWithJudoId:self.judoId
                                                                     reference:self.reference.consumerReference
                                                                    merchantId:merchantId
                                                                      currency:self.amount.currency
                                                                   countryCode:countryCode
                                                           paymentSummaryItems:items];
}

- (void)setRequiredBillingContactFields:(ContactField)billingFields {
    self.applePayConfiguration.requiredBillingContactFields = billingFields;
}

- (void)setRequiredShippingContactFields:(ContactField)shippingFields {
    self.applePayConfiguration.requiredShippingContactFields = shippingFields;
}

- (void)setReturnedContactInfo:(ReturnedInfo)returnedInfo {
    self.applePayConfiguration.returnedContactInfo = returnedInfo;
}

@end
