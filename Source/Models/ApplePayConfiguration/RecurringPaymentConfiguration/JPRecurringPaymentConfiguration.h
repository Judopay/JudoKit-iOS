//
//  JPRecurringPaymentConfiguration.h
//  JudoKit_iOS
//
//  Created by Rafal Ozog on 20/11/2023.
//  Copyright © 2023 Judo Payments. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JPRecurringPaymentConfiguration : NSObject

@property (nonatomic, strong, nonnull) NSString *paymentDescription;
@property (nonatomic, strong, nullable) NSString *billingAgreement;
@property (nonatomic, strong, nonnull) NSString *managementURL;
@property (nonatomic, strong, nonnull) NSString *label;
@property (nonatomic, strong, nonnull) NSDecimalNumber *amount;
@property (nonatomic, nullable) NSCalendarUnit *intervalUnit;
@property (nonatomic, nullable) NSInteger *intervalCount;
@property (nonatomic, strong, nonnull) NSString *startDate;
@property (nonatomic, strong, nonnull) NSString *endDate;

- (instancetype)initWithDescription:(NSString *)paymentDescription
                   billingAgreement:(NSString *)billingAgreement
                      managementURL:(NSString *)managementURL
                              label:(NSString *)label
                             amount:(NSDecimalNumber *)amount
                       intervalUnit:(NSCalendarUnit *)intervalUnit
                      intervalCount:(NSInteger *)intervalCount
                          startDate:(NSString *)startDate
                         andEndDate:(NSString *)endDate;

@end
