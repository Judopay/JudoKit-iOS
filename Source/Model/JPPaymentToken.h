//
//  JPPaymentToken.h
//  JudoKitObjC
//
//  Created by ben.riazy on 15/02/2016.
//  Copyright © 2016 Judo Payments. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JPPaymentToken : NSObject

@property (nonatomic, strong) NSString *consumerToken;
@property (nonatomic, strong) NSString *cardToken;
@property (nonatomic, strong) NSString *secureCode;

@end
