//
//  MainViewController+Additions.m
//  ObjectiveCExampleApp
//

@import JudoKit_iOS;

#import "MainViewController+Additions.h"
#import "CreatePaymentSessionRequest.h"
#import "Settings.h"
#import <InAppSettingsKit/IASKSpecifier.h>

@implementation MainViewController (Additions)

- (void)settingsViewControllerDidEnd:(IASKAppSettingsViewController *)settingsViewController {
    // noop
}

- (void)settingsViewController:(IASKAppSettingsViewController*)settingsViewController
      buttonTappedForSpecifier:(IASKSpecifier*)specifier {
    if ([specifier.key isEqualToString:kGeneratePaymentSessionKey]) {
        [self createPaymentSession];
    }
}

- (void)createPaymentSession {
    NSString *judoId = Settings.defaultSettings.judoId;
    NSString *amount = Settings.defaultSettings.amount.amount;
    NSString *currency = Settings.defaultSettings.amount.currency;
   
    JPReference *reference = Settings.defaultSettings.reference;
    NSString *paymentReference = reference.paymentReference;
    NSString *consumerReference = reference.consumerReference;

    // In case the call to `Settings.defaultSettings.reference`
    // ended up in generating a new pair of references
    // store these to be used for the next flow step
    if (!Settings.defaultSettings.hasPaymentReferenceSetUp) {
        [NSUserDefaults.standardUserDefaults setValue:paymentReference forKey:kPaymentReferenceKey];
    }

    if (!Settings.defaultSettings.hasConsumerReferenceSetUp) {
        [NSUserDefaults.standardUserDefaults setValue:consumerReference forKey:kConsumerReferenceKey];
    }
    
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
    [request setValue:@"6.20.0" forHTTPHeaderField:@"Api-Version"];
    [request setValue:@"no-cache" forHTTPHeaderField:@"Cache-Control"];
    NSString *token = Settings.defaultSettings.token;
    NSString *secret = Settings.defaultSettings.secret;
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

    NSURLSession *session = [NSURLSession sessionWithConfiguration:NSURLSessionConfiguration.defaultSessionConfiguration];

    __weak typeof(self) weakSelf = self;

    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf onCreatePaymentSessionCompleteWithData:data andError:error];
        });
    }];
    
    [task resume];
}

- (void)onCreatePaymentSessionCompleteWithData:(NSData *)data andError:(NSError *)error {
    if (error) {
        [self displaySnackBarWith:[NSString stringWithFormat:@"Error: %@.", error]];
        return;
    }
    
    NSError *jsonError = nil;
    NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
    
    if (jsonError) {
        [self displaySnackBarWith:[NSString stringWithFormat:@"JSON deserialization error: %@.", jsonError]];
        return;
    }
    
    [Settings.defaultSettings updateAuthorizationWithPaymentSession:[responseDict objectForKey:@"reference"]
                                                           andToken:Settings.defaultSettings.token];
    [self displaySnackBarWith:@"Success generating payment session, settings updated, navigating back to main screen."];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(NSEC_PER_SEC)), dispatch_get_main_queue(), ^(void) {
        [self.navigationController popViewControllerAnimated:YES];
    });
}

@end
