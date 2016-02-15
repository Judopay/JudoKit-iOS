//
//  JPResponse.h
//  JudoKitObjC
//
//  Created by ben.riazy on 12/02/2016.
//  Copyright © 2016 Judo Payments. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JPPagination;

@interface JPResponse : NSObject

@property (nonatomic, strong) NSArray *items;

+ (instancetype)responseWithPagination:(JPPagination *)pagination;

@end
