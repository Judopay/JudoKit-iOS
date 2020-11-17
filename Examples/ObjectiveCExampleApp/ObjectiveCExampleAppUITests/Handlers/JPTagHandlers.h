//
//  JPTagHandlers.h
//  ObjectiveCExampleAppUITests
//
//  Created by Mihai Petrenco on 17.11.2020.
//  Copyright © 2020 Judopay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JPTagHandlers : NSObject

+ (void)handleRequireNon3DSConfig;
+ (void)handleRequireAllCardNetworks;
+ (void)handleRequireAVS;
+ (void)handleRequireButtonAmount;

@end
