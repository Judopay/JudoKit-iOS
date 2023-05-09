//
//  JPTransactionButton.m
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

#import "JPTransactionButton.h"
#import "JPTransactionViewModel.h"

@implementation JPTransactionButton

#pragma mark - View model configuration

- (void)configureWithViewModel:(JPTransactionButtonViewModel *)viewModel {
    if (viewModel.isLoading) {
        [self startLoading];
    } else if (self.isLoading) {
        [self stopLoading];
    }
    
    if (!self.isLoading) {
        [self setTitle:viewModel.title forState:UIControlStateNormal];
    }
    
    self.enabled = viewModel.isEnabled;
    self.hidden = viewModel.isHidden;
}

- (void)setEnabled:(BOOL)enabled {
    if (super.enabled == enabled) {
        return;
    }
    
    super.enabled = enabled;

    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.1 animations:^{
        weakSelf.alpha = (enabled) ? 1.0 : 0.5;
    }];
}

@end
