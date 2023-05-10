//
//  JPPaymentMethodsViewController.m
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

#import "JPPaymentMethodsViewController.h"
#import "Functions.h"
#import "JPConfiguration.h"
#import "JPPaymentMethodsCardListHeaderCell.h"
#import "JPPaymentMethodsHeaderView.h"
#import "JPPaymentMethodsPresenter.h"
#import "JPPaymentMethodsSelectionCell.h"
#import "JPPaymentMethodsView.h"
#import "JPPaymentMethodsViewModel.h"
#import "JPSectionView.h"
#import "JPTheme.h"
#import "JPTransactionButton.h"
#import "JPUIConfiguration.h"
#import "NSString+Additions.h"
#import "UIImage+Additions.h"
#import "UIViewController+Additions.h"

@interface JPPaymentMethodsViewController () <JPPBBAButtonDelegate>

@property (nonatomic, strong) JPApplePayController *applePayController;
@property (nonatomic, strong) JPPaymentMethodsView *paymentMethodsView;
@property (nonatomic, strong) JPPaymentMethodsViewModel *viewModel;

@end

@implementation JPPaymentMethodsViewController

#pragma mark - View Lifecycle

- (void)loadView {
    self.paymentMethodsView = [JPPaymentMethodsView new];
    self.view = self.paymentMethodsView;
    [self configureView];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.presenter viewModelNeedsUpdate];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.presenter orderCards];
    [super viewWillDisappear:animated];
}

#pragma mark - User Actions

- (void)onBackButtonTap {
    [self.presenter handleBackButtonTap];
}

- (void)onPayButtonTap {
    [self.presenter handlePayButtonTap];
}

- (void)onApplePayButtonTap {
    [self.presenter handleApplePayButtonTap];
}

- (void)pbbaButtonDidPress:(nonnull JPPBBAButton *)sender {
    [self.presenter handlePayButtonTap];
}

#pragma mark - Layout Setup

- (void)configureView {
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                 forBarPosition:UIBarPositionAny
                                                     barMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;

    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.accessibilityIdentifier = @"Back Button";
    backButton.imageView.contentMode = UIViewContentModeScaleAspectFit;

    UIImage *defaultIcon = [UIImage _jp_imageWithIconName:@"back-icon"];
    UIImage *customImage = self.configuration.uiConfiguration.theme.backButtonImage;
    UIImage *backButtonImage = customImage ? customImage : defaultIcon;
    [backButton setImage:backButtonImage forState:UIControlStateNormal];

    [backButton addTarget:self action:@selector(onBackButtonTap) forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [backBarButton.customView.heightAnchor constraintEqualToConstant:22.0].active = YES;
    [backBarButton.customView.widthAnchor constraintEqualToConstant:22.0].active = YES;
    self.navigationItem.leftBarButtonItem = backBarButton;

    self.paymentMethodsView.tableView.delegate = self;
    self.paymentMethodsView.tableView.dataSource = self;
    self.paymentMethodsView.headerView.pbbaButton.delegate = self;
}

- (void)configureTargets {
    [self.paymentMethodsView.headerView.payButton addTarget:self
                                                     action:@selector(onPayButtonTap)
                                           forControlEvents:UIControlEventTouchUpInside];

    [self.paymentMethodsView.headerView.applePayButton addTarget:self
                                                          action:@selector(onApplePayButtonTap)
                                                forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - Protocol Conformance

- (void)configureWithViewModel:(JPPaymentMethodsViewModel *)viewModel
           shouldAnimateChange:(BOOL)shouldAnimate {
    self.viewModel = viewModel;

    [self.paymentMethodsView.headerView applyUIConfiguration:self.configuration.uiConfiguration];
    [self.paymentMethodsView.headerView configureWithViewModel:viewModel.headerModel];

    for (JPPaymentMethodsModel *item in viewModel.items) {
        [self.paymentMethodsView.tableView registerClass:NSClassFromString(item.identifier)
                                  forCellReuseIdentifier:item.identifier];
    }

    [self handlePaymentMethodChangeBehaviorForViewModel:viewModel
                                    shouldAnimateChange:shouldAnimate];
    [self configureTargets];
}

- (void)handlePaymentMethodChangeBehaviorForViewModel:(JPPaymentMethodsViewModel *)viewModel
                                  shouldAnimateChange:(BOOL)shouldAnimate {

    if (!shouldAnimate) {
        [self.paymentMethodsView.tableView reloadData];
        return;
    }

    [self.paymentMethodsView.tableView beginUpdates];

    // in case the method selection switcher is rendered, avoid updating it's cell.
    NSUInteger loc = [viewModel.items.firstObject isKindOfClass:JPPaymentMethodsSelectionModel.class] ? 1 : 0;

    NSRange oldRange = NSMakeRange(loc, self.paymentMethodsView.tableView.numberOfSections - loc);
    NSIndexSet *oldIndexSet = [NSIndexSet indexSetWithIndexesInRange:oldRange];

    NSRange newRange = NSMakeRange(loc, viewModel.items.count - loc);
    NSIndexSet *newIndexSet = [NSIndexSet indexSetWithIndexesInRange:newRange];

    UITableViewRowAnimation fadeAnimation = UITableViewRowAnimationFade;
    [self.paymentMethodsView.tableView deleteSections:oldIndexSet withRowAnimation:fadeAnimation];
    [self.paymentMethodsView.tableView insertSections:newIndexSet withRowAnimation:fadeAnimation];

    [self.paymentMethodsView.tableView endUpdates];
}

- (void)_jp_displayAlertWithTitle:(NSString *)title andError:(NSError *)error {
    [self.paymentMethodsView.headerView.payButton stopLoading];
    self.paymentMethodsView.userInteractionEnabled = YES;
    [self _jp_triggerNotificationFeedbackWithType:UINotificationFeedbackTypeError];
    [super _jp_displayAlertWithTitle:title andError:error];
}

- (void)presentApplePayWithAuthorizationBlock:(JPApplePayAuthorizationBlock)authorizationBlock
                               didFinishBlock:(JPApplePayDidFinishBlock)didFinishBlock {
    self.applePayController = [[JPApplePayController alloc] initWithConfiguration:self.configuration];
    UIViewController *controller = [self.applePayController applePayViewControllerWithAuthorizationBlock:authorizationBlock
                                                                                          didFinishBlock:didFinishBlock];
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf presentViewController:controller animated:YES completion:nil];
    });
}

- (void)setIsPaymentInProgress:(BOOL)isCardPaymentInProgress {
    if (isCardPaymentInProgress) {
        [self.paymentMethodsView.headerView.payButton startLoading];
        self.paymentMethodsView.userInteractionEnabled = NO;
    } else {
        [self.paymentMethodsView.headerView.payButton stopLoading];
        self.paymentMethodsView.userInteractionEnabled = YES;
    }
}

- (void)endEditingCardListIfNeeded {
    if (self.paymentMethodsView.tableView.isEditing) {
        [self.paymentMethodsView.tableView setEditing:NO animated:YES];
        [self.presenter changeHeaderButtonTitle:self.paymentMethodsView.tableView.isEditing];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat yValue = -scrollView.contentOffset.y;
    CGFloat height = MIN(MAX(yValue, 370 * getWidthAspectRatio()), 418 * getWidthAspectRatio());
    CGRect newFrame = CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, height);
    self.paymentMethodsView.headerView.frame = newFrame;
}

@end

#pragma mark - UITableViewDataSource

@implementation JPPaymentMethodsViewController (TableViewDataSource)

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.viewModel.items.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if ([self.viewModel.items[section] isKindOfClass:JPPaymentMethodsCardListModel.class]) {
        JPPaymentMethodsCardListModel *cardListModel;
        cardListModel = (JPPaymentMethodsCardListModel *)self.viewModel.items[section];
        return cardListModel.cardModels.count;
    }

    if ([self.viewModel.items[section] isKindOfClass:JPPaymentMethodsIDEALBankListModel.class]) {
        JPPaymentMethodsIDEALBankListModel *bankListModel;
        bankListModel = (JPPaymentMethodsIDEALBankListModel *)self.viewModel.items[section];
        return bankListModel.bankModels.count;
    }

    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    JPPaymentMethodsModel *model = self.viewModel.items[indexPath.section];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:model.identifier
                                                            forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    if ([cell conformsToProtocol:@protocol(JPThemable)]) {
        UITableViewCell<JPThemable> *themableCell;
        themableCell = (UITableViewCell<JPThemable> *)cell;

        [themableCell applyTheme:self.configuration.uiConfiguration.theme];
    }

    if ([cell conformsToProtocol:@protocol(JPPaymentMethodConfigurable)]) {
        UITableViewCell<JPPaymentMethodConfigurable> *paymentMethodCell;
        paymentMethodCell = (UITableViewCell<JPPaymentMethodConfigurable> *)cell;

        if ([model isKindOfClass:JPPaymentMethodsCardListModel.class]) {
            JPPaymentMethodsCardListModel *cardListModel;
            cardListModel = (JPPaymentMethodsCardListModel *)model;
            [paymentMethodCell configureWithViewModel:(JPPaymentMethodsModel *)cardListModel.cardModels[indexPath.row]];
            return cell;
        }

        if ([model isKindOfClass:JPPaymentMethodsIDEALBankListModel.class]) {
            JPPaymentMethodsIDEALBankListModel *bankListModel;
            bankListModel = (JPPaymentMethodsIDEALBankListModel *)model;
            [paymentMethodCell configureWithViewModel:(JPPaymentMethodsModel *)bankListModel.bankModels[indexPath.row]];
            return cell;
        }

        [paymentMethodCell configureWithViewModel:model];
    }

    if ([model isKindOfClass:JPPaymentMethodsCardHeaderModel.class]) {
        JPPaymentMethodsCardListHeaderCell *headerCell = (JPPaymentMethodsCardListHeaderCell *)cell;
        headerCell.delegate = self;
    }

    if ([model isKindOfClass:JPPaymentMethodsSelectionModel.class]) {
        JPPaymentMethodsSelectionCell *selectionCell = (JPPaymentMethodsSelectionCell *)cell;
        selectionCell.sectionView.delegate = self;
    }

    return cell;
}

@end

#pragma mark - UITableViewDelegate

@implementation JPPaymentMethodsViewController (TableViewDelegate)

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    JPPaymentMethodsModel *model = self.viewModel.items[indexPath.section];
    if ([model isKindOfClass:JPPaymentMethodsCardListModel.class]) {
        [self.presenter didSelectCardAtIndex:indexPath.row
                               isEditingMode:tableView.isEditing];
        [self.presenter changeHeaderButtonTitle:NO];
        [self.paymentMethodsView.tableView setEditing:NO animated:NO];
    }

    if ([model isKindOfClass:JPPaymentMethodsIDEALBankListModel.class]) {
        [self.presenter didSelectBankAtIndex:indexPath.row];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    JPPaymentMethodsModel *model = self.viewModel.items[indexPath.section];
    return [model isKindOfClass:JPPaymentMethodsCardListModel.class];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"delete_card_alert_title"._jp_localized
                                                                             message:@"delete_card_alert_message"._jp_localized
                                                                      preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"cancel"._jp_localized
                                                           style:UIAlertActionStyleDefault
                                                         handler:nil];

    __weak typeof(self) weakSelf = self;
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"delete"._jp_localized
                                                           style:UIAlertActionStyleDestructive
                                                         handler:^(UIAlertAction *_Nonnull action) {
                                                             [weakSelf.presenter deleteCardWithIndex:indexPath.row];
                                                         }];

    [alertController addAction:cancelAction];
    [alertController addAction:deleteAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end

@implementation JPPaymentMethodsViewController (EditCardsDelegate)

- (void)didTapActionButton {
    BOOL isEditing = self.paymentMethodsView.tableView.isEditing == YES;
    [CATransaction begin];

    __weak typeof(self) weakSelf = self;
    [CATransaction setCompletionBlock:^{
        [weakSelf.presenter changeHeaderButtonTitle:!isEditing];
    }];

    [self.paymentMethodsView.tableView setEditing:!isEditing animated:YES];
    [CATransaction commit];
}

@end

@implementation JPPaymentMethodsViewController (JPSectionViewDelegate)

- (void)sectionView:(JPSectionView *)sectionView didSelectSectionAtIndex:(NSUInteger)index {
    [self.presenter changePaymentMethodToIndex:index];
}

@end
