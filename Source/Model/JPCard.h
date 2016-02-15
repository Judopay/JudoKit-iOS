//
//  JPCard.h
//  JudoKitObjC
//
//  Created by ben.riazy on 12/02/2016.
//  Copyright © 2016 Judo Payments. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JPCard : NSObject

@property (nonatomic, strong) NSString *cardNumber;
@property (nonatomic, strong) NSString *expiryDate;
@property (nonatomic, strong) NSString *secureCode;

@property (nonatomic, strong) NSString *startDate;
@property (nonatomic, strong) NSString *issueNumber;

@property (nonatomic, strong) NSDictionary *cardAddress;

@end
