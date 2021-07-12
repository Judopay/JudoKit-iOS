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

@end
