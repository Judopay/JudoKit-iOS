//
//  JPAmount.m
//  JudoKitObjC
//
//  Created by ben.riazy on 12/02/2016.
//  Copyright © 2016 Judo Payments. All rights reserved.
//

#import "JPAmount.h"

@interface JPAmount ()

@property (nonatomic, strong, readwrite) NSString *amount;
@property (nonatomic, strong, readwrite) NSString *currency;

@end

@implementation JPAmount

+ (instancetype)amount:(NSString *)amount currency:(NSString *)currency {
    JPAmount *jpAmount = [JPAmount new];
    jpAmount.amount = amount;
    jpAmount.currency = currency;
    return jpAmount;
}

@end
