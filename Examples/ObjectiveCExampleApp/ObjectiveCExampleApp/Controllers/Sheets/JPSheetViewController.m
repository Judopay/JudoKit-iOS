//
//  JPSheetViewController.m
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

#import "JPSheetViewController.h"
#import "Result.h"
#import "ResultItem.h"

typedef NS_ENUM(NSUInteger, JPSheetStyle) {
    JPSheetStyleError,
    JPSheetStyleSuccess,
};

@interface JPSheetViewController ()
@property (nonatomic, assign) JPSheetStyle style;
@property (nonatomic, copy) NSString *sheetTitle;
@property (nonatomic, strong, nullable) NSError *error;
@property (nonatomic, strong, nullable) Result *result;
@end

@implementation JPSheetViewController

#pragma mark - Factory

+ (instancetype)controllerForError:(NSError *)error {
    JPSheetViewController *vc = [JPSheetViewController new];
    vc.style = JPSheetStyleError;
    vc.sheetTitle = @"JPError";
    vc.error = error;
    return vc;
}

+ (instancetype)controllerForResult:(Result *)result {
    JPSheetViewController *vc = [JPSheetViewController new];
    vc.style = JPSheetStyleSuccess;
    vc.sheetTitle = result.title;
    vc.result = result;
    return vc;
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.systemBackgroundColor;
    [self setupNavigationBar];
    [self setupScrollContent];
}

#pragma mark - Setup

- (void)setupNavigationBar {
    self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeNever;
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                   style:UIBarButtonItemStyleDone
                                                                  target:self
                                                                  action:@selector(onDismiss)];
    UIFont *semibold = [UIFont systemFontOfSize:17 weight:UIFontWeightSemibold];
    [doneButton setTitleTextAttributes:@{NSFontAttributeName: semibold} forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = doneButton;
}

- (void)onDismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setupScrollContent {
    UIScrollView *scrollView = [UIScrollView new];
    scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:scrollView];

    UIView *contentView = [UIView new];
    contentView.translatesAutoresizingMaskIntoConstraints = NO;
    [scrollView addSubview:contentView];

    [NSLayoutConstraint activateConstraints:@[
        [scrollView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
        [scrollView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [scrollView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [scrollView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
        [contentView.topAnchor constraintEqualToAnchor:scrollView.contentLayoutGuide.topAnchor],
        [contentView.leadingAnchor constraintEqualToAnchor:scrollView.contentLayoutGuide.leadingAnchor],
        [contentView.trailingAnchor constraintEqualToAnchor:scrollView.contentLayoutGuide.trailingAnchor],
        [contentView.bottomAnchor constraintEqualToAnchor:scrollView.contentLayoutGuide.bottomAnchor],
        [contentView.widthAnchor constraintEqualToAnchor:scrollView.frameLayoutGuide.widthAnchor],
    ]];

    UIStackView *mainStack = [UIStackView new];
    mainStack.axis = UILayoutConstraintAxisVertical;
    mainStack.spacing = 28;
    mainStack.alignment = UIStackViewAlignmentFill;
    mainStack.translatesAutoresizingMaskIntoConstraints = NO;
    [contentView addSubview:mainStack];

    [NSLayoutConstraint activateConstraints:@[
        [mainStack.topAnchor constraintEqualToAnchor:contentView.topAnchor constant:32],
        [mainStack.leadingAnchor constraintEqualToAnchor:contentView.leadingAnchor constant:24],
        [mainStack.trailingAnchor constraintEqualToAnchor:contentView.trailingAnchor constant:-24],
        [mainStack.bottomAnchor constraintEqualToAnchor:contentView.bottomAnchor constant:-24],
    ]];

    [mainStack addArrangedSubview:[self makeIconView]];
    [mainStack addArrangedSubview:[self makeTitleLabel]];

    UIView *content = (self.style == JPSheetStyleError) ? [self makeErrorContent] : [self makeResultContent];
    [mainStack addArrangedSubview:content];
}

#pragma mark - Icon

- (UIView *)makeIconView {
    UIColor *color = (self.style == JPSheetStyleError) ? UIColor.systemRedColor : UIColor.systemBlueColor;
    NSString *name = (self.style == JPSheetStyleError) ? @"exclamationmark.octagon.fill" : @"checkmark.circle.fill";

    UIView *container = [UIView new];

    UIView *circle = [UIView new];
    circle.translatesAutoresizingMaskIntoConstraints = NO;
    circle.backgroundColor = [color colorWithAlphaComponent:0.12];
    circle.layer.cornerRadius = 60;
    [container addSubview:circle];

    UIImageSymbolConfiguration *config = [UIImageSymbolConfiguration configurationWithPointSize:56];
    UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage systemImageNamed:name withConfiguration:config]];
    icon.tintColor = color;
    icon.translatesAutoresizingMaskIntoConstraints = NO;
    [container addSubview:icon];

    [NSLayoutConstraint activateConstraints:@[
        [circle.centerXAnchor constraintEqualToAnchor:container.centerXAnchor],
        [circle.topAnchor constraintEqualToAnchor:container.topAnchor],
        [circle.bottomAnchor constraintEqualToAnchor:container.bottomAnchor],
        [circle.widthAnchor constraintEqualToConstant:120],
        [circle.heightAnchor constraintEqualToConstant:120],
        [icon.centerXAnchor constraintEqualToAnchor:circle.centerXAnchor],
        [icon.centerYAnchor constraintEqualToAnchor:circle.centerYAnchor],
    ]];

    return container;
}

#pragma mark - Title

- (UILabel *)makeTitleLabel {
    UILabel *label = [UILabel new];
    label.text = self.sheetTitle;
    label.font = [UIFont systemFontOfSize:22 weight:UIFontWeightBold];
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    return label;
}

#pragma mark - Error content

- (UIView *)makeErrorContent {
    NSMutableString *msg = [NSMutableString string];
    [msg appendFormat:@"Domain: %@\nCode: %ld", self.error.domain, (long)self.error.code];
    if (self.error.localizedDescription) {
        [msg appendFormat:@"\n\nDescription: %@", self.error.localizedDescription];
    }
    if (self.error.localizedFailureReason) {
        [msg appendFormat:@"\nFailure Reason: %@", self.error.localizedFailureReason];
    }
    if (self.error.localizedRecoverySuggestion) {
        [msg appendFormat:@"\nRecovery Suggestion: %@", self.error.localizedRecoverySuggestion];
    }
    if (self.error.userInfo.count > 0) {
        [msg appendString:@"\n\nUser Info:"];
        for (NSString *key in self.error.userInfo.allKeys) {
            [msg appendFormat:@"\n  %@: %@", key, self.error.userInfo[key]];
        }
    }

    UIView *card = [UIView new];
    card.backgroundColor = UIColor.tertiarySystemFillColor;
    card.layer.cornerRadius = 12;

    UILabel *textLabel = [UILabel new];
    textLabel.text = msg;
    textLabel.font = [UIFont monospacedSystemFontOfSize:13 weight:UIFontWeightRegular];
    textLabel.numberOfLines = 0;
    textLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [card addSubview:textLabel];

    [NSLayoutConstraint activateConstraints:@[
        [textLabel.topAnchor constraintEqualToAnchor:card.topAnchor constant:16],
        [textLabel.leadingAnchor constraintEqualToAnchor:card.leadingAnchor constant:16],
        [textLabel.trailingAnchor constraintEqualToAnchor:card.trailingAnchor constant:-16],
        [textLabel.bottomAnchor constraintEqualToAnchor:card.bottomAnchor constant:-16],
    ]];

    return card;
}

#pragma mark - Result content

- (UIView *)makeResultContent {
    return [self makeContentViewForResult:self.result];
}

- (UIView *)makeContentViewForResult:(Result *)result {
    UIStackView *outerStack = [UIStackView new];
    outerStack.axis = UILayoutConstraintAxisVertical;
    outerStack.spacing = 16;
    outerStack.alignment = UIStackViewAlignmentFill;

    NSMutableArray<ResultItem *> *flatItems = [NSMutableArray new];
    NSMutableArray<ResultItem *> *nestedItems = [NSMutableArray new];

    for (ResultItem *item in result.items) {
        if (item.subResult != nil) {
            [nestedItems addObject:item];
        } else if (item.value.length > 0) {
            [flatItems addObject:item];
        }
    }

    if (flatItems.count > 0) {
        [outerStack addArrangedSubview:[self makeInfoCard:flatItems]];
    }

    for (ResultItem *item in nestedItems) {
        Result *sub = item.subResult;
        if (!sub) { continue; }

        UIStackView *section = [UIStackView new];
        section.axis = UILayoutConstraintAxisVertical;
        section.spacing = 8;
        section.alignment = UIStackViewAlignmentFill;

        UILabel *header = [UILabel new];
        header.attributedText = [self captionAttributedString:item.title.uppercaseString];
        [section addArrangedSubview:header];

        [section addArrangedSubview:[self makeContentViewForResult:sub]];

        [outerStack addArrangedSubview:section];
    }

    return outerStack;
}

#pragma mark - Info card

- (UIView *)makeInfoCard:(NSArray<ResultItem *> *)items {
    UIView *card = [UIView new];
    card.backgroundColor = UIColor.tertiarySystemFillColor;
    card.layer.cornerRadius = 12;
    card.clipsToBounds = YES;

    UIView *prevAnchor = nil;

    for (NSUInteger i = 0; i < items.count; i++) {
        if (i > 0) {
            UIView *sep = [UIView new];
            sep.backgroundColor = UIColor.separatorColor;
            sep.translatesAutoresizingMaskIntoConstraints = NO;
            [card addSubview:sep];
            [NSLayoutConstraint activateConstraints:@[
                [sep.topAnchor constraintEqualToAnchor:prevAnchor.bottomAnchor],
                [sep.leadingAnchor constraintEqualToAnchor:card.leadingAnchor constant:16],
                [sep.trailingAnchor constraintEqualToAnchor:card.trailingAnchor],
                [sep.heightAnchor constraintEqualToConstant:0.5],
            ]];
            prevAnchor = sep;
        }

        UIView *row = [self makeInfoRow:items[i]];
        row.translatesAutoresizingMaskIntoConstraints = NO;
        [card addSubview:row];

        NSLayoutAnchor *topAnchor = prevAnchor ? prevAnchor.bottomAnchor : card.topAnchor;
        [NSLayoutConstraint activateConstraints:@[
            [row.topAnchor constraintEqualToAnchor:topAnchor],
            [row.leadingAnchor constraintEqualToAnchor:card.leadingAnchor],
            [row.trailingAnchor constraintEqualToAnchor:card.trailingAnchor],
        ]];
        prevAnchor = row;
    }

    if (prevAnchor) {
        [prevAnchor.bottomAnchor constraintEqualToAnchor:card.bottomAnchor].active = YES;
    }

    return card;
}

#pragma mark - Info row

- (UIView *)makeInfoRow:(ResultItem *)item {
    UILabel *labelView = [UILabel new];
    labelView.attributedText = [self captionAttributedString:item.title.uppercaseString];
    labelView.translatesAutoresizingMaskIntoConstraints = NO;

    UILabel *valueView = [UILabel new];
    valueView.text = item.value;
    valueView.font = [UIFont monospacedSystemFontOfSize:17 weight:UIFontWeightRegular];
    valueView.numberOfLines = 0;
    valueView.translatesAutoresizingMaskIntoConstraints = NO;

    UIView *container = [UIView new];
    [container addSubview:labelView];
    [container addSubview:valueView];

    [NSLayoutConstraint activateConstraints:@[
        [labelView.topAnchor constraintEqualToAnchor:container.topAnchor constant:14],
        [labelView.leadingAnchor constraintEqualToAnchor:container.leadingAnchor constant:16],
        [labelView.trailingAnchor constraintEqualToAnchor:container.trailingAnchor constant:-16],
        [valueView.topAnchor constraintEqualToAnchor:labelView.bottomAnchor constant:4],
        [valueView.leadingAnchor constraintEqualToAnchor:container.leadingAnchor constant:16],
        [valueView.trailingAnchor constraintEqualToAnchor:container.trailingAnchor constant:-16],
        [valueView.bottomAnchor constraintEqualToAnchor:container.bottomAnchor constant:-14],
    ]];

    return container;
}

#pragma mark - Caption helper

- (NSAttributedString *)captionAttributedString:(NSString *)text {
    NSDictionary<NSAttributedStringKey, id> *attrs = @{
        NSFontAttributeName: [UIFont systemFontOfSize:12 weight:UIFontWeightSemibold],
        NSForegroundColorAttributeName: UIColor.secondaryLabelColor,
        NSKernAttributeName: @(0.5),
    };
    return [[NSAttributedString alloc] initWithString:text attributes:attrs];
}

@end
