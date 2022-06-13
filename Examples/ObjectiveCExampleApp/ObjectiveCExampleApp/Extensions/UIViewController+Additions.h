#import <UIKit/UIKit.h>

@class JPResponse;

@interface UIViewController (Additions)

- (void)presentResultViewControllerWithResponse:(JPResponse *)response;

- (void)presentTextFieldAlertControllerWithTitle:(NSString *)title
                                         message:(NSString *)message
                             positiveButtonTitle:(NSString *)positiveButton
                             negativeButtonTitle:(NSString *)negativeButton
                            textFieldPlaceholder:(NSString *)placeholder
                                   andCompletion:(void (^)(NSString *text))completion;
@end
