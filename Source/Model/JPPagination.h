//
//  JPPagination.h
//  JudoKitObjC
//
//  Created by ben.riazy on 12/02/2016.
//  Copyright © 2016 Judo Payments. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JPPagination : NSObject

@property (nonatomic, strong, readonly) NSString * __nonnull sort;
@property (nonatomic, assign, readonly) NSInteger pageSize;
@property (nonatomic, assign, readonly) NSInteger offset;

+ (__nonnull instancetype)paginationWithOffset:(NSNumber * _Nonnull)offset pageSize:(NSNumber * _Nonnull)pageSize sort:(NSString * _Nonnull)sort;

@end
