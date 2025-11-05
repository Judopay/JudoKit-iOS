//  JPTransactionView.m
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

#import "JPCardInputView.h"
#import "JPActionBarDelegate.h"
#import "JPBillingInformationForm.h"
#import "JPCardDetailsForm.h"
#import "JPConstants.h"
#import "JPInputField.h"
#import "JPInputType.h"
#import "JPPresentationMode.h"
#import "JPRoundedCornerView.h"
#import "JPThemable.h"
#import "JPTheme.h"
#import "UIStackView+Additions.h"
#import "UIView+Additions.h"

typedef enum JPCardInputViewSectionType : NSUInteger {
    JPCardInputViewSectionTypeCardDetails,
    JPCardInputViewSectionTypeBillingInformation,
} JPCardInputViewSectionType;

@interface JPCardInputView () <JPActionBarDelegate, JPInputFieldDelegate>

@property (nonatomic, assign) JPCardInputViewSectionType sectionType;
@property (nonatomic, strong) JPTransactionViewModel *viewModel;

@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) JPRoundedCornerView *mainContainerView;
@property (nonatomic, strong) UIStackView *viewSwitcher;
@property (nonatomic, strong) JPBillingInformationForm *billingInformationForm;
@property (nonatomic, strong) JPCardDetailsForm *cardDetailsForm;

@property (nonatomic, strong) NSLayoutConstraint *mainContainerBottomConstraint;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

@end

@implementation JPCardInputView

#pragma mark - Constants

static const float kContentHorizontalPadding = 18.0F;
static const float kContentVerticalPadding = 20.0F;
static const float kSliderCornerRadius = 10.0F;
static const float kTightContentSpacing = 8.0F;
static const float kLooseContentSpacing = 16.0F;
static const NSInteger kPhoneCodeMaxLength = 4;

#pragma mark - Initializers

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
    self.backgroundView = [UIView new];
    self.backgroundView.backgroundColor = UIColor.clearColor;
    self.backgroundView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.backgroundView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onBackgroundViewTap)]];

    self.mainContainerView = [[JPRoundedCornerView alloc] initWithRadius:kSliderCornerRadius forCorners:UIRectCornerTopRight | UIRectCornerTopLeft];
    self.mainContainerView.translatesAutoresizingMaskIntoConstraints = NO;
    self.mainContainerView.backgroundColor = UIColor.whiteColor;

    self.cardDetailsForm = [[JPCardDetailsForm alloc] initWithFieldsSet:JPFormFieldsSetFullCardDetails];
    self.cardDetailsForm.inputFieldDelegate = self;
    self.cardDetailsForm.actionBarDelegate = self;

    self.billingInformationForm = [JPBillingInformationForm new];
    self.billingInformationForm.inputFieldDelegate = self;
    self.billingInformationForm.actionBarDelegate = self;

    self.viewSwitcher = [UIStackView _jp_verticalStackViewWithSpacing:kLooseContentSpacing
                                                  andArrangedSubviews:@[ self.cardDetailsForm, self.billingInformationForm ]];

    [self setSectionType:JPCardInputViewSectionTypeCardDetails];

    [self addSubview:self.backgroundView];
    [self addSubview:self.mainContainerView];

    [self.mainContainerView addSubview:self.viewSwitcher];

    [self.backgroundView _jp_pinToView:self withPadding:0.0];

    UILayoutGuide *guide = self.mainContainerView.layoutMarginsGuide;

    [NSLayoutConstraint activateConstraints:@[
        [self.viewSwitcher.leadingAnchor constraintEqualToAnchor:guide.leadingAnchor
                                                        constant:kContentHorizontalPadding],
        [self.viewSwitcher.trailingAnchor constraintEqualToAnchor:guide.trailingAnchor
                                                         constant:-kContentHorizontalPadding],
        [self.viewSwitcher.topAnchor constraintEqualToAnchor:guide.topAnchor
                                                    constant:kContentVerticalPadding],
        [self.viewSwitcher.bottomAnchor constraintEqualToAnchor:guide.bottomAnchor],
    ]];
    [self.mainContainerView _jp_pinToAnchors:JPAnchorTypeLeading | JPAnchorTypeTrailing forView:self];

    NSLayoutConstraint *mainContainerTopConstraint = [self.mainContainerView.topAnchor constraintGreaterThanOrEqualToAnchor:self.topAnchor constant:44];
    mainContainerTopConstraint.priority = UILayoutPriorityDefaultHigh;
    self.mainContainerBottomConstraint = [self.mainContainerView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor];

    [NSLayoutConstraint activateConstraints:@[ mainContainerTopConstraint, self.mainContainerBottomConstraint ]];

    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.activityIndicator.translatesAutoresizingMaskIntoConstraints = NO;

    [self addSubview:self.activityIndicator];
    [self.activityIndicator _jp_pinToView:self withPadding:0.0];
}

- (void)safeAreaInsetsDidChange {
    [super safeAreaInsetsDidChange];

    UIEdgeInsets insets = self.safeAreaInsets;
    self.viewSwitcher.layoutMargins = UIEdgeInsetsMake(insets.top, insets.left, insets.bottom, insets.right);
}

#pragma mark - Theming

- (void)applyTheme:(JPTheme *)theme {
    [self.cardDetailsForm applyTheme:theme];
    [self.billingInformationForm applyTheme:theme];
}

#pragma mark - View model configuration

- (void)configureWithViewModel:(JPTransactionViewModel *)viewModel {
    JPPresentationMode mode = self.viewModel.mode;
    self.viewModel = viewModel;

    BOOL noUserInputExpected = viewModel.mode == JPPresentationModeNone;
    self.mainContainerView.hidden = noUserInputExpected;

    if (viewModel.isLoading && noUserInputExpected) {
        [self.activityIndicator startAnimating];
    } else {
        [self.activityIndicator stopAnimating];
    }

    [self configureCardDetailsFormFieldsForMode:viewModel.mode];

    [self.billingInformationForm configureWithViewModel:viewModel.billingInformationViewModel];
    [self.cardDetailsForm configureWithViewModel:viewModel.cardDetailsViewModel];

    if (mode != viewModel.mode) {
        [self configureSectionTypeForMode:viewModel.mode];
    }
}

- (void)configureSectionTypeForMode:(JPPresentationMode)mode {
    BOOL billingInfoOnly = self.viewModel.mode == JPPresentationModeBillingInfo;
    self.sectionType = billingInfoOnly ? JPCardInputViewSectionTypeBillingInformation : JPCardInputViewSectionTypeCardDetails;
}

- (void)configureCardDetailsFormFieldsForMode:(JPPresentationMode)mode {
    JPFormFieldsSet fields;

    switch (mode) {
        case JPPresentationModeSecurityCode:
        case JPPresentationModeSecurityCodeAndBillingInfo:
            fields = JPFormFieldsSetCSC;
            break;

        case JPPresentationModeCardholderName:
        case JPPresentationModeCardholderNameAndBillingInfo:
            fields = JPFormFieldsSetCardHolderName;
            break;

        case JPPresentationModeSecurityCodeAndCardholderName:
        case JPPresentationModeSecurityCodeAndCardholderNameAndBillingInfo:
            fields = JPFormFieldsSetCardHolderNameAndCSC;
            break;

        case JPPresentationModeCardInfoAndAVS:
            fields = JPFormFieldsSetFullCardDetailsAndAVS;
            break;

        case JPPresentationModeCardInfo:
        case JPPresentationModeCardAndBillingInfo:
            fields = JPFormFieldsSetFullCardDetails;
            break;

        case JPPresentationModeNone:
        case JPPresentationModeBillingInfo:
        default:
            fields = JPFormFieldsSetEmpty;
            break;
    }

    self.cardDetailsForm.fieldsSet = fields;
}

- (void)setSectionType:(JPCardInputViewSectionType)sectionType {
    _sectionType = sectionType;

    self.cardDetailsForm.hidden = sectionType != JPCardInputViewSectionTypeCardDetails;
    self.billingInformationForm.hidden = sectionType != JPCardInputViewSectionTypeBillingInformation;
}

- (void)switchAnimatedToSection:(JPCardInputViewSectionType)sectionType {
    if (_sectionType == sectionType) {
        return;
    }

    [self endEditing:YES];

    [self.mainContainerBottomConstraint setConstant:self.mainContainerView.bounds.size.height];

    __weak typeof(self) weakSelf = self;

    [UIView animateWithDuration:0.3
        delay:0
        options:UIViewAnimationOptionCurveEaseIn
        animations:^{ [weakSelf layoutIfNeeded]; }
        completion:^(BOOL finished) {
            [weakSelf setSectionType:sectionType];
            [weakSelf.mainContainerBottomConstraint setConstant:0];

            [UIView animateWithDuration:0.3
                                  delay:0.0
                                options:UIViewAnimationOptionCurveEaseOut
                             animations:^{ [weakSelf layoutIfNeeded]; }
                             completion:nil];
        }];
}

#pragma mark - Helpers

- (void)onBackgroundViewTap {
    [self endEditing:YES];
}

#pragma mark - Pubic interface methods implementation

- (void)notifyKeyboardWillShow:(BOOL)willShow withNotification:(NSNotification *)notification {
    NSTimeInterval duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve curve = [notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];

    CGSize keyboardSize = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    self.mainContainerBottomConstraint.constant = willShow ? -keyboardSize.height : 0;

    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:duration == 0 ? 0.1 : duration
                          delay:0.0
                        options:(UIViewAnimationOptions)curve
                     animations:^{ [weakSelf layoutIfNeeded]; }
                     completion:nil];
}

- (void)moveFocusToInput:(JPInputType)type {
    if (self.sectionType == JPCardInputViewSectionTypeCardDetails) {
        [self.cardDetailsForm moveFocusToInput:type];
    }
}

#pragma mark - JPInputFieldDelegate

- (BOOL)inputField:(JPInputField *)inputField shouldChangeText:(NSString *)text {
    if (inputField.type == JPInputTypeBillingPhoneCode && text.length > kPhoneCodeMaxLength) {
        return NO;
    }

    [self.delegate cardInputView:self didChangeText:text forInputType:inputField.type andEndEditing:NO];
    return NO;
}

- (void)inputField:(JPInputField *)inputField didEndEditing:(NSString *)text {
    [self.delegate cardInputView:self didChangeText:text forInputType:inputField.type andEndEditing:YES];
}

//- (void)inputFieldDidBeginEditing:(JPInputField *)inputField {
//    UIScrollView *scrollView = self.scrollView;
//    CGRect visibleScrollRect = UIEdgeInsetsInsetRect(scrollView.bounds, scrollView.contentInset);
//    CGRect fieldFrame = inputField.frame;
//
//    if (!CGRectContainsRect(visibleScrollRect, fieldFrame)) {
//        [scrollView scrollRectToVisible:CGRectInset(fieldFrame, 0, 80) animated:YES];
//    }
//}

#pragma mark - JPActionBarDelegate

- (void)actionBar:(JPActionBar *)actionBar didPerformAction:(JPActionBarActionType)action {
    JPCardInputViewActionType type = JPCardInputViewActionTypeUnknown;

    // Sections navigation
    if (action == JPActionBarActionTypeSubmit && self.viewModel.shouldDisplayBillingInformationSection && actionBar == self.cardDetailsForm.bottomActionBar) {
        [self switchAnimatedToSection:JPCardInputViewSectionTypeBillingInformation];
        return;
    }

    if (action == JPActionBarActionTypeNavigateBack) {
        [self switchAnimatedToSection:JPCardInputViewSectionTypeCardDetails];
        return;
    }

    switch (action) {
        case JPActionBarActionTypeCancel:
            type = JPCardInputViewActionTypeCancel;
            break;

        case JPActionBarActionTypeScanCard:
            type = JPCardInputViewActionTypeScanCard;
            break;

        case JPActionBarActionTypeSubmit:
            type = JPCardInputViewActionTypeSubmit;
            break;

        default:
            break;
    }

    [self.delegate cardInputView:self didPerformAction:type];
}

@end
