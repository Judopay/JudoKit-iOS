//
//  JPConsumer.h
//  JudoKitObjC
//
//  Created by Hamon Riazy on 19/02/2016.
//  Copyright © 2016 Judo Payments. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JPConsumer : NSObject

@property (nonatomic, strong) NSString * __nonnull consumerToken;
@property (nonatomic, strong) NSString * __nonnull consumerReference;

@end
