//
//  ResultTableViewController.m
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

#import "ResultTableViewController.h"
#import "Result.h"
#import "ResultItem.h"
#import "ResultItemTableViewCell.h"

@interface ResultTableViewController ()

@property (nonatomic, strong) Result *result;

@end

@implementation ResultTableViewController

//------------------------------------------------------
// MARK: - Constants
//------------------------------------------------------

static NSString *const kTableViewCellReuseIdentifier = @"ResultItemTableViewCellIdentifier";
static CGFloat const kTableViewCellHeight = 64.F;

//------------------------------------------------------
// MARK: - Initializers
//------------------------------------------------------

- (instancetype)initWithResult:(nonnull Result *)result {
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        self.result = result;
    }
    return self;
}

//------------------------------------------------------
// MARK: - View lifecycle
//------------------------------------------------------

- (void)viewDidLoad {
    [super viewDidLoad];

    UINib *cellNib = [UINib nibWithNibName:@"ResultItemTableViewCell" bundle:NSBundle.mainBundle];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:kTableViewCellReuseIdentifier];

    self.title = self.result.title;
    self.view.accessibilityIdentifier = @"Receipt Screen";
}

//------------------------------------------------------
// MARK: - UITableView Data Source
//------------------------------------------------------

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Properties";
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    return @"Long tap the cell to copy the property value.";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.result.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ResultItemTableViewCell *cell = (ResultItemTableViewCell *)[tableView dequeueReusableCellWithIdentifier:kTableViewCellReuseIdentifier
                                                                                               forIndexPath:indexPath];
    ResultItem *item = self.result.items[indexPath.row];
    [cell configureWithResultItem:item];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kTableViewCellHeight;
}

- (BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath {
    ResultItem *item = self.result.items[indexPath.row];
    return ![item.value containsString:@"Contains"];
}

- (BOOL)tableView:(UITableView *)tableView canPerformAction:(nonnull SEL)action forRowAtIndexPath:(nonnull NSIndexPath *)indexPath withSender:(nullable id)sender {
    return action == @selector(copy:);
}

- (void)tableView:(UITableView *)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
    if (action == @selector(copy:)) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        UIPasteboard *pasteboard = UIPasteboard.generalPasteboard;
        pasteboard.string = cell.detailTextLabel.text;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    ResultItem *item = self.result.items[indexPath.row];
    if (item.subResult) {
        UIViewController *controller = [[ResultTableViewController alloc] initWithResult:item.subResult];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

@end
