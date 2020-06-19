//
//  JPFloatingTextField.m
//  JudoKit_iOS
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

#import "JPFloatingTextField.h"
#import "JPTheme.h"
#import "UIFont+Additions.h"

@interface JPFloatingTextField ()
@property (nonatomic, strong) UILabel *floatingLabel;
@property (nonatomic, strong) NSLayoutConstraint *floatingLabelCenterYConstraint;
@property (nonatomic, assign) CGFloat defaultPointSize;
@property (nonatomic, assign) CGFloat expandedPointSize;
@property (nonatomic, assign) BOOL isExpanded;
@end

@implementation JPFloatingTextField

#pragma mark - Constants

static const float kAnimationDuration = 0.3f;
static const float kFontDecreaseValue = 2.0f;
static const float kErrorFrameOffset = -4.0f;
static const float kErrorTextOffset = 5.0f;
static const float kStandardFrameOffset = 3.0f;
static const float kErrorConstraintOffset = -15.0f;

#pragma mark - Initializers

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        [self setupViews];
        [self registerAppStateNotifications];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupViews];
        [self registerAppStateNotifications];
    }
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        [self setupViews];
        [self registerAppStateNotifications];
    }
    return self;
}

- (void)dealloc {
    [self unregisterAppStateNotifications];
}

#pragma mark - Theming

- (void)applyTheme:(JPTheme *)theme {
    self.floatingLabel.textColor = theme.jpRedColor;
    self.floatingLabel.font = theme.caption;
}

#pragma mark - Methods

- (void)displayFloatingLabelWithText:(NSString *)text {
    self.floatingLabel.text = text;
    [self transformToNewFontSize:self.expandedPointSize
                     frameOffset:self.isExpanded ? 0 : kErrorFrameOffset
                      alphaValue:1.0
           andConstraintConstant:kErrorConstraintOffset];
    self.isExpanded = YES;
}

- (void)hideFloatingLabel {
    [self transformToNewFontSize:self.defaultPointSize
                     frameOffset:kStandardFrameOffset
                      alphaValue:0.0
           andConstraintConstant:0.0];
    self.isExpanded = NO;
}

#pragma mark - View layout

- (void)setupViews {
    [self addSubview:self.floatingLabel];
    NSArray *constraints = @[
        [self.floatingLabel.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [self.floatingLabel.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        self.floatingLabelCenterYConstraint,
    ];

    [NSLayoutConstraint activateConstraints:constraints];
}

#pragma mark - Internal logic

- (void)transformToNewFontSize:(CGFloat)fontSize
                   frameOffset:(CGFloat)frameOffset
                    alphaValue:(CGFloat)alphaValue
         andConstraintConstant:(CGFloat)constant {

    if (fontSize == self.expandedPointSize && self.isExpanded) {
        self.font = [UIFont fontWithName:self.placeholderFont.familyName size:self.expandedPointSize];
        return;
    }

    if (fontSize == self.defaultPointSize && !self.isExpanded) {
        self.font = [UIFont fontWithName:self.placeholderFont.familyName size:self.defaultPointSize];
        return;
    }

    UIFont *oldFont = self.font;
    self.font = [UIFont fontWithName:self.placeholderFont.familyName size:fontSize];
    CGFloat scale = oldFont.pointSize / self.font.pointSize;

    [self layoutIfNeeded];

    CGPoint oldOrigin = self.frame.origin;

    CGAffineTransform oldTransform = self.transform;
    self.transform = CGAffineTransformScale(self.transform, scale, scale);

    CGPoint newOrigin = self.frame.origin;

    self.frame = CGRectMake(oldOrigin.x,
                            oldOrigin.y + frameOffset,
                            self.frame.size.width,
                            self.frame.size.height);

    self.floatingLabelCenterYConstraint.constant = constant;

    CGFloat yOffset = (scale > 1) ? kErrorTextOffset : -kErrorTextOffset;
    CGFloat yOrigin = newOrigin.y + yOffset;

    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:kAnimationDuration
                     animations:^{
                         weakSelf.frame = CGRectMake(newOrigin.x,
                                                     yOrigin,
                                                     self.frame.size.width,
                                                     self.frame.size.height);
                         weakSelf.transform = oldTransform;
                         weakSelf.floatingLabel.alpha = alphaValue;
                         [weakSelf layoutIfNeeded];
                     }];
}

#pragma mark - UIApplication notifications

- (void)registerAppStateNotifications {
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(resetFrameOriginIfNeeded)
                                               name:UIApplicationWillEnterForegroundNotification
                                             object:nil];
}

- (void)unregisterAppStateNotifications {
    [NSNotificationCenter.defaultCenter removeObserver:self
                                                  name:UIApplicationWillEnterForegroundNotification
                                                object:nil];
}

- (void)resetFrameOriginIfNeeded {
    if (self.floatingLabelCenterYConstraint.constant == kErrorConstraintOffset) {
        self.frame = CGRectMake(0, -kErrorFrameOffset + kStandardFrameOffset, self.frame.size.width, self.frame.size.height);
    }
}

#pragma mark - Lazy properties

- (UILabel *)floatingLabel {
    if (!_floatingLabel) {
        _floatingLabel = [UILabel new];
        _floatingLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _floatingLabel.alpha = 0.0f;
    }
    return _floatingLabel;
}

- (NSLayoutConstraint *)floatingLabelCenterYConstraint {
    if (!_floatingLabelCenterYConstraint) {
        _floatingLabelCenterYConstraint = [self.floatingLabel.centerYAnchor constraintEqualToAnchor:self.centerYAnchor];
    }
    return _floatingLabelCenterYConstraint;
}

- (CGFloat)defaultPointSize {
    if (!_defaultPointSize) {
        _defaultPointSize = self.placeholderFont.pointSize;
    }
    return _defaultPointSize;
}

- (CGFloat)expandedPointSize {
    if (!_expandedPointSize) {
        _expandedPointSize = self.defaultPointSize - kFontDecreaseValue;
    }
    return _expandedPointSize;
}

@end
