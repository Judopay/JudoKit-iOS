//
//  NSError+Judo.h
//  JudoKitObjC
//
//  Created by ben.riazy on 12/02/2016.
//  Copyright © 2016 Judo Payments. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSError (Judo)

+ (NSError *)judoRequestFailedError;
+ (NSError *)judoJSONSerializationError;

+ (NSError *)judoErrorFromErrorCode:(NSInteger)code;
+ (NSError *)judo3DSRequestWithPayload:(NSDictionary *)payload;

@end
