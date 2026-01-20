#import "Result.h"
#import "ResultTableViewController.h"
#import "UIViewController+Additions.h"

@import JudoKit_iOS;

@implementation UIViewController (Additions)

- (void)presentResultViewControllerWithResponse:(JPResponse *)response {
    Result *result = [Result resultFromObject:response];
    UIViewController *controller = [[ResultTableViewController alloc] initWithResult:result];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
    [self presentViewController:navController animated:YES completion:nil];
}

- (void)presentTextFieldAlertControllerWithTitle:(NSString *)title
                                         message:(NSString *)message
                             positiveButtonTitle:(NSString *)positiveButton
                             negativeButtonTitle:(NSString *)negativeButton
                            textFieldPlaceholder:(NSString *)placeholder
                                   andCompletion:(void (^)(NSString *text))completion {

    __block UITextField *textField = [UITextField new];
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:title
                                                                        message:message
                                                                 preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *buttonOk = [UIAlertAction actionWithTitle:positiveButton
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction *action) {
                                                         completion(textField.text);
                                                     }];

    UIAlertAction *buttonCancel = [UIAlertAction actionWithTitle:negativeButton
                                                           style:UIAlertActionStyleDestructive
                                                         handler:^(UIAlertAction *action) {
                                                             completion(nil);
                                                         }];

    [controller addTextFieldWithConfigurationHandler:^(UITextField *aTextField) {
        textField = aTextField;
        textField.placeholder = placeholder;
    }];

    [controller addAction:buttonCancel];
    [controller addAction:buttonOk];
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)displayAlertWithError:(NSError *)error {
    [self displayAlertWithTitle:@"Error" andError:error];
}

- (void)displayAlertWithTitle:(NSString *)title andError:(NSError *)error {
    NSMutableString *errorDetails = [NSMutableString string];
    
    [errorDetails appendFormat:@"Domain: %@\n", error.domain];
    [errorDetails appendFormat:@"Code: %ld\n", (long)error.code];
    
    if (error.localizedDescription) {
        [errorDetails appendFormat:@"\nDescription: %@\n", error.localizedDescription];
    }
    if (error.localizedFailureReason) {
        [errorDetails appendFormat:@"Failure Reason: %@\n", error.localizedFailureReason];
    }
    if (error.localizedRecoverySuggestion) {
        [errorDetails appendFormat:@"Recovery Suggestion: %@\n", error.localizedRecoverySuggestion];
    }
    
    if (error.userInfo.count > 0) {
        [errorDetails appendString:@"\nUser Info:\n"];
        for (NSString *key in error.userInfo.allKeys) {
            id value = error.userInfo[key];
            [errorDetails appendFormat:@"  %@: %@\n", key, value];
        }
    }
    
    [self displayAlertWithTitle:title andMessage:errorDetails];
}

- (void)displayAlertWithTitle:(NSString *)title andMessage:(NSString *)message {
     UIAlertController *controller = [UIAlertController alertControllerWithTitle:title
                                                                         message:message
                                                                  preferredStyle:UIAlertControllerStyleAlert];
     UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                        style:UIAlertActionStyleDefault
                                                      handler:nil];
     [controller addAction:okAction];
     [self.parentController presentViewController:controller animated:YES completion:nil];
}

- (UIViewController *)parentController {
    UIViewController *parentController = UIApplication.sharedApplication.keyWindow.rootViewController;
    while (parentController.presentedViewController && parentController != parentController.presentedViewController) {
        parentController = parentController.presentedViewController;
    }
    return parentController;
}

- (void)presentNetworkRequestsInspector {
    NSNotificationName name = @"wormholy_fire";
    [NSNotificationCenter.defaultCenter postNotificationName:name object:nil];
}

@end
