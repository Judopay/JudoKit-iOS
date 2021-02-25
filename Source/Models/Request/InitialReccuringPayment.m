//
//  InitialReccuringPayment.m
//  JudoKit-iOS
//
//  Created by Andrei Movila on 2/25/21.
//

#import "JPInitialReccuringPaymentRequest.h"
#import "JPConfiguration.h"

@implementation JPInitialReccuringPaymentRequest

- (nonnull instancetype)initWithConfiguration:(nonnull JPConfiguration *)configuration {
    self = [super initWithConfiguration:configuration];
    _initialRecurringPayment = configuration.initialRecurringPayment;
    return self;
}

@end
