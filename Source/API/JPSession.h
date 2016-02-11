//
//  JPSession.h
//  JudoKitObjC
//
//  Created by ben.riazy on 11/02/2016.
//  Copyright © 2016 Judo Payments. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JPSession : UIViewController

@property (nonatomic, strong, readonly) NSString *endpoint;
@property (nonatomic, strong, readonly) NSString *authorizationHeader;

@property (nonatomic, assign) BOOL sandboxed;

@end
