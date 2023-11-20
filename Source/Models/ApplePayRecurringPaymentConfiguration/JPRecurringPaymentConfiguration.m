//
//  JPRecurringPaymentConfiguration.h
//  JudoKit_iOS
//
//  Created by Rafal Ozog on 20/11/2023.
//  Copyright © 2023 Judo Payments. All rights reserved.
//

#import "JPRecurringPaymentConfiguration.h"

@implementation JPRecurringPaymentConfiguration

- (instancetype)initWithDescription:(NSString *)paymentDescription
                      managementURL:(NSString *)managementURL
                              label:(NSString *)label
                             amount:(NSDecimalNumber *)amount
                       intervalUnit:(NSCalendarUnit *)intervalUnit
                      intervalCount:(NSInteger *)intervalCount
                   billingAgreement:(nullable NSString *)billingAgreement {
    self = [super init];
    if (self) {
        _paymentDescription = paymentDescription;
        _managementURL = managementURL;
        _label = label;
        _amount = amount;
        _intervalUnit = intervalUnit;
        _intervalCount = intervalCount;
        _billingAgreement = billingAgreement;
    }
    return self;
}

@end
