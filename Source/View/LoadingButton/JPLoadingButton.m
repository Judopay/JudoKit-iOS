//
//  JPLoadingButton.m
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

#import "JPLoadingButton.h"
#import "UIView+Additions.h"

@interface JPLoadingButton ()
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) NSString *buttonTitle;
@end

@implementation JPLoadingButton

#pragma mark - Initializers

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        [self setupActivityIndicator];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupActivityIndicator];
    }
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        [self setupActivityIndicator];
    }
    return self;
}

#pragma mark - Setup methods

- (void)setupActivityIndicator {
    [self addSubview:self.activityIndicator];
    [self.activityIndicator _jp_pinToView:self withPadding:0.0];
}

#pragma mark - Public methods

- (BOOL)isLoading {
    return self.activityIndicator.isAnimating;
}

- (void)startLoading {
    self.buttonTitle = self.titleLabel.text;
    [self setTitle:@"" forState:UIControlStateNormal];
    [self.activityIndicator startAnimating];
}

- (void)stopLoading {
    [self setTitle:self.buttonTitle forState:UIControlStateNormal];
    [self.activityIndicator stopAnimating];
}

#pragma mark - Lazy properties

- (UIActivityIndicatorView *)activityIndicator {
    if (!_activityIndicator) {
        _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        _activityIndicator.translatesAutoresizingMaskIntoConstraints = NO;
        _activityIndicator.hidesWhenStopped = YES;
    }
    return _activityIndicator;
}

@end
