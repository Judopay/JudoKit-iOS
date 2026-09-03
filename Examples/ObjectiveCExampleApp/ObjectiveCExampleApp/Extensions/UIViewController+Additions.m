#import "JPSheetViewController.h"
#import "Result.h"
#import "ResultTableViewController.h"
#import "UIViewController+Additions.h"

@import JudoKit_iOS;

@implementation UIViewController (Additions)

- (void)presentResultViewControllerWithResponse:(JPResponse *)response {
    Result *result = [Result resultFromObject:response];
    ResultTableViewController *resultsVC = [[ResultTableViewController alloc] initWithResult:result];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:resultsVC];
    [self presentAsSheet:navController];
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
    JPSheetViewController *sheetVC = [JPSheetViewController controllerForError:error];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:sheetVC];
    [self presentAsSheet:navController];
}

- (void)presentAsSheet:(UINavigationController *)navController {
    if (@available(iOS 15.0, *)) {
        UISheetPresentationController *sheet = navController.sheetPresentationController;
        sheet.detents = @[
            [UISheetPresentationControllerDetent mediumDetent],
            [UISheetPresentationControllerDetent largeDetent],
        ];
        sheet.prefersGrabberVisible = YES;
    }
    [self.parentController presentViewController:navController animated:YES completion:nil];
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
