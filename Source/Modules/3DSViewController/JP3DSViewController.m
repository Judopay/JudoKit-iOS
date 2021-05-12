//
//  JP3DSViewController.m
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

#import "JP3DSViewController.h"
#import "Functions.h"
#import "JP3DSConfiguration.h"
#import "JP3DSecureAuthenticationResult.h"
#import "JPApiService.h"
#import "JPError+Additions.h"
#import "JPLoadingView.h"
#import "JPResponse.h"
#import "NSString+Additions.h"
#import "UIColor+Additions.h"
#import "UIView+Additions.h"

@interface JP3DSViewController () <UIScrollViewDelegate>
@property (nonatomic, strong) JP3DSConfiguration *configuration;
@property (nonatomic, strong) JPCompletionBlock completionBlock;
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) JPLoadingView *loadingView;
@end

NSString *const kTermURL = @"https://pay.judopay.com/Android/Parse3DS";

NSString *const kAppendViewportMetaScript =
    @"let jpViewportElement = document.querySelector('meta[name=viewport]');"
    @"if (jpViewportElement) {"
    @"    jpViewportElement.content = 'width=device-width';"
    @"} else {"
    @"   jpViewportElement = document.createElement('meta');"
    @"   jpViewportElement.name = 'viewport';"
    @"   jpViewportElement.content = 'width=device-width';"
    @"   document.getElementsByTagName('head')[0].appendChild(jpViewportElement);"
    @"};"
    @"const jpPaResField = document.getElementById('pnPaRESPanel');"
    @"if (jpPaResField) paResField.parentElement.removeChild(jpPaResField);"
    @"undefined;";

NSString *const kExtractResultScript =
    @"let jpResult = {MD: null, PaRes: null};"
    @"const jpPreElements = document.getElementsByTagName('pre');"
    @"if (jpPreElements.length > 0) {"
    @"   try {"
    @"       jpResult = JSON.parse(jpPreElements[0].innerText);"
    @"   } catch {}"
    @"}"
    @"jpResult;";

@implementation JP3DSViewController

#pragma mark - Initializers

- (instancetype)initWithConfiguration:(JP3DSConfiguration *)configuration
                           completion:(JPCompletionBlock)completion {
    if (self = [super init]) {
        self.configuration = configuration;
        self.completionBlock = completion;
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self start3DSecureTransaction];
}

#pragma mark - Setup methods

- (void)setupViews {
    [self.view addSubview:self.webView];
    [self.view addSubview:self.loadingView];

    [self.webView pinToView:self.view withPadding:0.0];
    [self.loadingView pinToView:self.view withPadding:0.0];
    [self setupNavigationItems];
}

- (void)setupNavigationItems {
    self.navigationItem.title = @"three_d_secure_check".localized;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"dismiss".localized
                                                                             style:UIBarButtonItemStyleDone
                                                                            target:self
                                                                            action:@selector(onDismissTap)];

    NSDictionary *titleTextAttributes = @{NSForegroundColorAttributeName : UIColor.whiteColor};
    self.navigationController.navigationBar.titleTextAttributes = titleTextAttributes;
    self.navigationItem.leftBarButtonItem.tintColor = UIColor.whiteColor;
    self.navigationController.navigationBar.backgroundColor = UIColor.jpBlackColor;
}

- (void)onDismissTap {
    [self dismissViewControllerAnimated:YES completion:nil];
    self.completionBlock(nil, JPError.judoUserDidCancelError);
}

#pragma mark - Public methods

- (void)start3DSecureTransaction {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:self.configuration.acsURL];
    request.HTTPMethod = @"POST";

    NSMutableArray<JPQueryStringPair *> *parameters = [NSMutableArray arrayWithArray:@[
        [[JPQueryStringPair alloc] initWithField:@"PaReq"
                                           value:self.configuration.paReqValue],
        [[JPQueryStringPair alloc] initWithField:@"TermUrl"
                                           value:kTermURL]
    ]];

    if (self.configuration.mdValue) {
        [parameters addObject:[[JPQueryStringPair alloc] initWithField:@"MD" value:self.configuration.mdValue]];
    }

    NSData *HTTPBody = [queryParameters(parameters) dataUsingEncoding:NSUTF8StringEncoding];

    NSString *contentLength = [NSString stringWithFormat:@"%li", (unsigned long)HTTPBody.length];
    [request setValue:contentLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];

    request.HTTPBody = HTTPBody;

    [self.webView loadRequest:request];
}

#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    if ([navigationAction.request.URL.absoluteString isEqual:kTermURL]) {
        [self.loadingView startLoading];
    }

    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    self.completionBlock(nil, (JPError *)error);
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    self.completionBlock(nil, (JPError *)error);
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [self.webView evaluateJavaScript:kAppendViewportMetaScript
                   completionHandler:^(id result, NSError *error) {
                       if (error) {
                           NSLog(@"Error executing the viewport adjustments script.");
                       }
                   }];

    if ([webView.URL.absoluteString isEqual:kTermURL]) {
        __weak typeof(self) weakSelf = self;
        [self.webView evaluateJavaScript:kExtractResultScript
                       completionHandler:^(NSDictionary *result, NSError *error) {
                           if (error) {
                               weakSelf.completionBlock(nil, (JPError *)error);
                               return;
                           }

                           [weakSelf handleResult:result];
                       }];
    }
}

#pragma marl - UIScrollViewDelegate

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    [scrollView setZoomScale:1.0 animated:NO];
}

#pragma mark - Helper methods

- (void)handleResult:(NSDictionary *)result {

    NSString *mdValue = result[@"MD"];
    if(mdValue == nil || [mdValue isKindOfClass:NSNull.class]) {
        if (self.configuration.mdValue) {
            mdValue = self.configuration.mdValue;
        }
    }
    
    JP3DSecureAuthenticationResult *authenticationResult = [[JP3DSecureAuthenticationResult alloc] initWithPaRes:result[@"PaRes"] andMd:mdValue];

    __weak typeof(self) weakSelf = self;

    [self.apiService invokeComplete3dSecureWithReceiptId:self.configuration.receiptId
                                    authenticationResult:authenticationResult
                                           andCompletion:^(JPResponse *response, JPError *error) {
                                               [weakSelf dismissViewControllerAnimated:YES
                                                                            completion:^{
                                                                                [weakSelf.loadingView stopLoading];
                                                                            }];
                                               weakSelf.completionBlock(response, error);
                                           }];
}

#pragma mark - Lazy properties

- (WKWebView *)webView {
    if (!_webView) {
        _webView = [[WKWebView alloc] initWithFrame:CGRectZero];
        _webView.translatesAutoresizingMaskIntoConstraints = NO;
        _webView.backgroundColor = UIColor.whiteColor;
        _webView.contentMode = UIViewContentModeScaleToFill;
        _webView.navigationDelegate = self;
        _webView.scrollView.delegate = self;
    }
    return _webView;
}

- (JPLoadingView *)loadingView {
    if (!_loadingView) {
        _loadingView = [[JPLoadingView alloc] initWithTitle:@"Processing..."];
        _loadingView.translatesAutoresizingMaskIntoConstraints = NO;
        _loadingView.backgroundColor = UIColor.whiteColor;
        [_loadingView stopLoading];
    }
    return _loadingView;
}

@end
