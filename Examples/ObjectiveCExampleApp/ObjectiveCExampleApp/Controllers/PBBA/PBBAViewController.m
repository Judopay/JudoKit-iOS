//
//  PBBAViewController.m
//  ObjectiveCExampleApp
//
//  Copyright (c) 2020 Alternative Payments Ltd
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

#import "PBBAViewController.h"
#import "DetailViewController.h"
#import "UIViewController+Additions.h"

@import JudoKit_iOS;

@interface PBBAViewController () <JPPBBAButtonDelegate>
@property (strong, nonatomic) IBOutlet UIView *buttonPlaceholder;
@end

@implementation PBBAViewController

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createButtonProgrammatically];
    [self checkForDeeplink];
}

#pragma mark - JPPBBAButtonDelegate

/**
 * Catch delegate call from JPPBBAButton
 *
 * @param sender - JPPBBAButton object, which triggers the click.
 */
- (void)pbbaButtonDidPress:(JPPBBAButton *)sender {
    __weak typeof(self) weakSelf = self;
    [weakSelf.judoKit invokePBBAWithConfiguration:weakSelf.configuration
                                              completion:^(JPResponse *response, JPError *error) {
        [weakSelf handleResponse:response error:error];
    }];
}

/**
 *  Method used for creating and adding JPPBBAButton Programmatically to view. Set up delegates
 */
- (void)createButtonProgrammatically {
    JPPBBAButton *pbbaFromCode = [[JPPBBAButton alloc] initWithFrame:self.buttonPlaceholder.bounds];
    pbbaFromCode.delegate = self;
    [self.buttonPlaceholder addSubview:pbbaFromCode];
}

#pragma mark - Handle Response

- (void)handleResponse:(JPResponse *)response error:(NSError *)error {
    if (error) {
        [self displayAlertWithError: error];
        return;
    }
    
    if (!response) {
        [self displayAlertWithError: [JPError judoRequestFailedError]];
        return;
    }
    
    JPTransactionData *transactionData = response.items.firstObject;
    [self presentDetailsViewControllerWithTransactionData:transactionData];
}

- (void)presentDetailsViewControllerWithTransactionData:(JPTransactionData *)transactionData {
    DetailViewController *viewController = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
    viewController.transactionData = transactionData;
    [self.navigationController pushViewController:viewController animated:YES];
}

-(void)checkForDeeplink {
    if ([self.configuration.pbbaConfiguration isDeeplinkURLExist]) {
        [self pollingPBBAMerchantApp];
    }
}

- (void)pollingPBBAMerchantApp {
    __weak typeof(self) weakSelf = self;
    [self.judoKit pollingOrderStatus:self.configuration completion:^(JPResponse *response, JPError *error) {
        [weakSelf handleResponse:response error:error];
    }];
}

@end
