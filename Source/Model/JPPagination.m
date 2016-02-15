//
//  JPPagination.m
//  JudoKitObjC
//
//  Created by ben.riazy on 12/02/2016.
//  Copyright © 2016 Judo Payments. All rights reserved.
//

#import "JPPagination.h"

@interface JPPagination ()

@property (nonatomic, strong, readwrite) NSString *sort;
@property (nonatomic, assign, readwrite) NSInteger pageSize;
@property (nonatomic, assign, readwrite) NSInteger offset;

@end

@implementation JPPagination

+ (instancetype)paginationWithOffset:(NSNumber *)offset pageSize:(NSNumber *)pageSize sort:(NSString *)sort {
    JPPagination *pagination = [JPPagination new];
    pagination.offset = offset.integerValue;
    pagination.pageSize = pageSize.integerValue;
    pagination.sort = sort;
    return pagination;
}

@end
