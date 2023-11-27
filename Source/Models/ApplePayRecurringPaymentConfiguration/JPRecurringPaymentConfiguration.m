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
                   billingAgreement:(nullable NSString *)billingAgreement
                      managementURL:(NSString *)managementURL
                              label:(NSString *)label
                             amount:(NSDecimalNumber *)amount
                       intervalUnit:(NSCalendarUnit *)intervalUnit
                      intervalCount:(NSInteger *)intervalCount
                          startDate:(NSString *)startDate
                            endDate:(NSString *)endDate {
    self = [super init];
    if (self) {
        _paymentDescription = paymentDescription;
        _billingAgreement = billingAgreement;
        _managementURL = managementURL;
        _label = label;
        _amount = amount;
        _intervalUnit = intervalUnit;
        _intervalCount = intervalCount;
        _startDate = startDate;
        _endDate = endDate;
    }
    return self;
}

@end
