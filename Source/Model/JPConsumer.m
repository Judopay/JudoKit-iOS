//
//  JPConsumer.m
//  JudoKitObjC
//
//  Created by Hamon Riazy on 19/02/2016.
//  Copyright © 2016 Judo Payments. All rights reserved.
//

#import "JPConsumer.h"

@implementation JPConsumer

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
	self = [super init];
	if (self) {
        self.consumerReference = dictionary[@"yourConsumerReference"];
        self.consumerToken = dictionary[@"consumerToken"];
	}
	return self;
}

@end
