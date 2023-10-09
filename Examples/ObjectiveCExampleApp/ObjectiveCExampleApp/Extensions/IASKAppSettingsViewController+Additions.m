#import "IASKAppSettingsViewController+Additions.h"
#import "Settings.h"
#import "CreatePaymentSessionRequest.h"
#import "JPAuthorization.h"
#import "JPConstants.h"

@implementation IASKAppSettingsViewController (Additions)

- (void)updateHiddenKeys {
    NSSet *hiddenKeys = [self computeHiddenKeysWithPriority:@[
        kIsPaymentSessionOnKey,
        kIsTokenAndSecretOnKey,
        kIsRecommendationOnKey,
        kIsAddressOnKey,
        kIsPrimaryAccountDetailsOnKey
    ]];
    [self setHiddenKeys:hiddenKeys];
}

- (void)didChangedSettingsWithKeys:(NSArray<NSString *> *)keys {

    NSSet *hiddenKeys;

    if ([keys containsObject:kIsPaymentSessionOnKey]) {
        hiddenKeys = [self computeHiddenKeysWithPriority:@[ kIsPaymentSessionOnKey, kIsAddressOnKey, kIsPrimaryAccountDetailsOnKey ]];
    } else if ([keys containsObject:kIsTokenAndSecretOnKey]) {
        hiddenKeys = [self computeHiddenKeysWithPriority:@[ kIsTokenAndSecretOnKey, kIsAddressOnKey, kIsPrimaryAccountDetailsOnKey ]];
    } else if ([keys containsObject:kIsAddressOnKey] || [keys containsObject:kIsPrimaryAccountDetailsOnKey] || [keys containsObject:kIsRecommendationOnKey]) {
        hiddenKeys = [self computeHiddenKeysWithPriority:@[ kIsPaymentSessionOnKey, kIsTokenAndSecretOnKey, kIsRecommendationOnKey, kIsAddressOnKey, kIsPrimaryAccountDetailsOnKey ]];
    }

    if (hiddenKeys.count > 0) {
        [self setHiddenKeys:hiddenKeys animated:YES];
    }
    
    if([keys containsObject:kGeneratePaymentSessionKey]) {
        [self createPaymentSession];
    }
}

- (void)createPaymentSession {
    NSString *judoId = Settings.defaultSettings.judoId;
    NSString *amount = Settings.defaultSettings.amount.amount;
    NSString *currency = Settings.defaultSettings.amount.currency;
//    NSString *paymentReference = [[NSUUID UUID] UUIDString];
    NSString *paymentReference = @"6f950c1f-ff32-460e-b45f-8d0fceee6396";
    [NSUserDefaults.standardUserDefaults setValue:paymentReference forKey:kPaymentReferenceKey];
    NSString *consumerReference = @"my-unique-ref";
    [NSUserDefaults.standardUserDefaults setValue:consumerReference forKey:kConsumerReferenceKey];
    NSString *baseUrlString;
    if (Settings.defaultSettings.isSandboxed) {
        baseUrlString = kJudoSandboxBaseURL;
    } else {
        baseUrlString = kJudoBaseURL;
    }
    NSString *urlString = [NSString stringWithFormat:@"%@/%@", baseUrlString, @"webpayments/payments"];
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"JudoKit-iOS Objective C Examples" forHTTPHeaderField:@"User-Agent"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
    [request setValue:@"6.19.0" forHTTPHeaderField:@"Api-Version"];
    [request setValue:@"no-cache" forHTTPHeaderField:@"Cache-Control"];
    NSString * token = Settings.defaultSettings.token;
    NSString * secret = Settings.defaultSettings.secret;
    NSString *combinedCredentials = [NSString stringWithFormat:@"%@:%@", token, secret];
    NSString *authorization = [NSString stringWithFormat:@"Basic %@", [[combinedCredentials dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithOptions:0]];
    [request setValue:authorization forHTTPHeaderField:@"Authorization"];
    CreatePaymentSessionRequest *paymentRequest = [[CreatePaymentSessionRequest alloc] initWithJudoId:judoId
                                                                                               amount:amount
                                                                                             currency:currency
                                                                                yourConsumerReference:consumerReference
                                                                                 yourPaymentReference:paymentReference];
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:[paymentRequest dictionaryRepresentation] options:kNilOptions error:nil];
    [request setHTTPBody:requestData];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            NSLog(@"Generate Payment Session: Error: %@", error);
        } else {
            NSError *jsonError = nil;
            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
            if (jsonError) {
                NSLog(@"Generate Payment Session: JSON Error: %@", jsonError);
            } else {
                NSLog(@"Generate Payment Session: API Response: %@", responseDict);
                NSString *paymentSessionReference = [responseDict objectForKey:@"reference"];
                [NSUserDefaults.standardUserDefaults setValue:paymentSessionReference forKey:kPaymentSessionKey];
            }
        }
    }];
    [task resume];
}


- (NSSet *)computeHiddenKeysWithPriority:(NSArray *)keys {
    NSMutableArray *hiddenKeys = [NSMutableArray arrayWithArray:@[
        kTokenKey,
        kSecretKey,

        kSessionTokenKey,
        kPaymentSessionKey,
        kGeneratePaymentSessionKey,
        
        kRsaKey,
        kRecommendationUrlKey,
        kRecommendationApiTimeoutKey,
        
        kAddressLine1Key,
        kAddressLine2Key,
        kAddressLine3Key,
        kAddressTownKey,
        kAddressPostCodeKey,
        kAddressCountryCodeKey,
        kAddressStateKey,
        kAddressPhoneCountryCodeKey,
        kAddressMobileNumberKey,
        kAddressEmailAddressKey,

        kPrimaryAccountNameKey,
        kPrimaryAccountAccountNumberKey,
        kPrimaryAccountDateOfBirthKey,
        kPrimaryAccountPostCodeKey
    ]];

    if ([keys containsObject:kIsPaymentSessionOnKey] && Settings.defaultSettings.isPaymentSessionAuthorizationOn) {
        [hiddenKeys removeObjectsInArray:@[ kSessionTokenKey, kPaymentSessionKey, kGeneratePaymentSessionKey]];
        [NSUserDefaults.standardUserDefaults setBool:NO forKey:kIsTokenAndSecretOnKey];
    }

    if ([keys containsObject:kIsTokenAndSecretOnKey] && Settings.defaultSettings.isTokenAndSecretAuthorizationOn) {
        [hiddenKeys removeObjectsInArray:@[ kTokenKey, kSecretKey ]];
        [NSUserDefaults.standardUserDefaults setBool:NO forKey:kIsPaymentSessionOnKey];
    }
    
    if ([keys containsObject:kIsRecommendationOnKey] && Settings.defaultSettings.isRecommendationFeatureOn) {
        [hiddenKeys removeObjectsInArray:@[
            kRsaKey,
            kRecommendationUrlKey,
            kRecommendationApiTimeoutKey
        ]];
    }

    if ([keys containsObject:kIsAddressOnKey] && Settings.defaultSettings.isAddressOn) {
        [hiddenKeys removeObjectsInArray:@[
            kAddressLine1Key,
            kAddressLine2Key,
            kAddressLine3Key,
            kAddressTownKey,
            kAddressPostCodeKey,
            kAddressCountryCodeKey,
            kAddressStateKey,
            kAddressPhoneCountryCodeKey,
            kAddressMobileNumberKey,
            kAddressEmailAddressKey,
        ]];
    }

    if ([keys containsObject:kIsPrimaryAccountDetailsOnKey] && Settings.defaultSettings.isPrimaryAccountDetailsOn) {
        [hiddenKeys removeObjectsInArray:@[
            kPrimaryAccountNameKey,
            kPrimaryAccountAccountNumberKey,
            kPrimaryAccountDateOfBirthKey,
            kPrimaryAccountPostCodeKey
        ]];
    }

    return [NSSet setWithArray:hiddenKeys];
}

@end
