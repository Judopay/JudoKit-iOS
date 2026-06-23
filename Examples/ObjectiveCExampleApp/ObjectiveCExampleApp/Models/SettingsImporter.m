//
//  SettingsImporter.m
//  ObjectiveCExampleApp
//
//  Copyright (c) 2026 Alternative Payments Ltd
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

#import "SettingsImporter.h"
#import "Settings.h"

@implementation SettingsImporter

+ (BOOL)importSettings:(NSString *)json
            intoDefaults:(NSUserDefaults *)defaults
                   error:(NSError **)error {
    NSData *data = [json dataUsingEncoding:NSUTF8StringEncoding];
    if (!data) {
        if (error) {
            *error = [NSError errorWithDomain:@"SettingsImporter"
                                         code:1
                                     userInfo:@{ NSLocalizedDescriptionKey: @"The provided text is not valid UTF-8." }];
        }
        return NO;
    }

    NSError *parseError = nil;
    id object = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
    if (parseError) {
        if (error) {
            *error = parseError;
        }
        return NO;
    }

    if (![object isKindOfClass:NSDictionary.class]) {
        if (error) {
            *error = [NSError errorWithDomain:@"SettingsImporter"
                                         code:2
                                     userInfo:@{ NSLocalizedDescriptionKey: @"Expected a JSON object at the root." }];
        }
        return NO;
    }

    NSDictionary *root = (NSDictionary *)object;
    [root enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL *stop) {
        if ([value isKindOfClass:NSDictionary.class]) {
            [(NSDictionary *)value enumerateKeysAndObjectsUsingBlock:^(id childKey, id childValue, BOOL *innerStop) {
                [self applyLeaf:childValue forKey:childKey intoDefaults:defaults];
            }];
        } else {
            [self applyLeaf:value forKey:key intoDefaults:defaults];
        }
    }];

    return YES;
}

+ (NSDictionary<NSString *, NSString *> *)cardNetworkKeysByValue {
    return @{
        @"VISA": kVisaEnabledKey,
        @"MASTERCARD": kMasterCardEnabledKey,
        @"MAESTRO": kMaestroEnabledKey,
        @"AMEX": kAMEXEnabledKey,
        @"CHINA_UNION_PAY": kChinaUnionPayEnabledKey,
        @"JCB": kJCBEnabledKey,
        @"DISCOVER": kDiscoverEnabledKey,
        @"DINERS_CLUB": kDinersClubEnabledKey
    };
}

+ (NSDictionary<NSString *, NSString *> *)challengeRequestIndicatorImportValues {
    return @{
        @"DON_T_SET": @"dontSet",
        @"NO_PREFERENCE": @"noPreference",
        @"NO_CHALLENGE": @"noChallenge",
        @"CHALLENGE_PREFERRED": @"challengePreferred",
        @"CHALLENGE_AS_MANDATE": @"challengeAsMandate"
    };
}

+ (NSDictionary<NSString *, NSString *> *)scaExemptionImportValues {
    return @{
        @"DON_T_SET": @"dontSet",
        @"LOW_VALUE": @"lowValue",
        @"SECURE_CORPORATE": @"secureCorporate",
        @"TRUSTED_BENEFICIARY": @"trustedBeneficiary",
        @"TRANSACTION_RISK_ANALYSIS": @"transactionRiskAnalysis"
    };
}

+ (NSString *)storedValueForKey:(NSString *)key value:(NSString *)value {
    if ([key isEqualToString:kChallengeRequestIndicatorKey]) {
        return [self challengeRequestIndicatorImportValues][value] ?: value;
    }
    if ([key isEqualToString:kScaExemptionKey]) {
        return [self scaExemptionImportValues][value] ?: value;
    }
    return value;
}

+ (void)applyLeaf:(id)value forKey:(NSString *)rawKey intoDefaults:(NSUserDefaults *)defaults {
    if ([rawKey isEqualToString:@"is_payment_session_enabled"]) {
        if (value == (id)kCFBooleanTrue || value == (id)kCFBooleanFalse) {
            BOOL isOn = [value boolValue];
            [defaults setBool:isOn forKey:kIsPaymentSessionOnKey];
            [defaults setBool:!isOn forKey:kIsTokenAndSecretOnKey];
        }
        return;
    }

    if ([rawKey isEqualToString:@"supported_networks"] && [value isKindOfClass:NSArray.class]) {
        [self applyCardNetworks:value intoDefaults:defaults];
        return;
    }

    if ([rawKey isEqualToString:@"payment_methods"] && [value isKindOfClass:NSArray.class]) {
        [self applyPaymentMethods:value intoDefaults:defaults];
        return;
    }

    if ([value isKindOfClass:NSArray.class]) {
        NSMutableArray<NSString *> *strings = [NSMutableArray new];
        for (id element in (NSArray *)value) {
            [strings addObject:[NSString stringWithFormat:@"%@", element]];
        }
        [defaults setObject:strings forKey:rawKey];
    } else if (value == (id)kCFBooleanTrue || value == (id)kCFBooleanFalse) {
        [defaults setBool:[value boolValue] forKey:rawKey];
    } else if ([value isKindOfClass:NSNumber.class]) {
        [defaults setObject:[(NSNumber *)value stringValue] forKey:rawKey];
    } else if ([value isKindOfClass:NSString.class]) {
        NSString *storedValue = [self storedValueForKey:rawKey value:(NSString *)value];
        [defaults setObject:storedValue forKey:rawKey];
    }
}

+ (void)applyCardNetworks:(NSArray *)values intoDefaults:(NSUserDefaults *)defaults {
    NSMutableSet<NSString *> *selected = [NSMutableSet new];
    for (id element in values) {
        [selected addObject:[[NSString stringWithFormat:@"%@", element] uppercaseString]];
    }
    [[self cardNetworkKeysByValue] enumerateKeysAndObjectsUsingBlock:^(NSString *value, NSString *key, BOOL *stop) {
        [defaults setBool:[selected containsObject:value] forKey:key];
    }];
}

+ (void)applyPaymentMethods:(NSArray *)values intoDefaults:(NSUserDefaults *)defaults {
    NSMutableSet<NSString *> *selected = [NSMutableSet new];
    for (id element in values) {
        [selected addObject:[[NSString stringWithFormat:@"%@", element] uppercaseString]];
    }
    [defaults setBool:[selected containsObject:@"CARD"] forKey:kCardPaymentMethodEnabledKey];
    [defaults setBool:([selected containsObject:@"APPLE_PAY"] || [selected containsObject:@"GOOGLE_PAY"])
               forKey:kApplePayPaymentMethodEnabledKey];
}

@end

@interface ImportSettingsViewController () <UITextViewDelegate, UIDocumentPickerDelegate>
@property (nonatomic, strong) UIView *cardView;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UILabel *placeholderLabel;
@property (nonatomic, strong) NSLayoutConstraint *cardCenterYConstraint;
@end

@implementation ImportSettingsViewController

//------------------------------------------------------
// MARK: - Constants
//------------------------------------------------------

static NSString *const kTitle = @"Import Settings from JSON";
static NSString *const kPlaceholder = @"Paste JSON here…";
static CGFloat const kHorizontalMargin = 24.0;
static CGFloat const kContentInset = 16.0;
static CGFloat const kCardWidth = 320.0;
static CGFloat const kTextViewHeight = 150.0;
static CGFloat const kFontSize = 14.0;
static CGFloat const kCornerRadius = 12.0;

//------------------------------------------------------
// MARK: - View lifecycle
//------------------------------------------------------

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.4];

    [self setupCard];
    [self registerForKeyboardNotifications];

    UITapGestureRecognizer *backgroundTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                    action:@selector(didTapBackground:)];
    backgroundTap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:backgroundTap];
}

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

- (void)didTapBackground:(UITapGestureRecognizer *)recognizer {
    CGPoint location = [recognizer locationInView:self.view];
    if (!CGRectContainsPoint(self.cardView.frame, location)) {
        [self.view endEditing:YES];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)didTapCancel {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didTapImport {
    NSString *json = self.textView.text;
    if ([json stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceAndNewlineCharacterSet].length == 0) {
        [self showAlertWithTitle:kTitle message:@"Please enter the settings JSON or choose a file."];
        return;
    }
    [self applyJson:json];
}

- (void)didTapChooseFile {
    UIDocumentPickerViewController *picker = [[UIDocumentPickerViewController alloc] initWithDocumentTypes:@[ @"public.json", @"public.text" ]
                                                                                                   inMode:UIDocumentPickerModeImport];
    picker.delegate = self;
    picker.allowsMultipleSelection = NO;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)applyJson:(NSString *)json {
    NSError *error = nil;
    BOOL success = [SettingsImporter importSettings:json
                                       intoDefaults:NSUserDefaults.standardUserDefaults
                                              error:&error];

    if (success) {
        if (self.onImported) {
            self.onImported();
        }
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:kTitle
                                                                      message:@"Settings imported successfully."
                                                               preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK"
                                                  style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction *action) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }]];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        NSString *reason = error.localizedDescription ?: @"Unknown error";
        [self showAlertWithTitle:kTitle
                         message:[NSString stringWithFormat:@"Failed to import settings: %@", reason]];
    }
}

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                  message:message
                                                           preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)registerForKeyboardNotifications {
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(keyboardWillChange:)
                                               name:UIKeyboardWillChangeFrameNotification
                                             object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(keyboardWillHide)
                                               name:UIKeyboardWillHideNotification
                                             object:nil];
}

- (void)keyboardWillChange:(NSNotification *)notification {
    CGRect frame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat overlap = CGRectGetHeight(self.view.bounds) - frame.origin.y;
    self.cardCenterYConstraint.constant = overlap > 0 ? -overlap / 2 : 0;
    [UIView animateWithDuration:0.25 animations:^{ [self.view layoutIfNeeded]; }];
}

- (void)keyboardWillHide {
    self.cardCenterYConstraint.constant = 0;
    [UIView animateWithDuration:0.25 animations:^{ [self.view layoutIfNeeded]; }];
}

- (void)setupCard {
    self.cardView = [UIView new];
    self.cardView.translatesAutoresizingMaskIntoConstraints = NO;
    self.cardView.backgroundColor = UIColor.systemBackgroundColor;
    self.cardView.layer.cornerRadius = kCornerRadius;
    [self.view addSubview:self.cardView];

    UILabel *titleLabel = [UILabel new];
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    titleLabel.text = kTitle;
    titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    titleLabel.numberOfLines = 0;
    [self.cardView addSubview:titleLabel];

    self.textView = [UITextView new];
    self.textView.translatesAutoresizingMaskIntoConstraints = NO;
    self.textView.font = [UIFont monospacedSystemFontOfSize:kFontSize weight:UIFontWeightRegular];
    self.textView.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.textView.autocorrectionType = UITextAutocorrectionTypeNo;
    self.textView.smartQuotesType = UITextSmartQuotesTypeNo;
    self.textView.smartDashesType = UITextSmartDashesTypeNo;
    self.textView.delegate = self;
    self.textView.layer.borderColor = UIColor.separatorColor.CGColor;
    self.textView.layer.borderWidth = 1;
    self.textView.layer.cornerRadius = kCornerRadius / 1.5;
    self.textView.accessibilityIdentifier = @"Import settings text view";
    [self.cardView addSubview:self.textView];

    self.placeholderLabel = [UILabel new];
    self.placeholderLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.placeholderLabel.text = kPlaceholder;
    self.placeholderLabel.font = [UIFont monospacedSystemFontOfSize:kFontSize weight:UIFontWeightRegular];
    self.placeholderLabel.textColor = UIColor.placeholderTextColor;
    self.placeholderLabel.numberOfLines = 0;
    [self.textView addSubview:self.placeholderLabel];

    UIButton *chooseFileButton = [self makeButtonWithTitle:@"Choose File" action:@selector(didTapChooseFile)];
    UIButton *cancelButton = [self makeButtonWithTitle:@"Cancel" action:@selector(didTapCancel)];
    UIButton *importButton = [self makeButtonWithTitle:@"Import" action:@selector(didTapImport)];
    importButton.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];

    UIView *spacer = [UIView new];
    [spacer setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];

    UIStackView *buttonStack = [[UIStackView alloc] initWithArrangedSubviews:@[ chooseFileButton, spacer, cancelButton, importButton ]];
    buttonStack.translatesAutoresizingMaskIntoConstraints = NO;
    buttonStack.axis = UILayoutConstraintAxisHorizontal;
    buttonStack.alignment = UIStackViewAlignmentCenter;
    buttonStack.spacing = kContentInset;
    [self.cardView addSubview:buttonStack];

    self.cardCenterYConstraint = [self.cardView.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor];

    NSLayoutConstraint *width = [self.cardView.widthAnchor constraintEqualToConstant:kCardWidth];
    width.priority = UILayoutPriorityDefaultHigh;

    [NSLayoutConstraint activateConstraints:@[
        [self.cardView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        self.cardCenterYConstraint,
        width,
        [self.cardView.leadingAnchor constraintGreaterThanOrEqualToAnchor:self.view.leadingAnchor constant:kHorizontalMargin],
        [self.cardView.trailingAnchor constraintLessThanOrEqualToAnchor:self.view.trailingAnchor constant:-kHorizontalMargin],

        [titleLabel.topAnchor constraintEqualToAnchor:self.cardView.topAnchor constant:kContentInset],
        [titleLabel.leadingAnchor constraintEqualToAnchor:self.cardView.leadingAnchor constant:kContentInset],
        [titleLabel.trailingAnchor constraintEqualToAnchor:self.cardView.trailingAnchor constant:-kContentInset],

        [self.textView.topAnchor constraintEqualToAnchor:titleLabel.bottomAnchor constant:kContentInset],
        [self.textView.leadingAnchor constraintEqualToAnchor:self.cardView.leadingAnchor constant:kContentInset],
        [self.textView.trailingAnchor constraintEqualToAnchor:self.cardView.trailingAnchor constant:-kContentInset],
        [self.textView.heightAnchor constraintEqualToConstant:kTextViewHeight],

        [self.placeholderLabel.topAnchor constraintEqualToAnchor:self.textView.topAnchor constant:kContentInset / 2.0],
        [self.placeholderLabel.leadingAnchor constraintEqualToAnchor:self.textView.leadingAnchor constant:kContentInset / 3.0],
        [self.placeholderLabel.trailingAnchor constraintEqualToAnchor:self.textView.trailingAnchor constant:-kContentInset / 3.0],

        [buttonStack.topAnchor constraintEqualToAnchor:self.textView.bottomAnchor constant:kContentInset],
        [buttonStack.leadingAnchor constraintEqualToAnchor:self.cardView.leadingAnchor constant:kContentInset],
        [buttonStack.trailingAnchor constraintEqualToAnchor:self.cardView.trailingAnchor constant:-kContentInset],
        [buttonStack.bottomAnchor constraintEqualToAnchor:self.cardView.bottomAnchor constant:-kContentInset]
    ]];
}

- (UIButton *)makeButtonWithTitle:(NSString *)title action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [button setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    return button;
}

- (void)textViewDidChange:(UITextView *)textView {
    self.placeholderLabel.hidden = textView.text.length > 0;
}

- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentsAtURLs:(NSArray<NSURL *> *)urls {
    NSURL *url = urls.firstObject;
    if (!url) {
        return;
    }

    BOOL shouldStopAccessing = [url startAccessingSecurityScopedResource];

    NSError *readError = nil;
    NSString *json = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&readError];

    if (shouldStopAccessing) {
        [url stopAccessingSecurityScopedResource];
    }

    if (readError || json.length == 0) {
        NSString *reason = readError.localizedDescription ?: @"The file is empty.";
        [self showAlertWithTitle:kTitle
                         message:[NSString stringWithFormat:@"Failed to read file: %@", reason]];
        return;
    }

    self.textView.text = json;
    self.placeholderLabel.hidden = json.length > 0;
    [self applyJson:json];
}

@end
