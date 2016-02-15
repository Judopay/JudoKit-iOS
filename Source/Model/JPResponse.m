//
//  JPResponse.m
//  JudoKitObjC
//
//  Created by ben.riazy on 12/02/2016.
//  Copyright © 2016 Judo Payments. All rights reserved.
//

#import "JPResponse.h"

@implementation JPResponse

+ (instancetype)responseWithPagination:(JPPagination *)pagination {
    return [[JPResponse alloc] init];
}

@end
