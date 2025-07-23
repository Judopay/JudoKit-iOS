//
//  JPComplete3DS2Request.h
//  JudoKit_iOS
//
//  Copyright (c) 2020 Alternative Payments Ltd

#import <Foundation/Foundation.h>

@interface JPComplete3DS2Request : NSObject

@property (nonatomic, strong, nullable) NSString *version;
@property (nonatomic, strong, nullable) NSString *cv2;
@property (nonatomic, strong, nullable) NSString *threeDSSDKChallengeStatus;

- (nonnull instancetype)initWithVersion:(nonnull NSString *)version
                          andSecureCode:(nonnull NSString *)code;

- (nonnull instancetype)initWithVersion:(nonnull NSString *)version
                             secureCode:(nonnull NSString *)code
           andThreeDSSDKChallengeStatus:(nullable NSString *)threeDSSDKChallengeStatus;
@end
