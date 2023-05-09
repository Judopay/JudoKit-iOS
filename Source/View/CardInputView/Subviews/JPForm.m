//
//  JPForm.m
//  JudoKit_iOS
//
//  Copyright (c) 2023 Alternative Payments Ltd
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

#import "JPForm.h"
#import "JPActionBar.h"
#import "JPIntrinsicSizeAwareScrollView.h"
#import "UIStackView+Additions.h"
#import "UIView+Additions.h"

@interface JPForm ()
@property (nonatomic, strong) UIScrollView *inputFieldsScrollView;
@end

@implementation JPForm

#pragma mark - Constants

static const float kLooseContentSpacing = 16.0F;
static const float kTightContentSpacing = 8.0F;

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    self.spacing = kLooseContentSpacing;
    self.axis = UILayoutConstraintAxisVertical;
    self.distribution = UIStackViewDistributionFill;
    self.alignment = UIStackViewAlignmentFill;

    self.topActionBar = [JPActionBar new];
    self.bottomActionBar = [JPActionBar new];
    
    self.inputFieldsScrollView = [JPIntrinsicSizeAwareScrollView new];
    self.inputFieldsScrollView.showsVerticalScrollIndicator = NO;
    self.inputFieldsScrollView.translatesAutoresizingMaskIntoConstraints = NO;

    self.inputFieldsStackView = [UIStackView _jp_verticalStackViewWithSpacing:kTightContentSpacing];

    [self _jp_addArrangedSubviews:@[self.topActionBar, self.inputFieldsScrollView, self.bottomActionBar]];
    
    [self.inputFieldsScrollView addSubview:self.inputFieldsStackView];
    [self.inputFieldsStackView _jp_pinToView:self.inputFieldsScrollView withPadding:0];

    [NSLayoutConstraint activateConstraints:@[
        [self.inputFieldsStackView.widthAnchor constraintEqualToAnchor:self.inputFieldsScrollView.widthAnchor],
    ]];
}

- (void)applyTheme:(JPTheme *)theme {
    [self.topActionBar applyTheme:theme];
    [self.bottomActionBar applyTheme:theme];
}

- (void)setActionBarDelegate:(id<JPActionBarDelegate>)delegate {
    self.topActionBar.delegate = delegate;
    self.bottomActionBar.delegate = delegate;
}

- (void)setInputFieldDelegate:(id<JPInputFieldDelegate>)delegate {
    _inputFieldDelegate = delegate;
}

@end
