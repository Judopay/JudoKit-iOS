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

@import JudoKit_iOS;

@interface PBBAViewController ()
@property (strong, nonatomic) IBOutlet UIView *buttonPlaceholder;
@property (strong, nonatomic) IBOutlet JPPBBAButton *pbbaFromXib;
@property (nonatomic, strong) JPTransactionStatusView *transactionStatusView;
@end

@implementation PBBAViewController

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createButtonProgrammatically];
    self.title = @"";
    
    __weak typeof(self) weakSelf = self;
    self.pbbaFromXib.didPress = ^(void){
        [weakSelf.judoKitSession invokePBBAWithMode:weakSelf.configuration
                                           delegate:weakSelf
                                         completion:^(JPResponse *response, JPError *error) {
            [weakSelf handleResponse:response error:error];
        }];
    };
}

- (void)createButtonProgrammatically {
    JPPBBAButton *pbbaFromCode = [[JPPBBAButton alloc] initWithFrame:self.buttonPlaceholder.bounds];
    [self.buttonPlaceholder addSubview:pbbaFromCode];
    
    __weak typeof(self) weakSelf = self;
    pbbaFromCode.didPress = ^(void){
        [weakSelf.judoKitSession invokePBBAWithMode:weakSelf.configuration
                                           delegate:weakSelf
                                         completion:^(JPResponse *response, JPError *error) {
            [weakSelf handleResponse:response error:error];
        }];
    };
}

#pragma mark - JPStatusViewDelegate

-(void)showStatusViewWith:(JPTransactionStatus)status {
    [self hideStatusView];
    [self.view addSubview:self.transactionStatusView];
    [self.transactionStatusView pinToView:self.view withPadding:0.0];
    [self.transactionStatusView applyTheme:self.configuration.uiConfiguration.theme];
    [self.transactionStatusView changeToTransactionStatus:status];
}

-(void)hideStatusView {
    [self.transactionStatusView removeFromSuperview];
}

#pragma mark - lazy init transactionStatusView

- (JPTransactionStatusView *)transactionStatusView {
    if (!_transactionStatusView) {
        _transactionStatusView = [JPTransactionStatusView new];
        _transactionStatusView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _transactionStatusView;
}


- (void)handleResponse:(JPResponse *)response error:(NSError *)error {
    if (error) {
        [self presentErrorWithMessage: error.localizedDescription];
        return;
    }
    
    if (!response) {
        return;
    }
    
    JPTransactionData *transactionData = response.items.firstObject;
    
    __weak typeof(self) weakSelf = self;
    [self dismissViewControllerAnimated:YES completion:^{
        [weakSelf presentDetailsViewControllerWithTransactionData:transactionData];
    }];
}

- (void)presentDetailsViewControllerWithTransactionData:(JPTransactionData *)transactionData {
    DetailViewController *viewController = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
    viewController.transactionData = transactionData;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)presentErrorWithMessage:(NSString *)message {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error"
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK"
                                                        style:UIAlertActionStyleCancel
                                                      handler:nil]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
