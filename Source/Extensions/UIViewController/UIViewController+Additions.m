//
//  UIViewController+Additions.m
//  JudoKit_iOS
//
//  Copyright (c) 2019 Alternative Payments Ltd
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

#import "NSString+Additions.h"
#import "UIViewController+Additions.h"

@implementation UIViewController (Additions)

- (UIViewController *)parentController {
    UIViewController *parentController = UIApplication.sharedApplication.keyWindow.rootViewController;
    while (parentController.presentedViewController && parentController != parentController.presentedViewController) {
        parentController = parentController.presentedViewController;
    }
    return parentController;
}

- (void)connectButton:(UIButton *)button withSelector:(SEL)selector {
    [button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
}

- (void)addTapGestureForView:(UIView *)view withSelector:(SEL)selector {
    UIGestureRecognizer *tapGesture;
    tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:selector];
    [view addGestureRecognizer:tapGesture];
}

- (void)displayAlertWithError:(NSError *)error {
    [self displayAlertWithTitle:@"error".localized andError:error];
}

- (void)displayAlertWithTitle:(NSString *)title andError:(NSError *)error {
    [self displayAlertWithTitle:title andMessage:error.localizedDescription];
}

- (void)displayAlertWithTitle:(NSString *)title andMessage:(NSString *)message {
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:title
                                                                        message:message
                                                                 preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"ok".localized.uppercaseString
                                                       style:UIAlertActionStyleDefault
                                                     handler:nil];
    [controller addAction:okAction];
    [self.parentController presentViewController:controller animated:YES completion:nil];
}

- (void)triggerNotificationFeedbackWithType:(UINotificationFeedbackType)type {
    UINotificationFeedbackGenerator *feedbackGenerator = [UINotificationFeedbackGenerator new];
    [feedbackGenerator notificationOccurred:type];
}

- (void)registerKeyboardObservers {
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];

    [notificationCenter addObserver:self
                           selector:@selector(keyboardWillShow:)
                               name:UIKeyboardWillShowNotification
                             object:nil];

    [notificationCenter addObserver:self
                           selector:@selector(keyboardWillHide:)
                               name:UIKeyboardWillHideNotification
                             object:nil];
}

- (void)removeKeyboardObservers {
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter removeObserver:self];
}

- (void)keyboardWillShow:(NSNotification *)notification {
}

- (void)keyboardWillHide:(NSNotification *)notification {
}

- (CGFloat)topBarHeight {
    CGFloat statusBarHeight = UIApplication.sharedApplication.statusBarFrame.size.height;
    CGFloat navigationBarHeight = self.navigationController.navigationBar.frame.size.height;
    return statusBarHeight + navigationBarHeight;
}

@end
