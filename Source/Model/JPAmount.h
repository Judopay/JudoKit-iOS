//
//  JPAmount.h
//  JudoKitObjC
//
//  Created by ben.riazy on 12/02/2016.
//  Copyright © 2016 Judo Payments. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JPAmount : NSObject

@property (nonatomic, strong, readonly) NSString *amount;
@property (nonatomic, strong, readonly) NSString *currency;

+ (instancetype)amount:(NSString *)amount currency:(NSString *)currency;

@end
