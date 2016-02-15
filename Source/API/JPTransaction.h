//
//  JPTransaction.h
//  JudoKitObjC
//
//  Created by ben.riazy on 12/02/2016.
//  Copyright © 2016 Judo Payments. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <PassKit/PassKit.h>

@class JPAmount;
@class JPReference;
@class JPCard;
@class JPPaymentToken;

@interface JPTransaction : NSObject

@property (nonatomic, strong) NSString *judoID;
@property (nonatomic, strong) JPReference *reference;
@property (nonatomic, strong) JPAmount *amount;

@property (nonatomic, strong) JPCard *card;
@property (nonatomic, strong) JPPaymentToken *paymentToken;

@property (nonatomic, assign) CLLocationCoordinate2D location;
@property (nonatomic, strong) NSDictionary *deviceSignal;

@property (nonatomic, strong) NSString *mobileNumber;
@property (nonatomic, strong) NSString *emailAddress;

@property (nonatomic, strong) PKPayment *pkPayment;

@end
