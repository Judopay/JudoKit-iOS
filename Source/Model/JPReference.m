//
//  JPReference.m
//  JudoKitObjC
//
//  Created by ben.riazy on 12/02/2016.
//  Copyright © 2016 Judo Payments. All rights reserved.
//

#import "JPReference.h"

@interface JPReference ()

@property (nonatomic, strong, readwrite) NSString *consumerReference;
@property (nonatomic, strong, readwrite) NSString *paymentReference;

@end

@implementation JPReference

+ (instancetype)consumerReference:(NSString *)ref {
    JPReference *reference = [JPReference new];
    return reference;
}

@end
