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

@end
