//
//  JPReference.h
//  JudoKitObjC
//
//  Created by ben.riazy on 12/02/2016.
//  Copyright © 2016 Judo Payments. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JPReference : NSObject

@property (nonatomic, strong, readonly) NSString *consumerReference;
@property (nonatomic, strong, readonly) NSString *paymentReference;
@property (nonatomic, strong) NSDictionary<NSString *, NSObject *> *metaData;

+ (instancetype)consumerReference:(NSString *)ref;

@end
