//
//  JPConsumer.h
//  JudoKitObjC
//
//  Created by Hamon Riazy on 19/02/2016.
//  Copyright © 2016 Judo Payments. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JPConsumer : NSObject

@property (nonatomic, strong) NSString * _Nonnull consumerToken;
@property (nonatomic, strong) NSString * _Nonnull consumerReference;

- (nonnull instancetype)initWithDictionary:(nonnull NSDictionary *)dictionary;

@end
