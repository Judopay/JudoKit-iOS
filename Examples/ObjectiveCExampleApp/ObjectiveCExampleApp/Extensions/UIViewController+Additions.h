#import <UIKit/UIKit.h>

@class JPResponse;

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (Additions)

- (void)presentResultViewControllerWithResponse:(JPResponse *)response;

- (void)presentTextFieldAlertControllerWithTitle:(NSString *)title
                                         message:(NSString *)message
                             positiveButtonTitle:(NSString *)positiveButton
                             negativeButtonTitle:(NSString *)negativeButton
                            textFieldPlaceholder:(NSString *)placeholder
                                   andCompletion:(void (^)(NSString *text))completion;

- (void)displayAlertWithError:(NSError *)error;

- (void)displayAlertWithTitle:(nullable NSString *)title
                   andMessage:(NSString *)message;

@end

NS_ASSUME_NONNULL_END
