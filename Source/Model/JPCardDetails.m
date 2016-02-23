//
//  JPCardDetails.m
//  JudoKitObjC
//
//  Created by Hamon Riazy on 19/02/2016.
//  Copyright © 2016 Judo Payments. All rights reserved.
//

#import "JPCardDetails.h"

@implementation JPCardDetails

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
	self = [super init];
	if (self) {
        self.cardLastFour = dictionary[@"cardLastfour"];
        self.endDate = dictionary[@"endDate"];
        self.cardToken = dictionary[@"cardToken"];
        self.cardNumber = dictionary[@"cardNumber"];
        self.cardNetwork = ((NSNumber *)dictionary[@"cardType"]).integerValue;
	}
	return self;
}

/*
 
 self.cardLastFour = dict?["cardLastfour"] as? String
 self.endDate = dict?["endDate"] as? String
 self.cardToken = dict?["cardToken"] as? String
 self.cardNumber = dict?["cardNumber"] as? String
 if let cardType = dict?["cardType"] as? Int {
 
 */

@end
