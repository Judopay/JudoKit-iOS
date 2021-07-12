#import <UIKit/UIKit.h>

@class JPResponse;

@interface UIViewController (Additions)
- (void)presentResultViewControllerWithResponse:(JPResponse *)response;
@end
