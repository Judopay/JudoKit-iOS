//
//  JPThreeDSViewController.m
//  JudoKitObjC
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

#import "JPThreeDSViewController.h"
#import "UIView+Additions.h"

@interface JPThreeDSViewController ()
@property (nonatomic, strong) NSString *paReq;
@property (nonatomic, strong) NSString *md;
@property (nonatomic, strong) NSURL *acsURL;
@property (nonatomic, strong) NSString *receiptId;
@property (nonatomic, strong) JudoCompletionBlock completionBlock;
@property (nonatomic, strong) WKWebView *webView;
@end

@implementation JPThreeDSViewController

- (instancetype)initWithPaReq:(NSString *)paReq
                           md:(NSString *)md
                    receiptId:(NSString *)receiptId
                       acsURL:(NSURL *)acsURL
                   completion:(JudoCompletionBlock)completion {
    if (self = [super init]) {
        self.paReq = paReq;
        self.md = md;
        self.receiptId = receiptId;
        self.acsURL = acsURL;
        self.completionBlock = completion;
    }
    return self;
}

//------------------------------------------------
#pragma mark - Initializers
//------------------------------------------------

- (void)viewDidLoad {
    [self setupViews];
    [self start3DSecureTransaction];
}

//------------------------------------------------
#pragma mark - Setup methods
//------------------------------------------------

- (void)setupViews {
    [self.view addSubview:self.webView];
    [self.webView pinToView:self.view withPadding:0.0];
}

- (void)start3DSecureTransaction {

    NSCharacterSet *charSet = [NSCharacterSet characterSetWithCharactersInString:@":/=,!$&'()*+;[]@#?"].invertedSet;
    NSString *paReqStringEscaped = [self.paReq stringByAddingPercentEncodingWithAllowedCharacters:charSet];
    NSString *termUrlString = [@"https://pay.judopay.com/iOS/Parse3DS" stringByAddingPercentEncodingWithAllowedCharacters:charSet];

    if (self.acsURL && self.md && self.paReq && paReqStringEscaped && termUrlString) {
        NSData *postData = [[NSString stringWithFormat:@"MD=%@&PaReq=%@&TermUrl=%@", self.md, paReqStringEscaped, termUrlString] dataUsingEncoding:NSUTF8StringEncoding];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:self.acsURL];
        request.HTTPMethod = @"POST";
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setValue:[NSString stringWithFormat:@"%li", (unsigned long)postData.length] forHTTPHeaderField:@"Content-Length"];
        request.HTTPBody = postData;
        [self.webView loadRequest:request];
    }
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {

    NSString *urlString = navigationAction.request.URL.absoluteString;

    if ([urlString rangeOfString:@"Parse3DS"].location == NSNotFound) {
        decisionHandler(WKNavigationActionPolicyAllow);
        return;
    }

    [self handleRedirectForWebView:webView redirectURL:urlString decisionHandler:decisionHandler];
    return;
}

- (void)handleRedirectForWebView:(WKWebView *)webView
                     redirectURL:(NSString *)redirectURL
                 decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSMutableString *javascriptCode = [NSMutableString new];
        [javascriptCode appendString:@"const paRes = document.getElementsByName('PaRes')[0].value;"];
        [javascriptCode appendString:@"const md = document.getElementsByName('MD')[0].value;"];
        [javascriptCode appendString:@"[paRes, md]"];
        [webView evaluateJavaScript:javascriptCode
                  completionHandler:^(NSArray *response, NSError *error) {
                      NSDictionary *responseDictionary = [self mapToDictionaryWithResponse:response];
                      [self handleACSFormWithResponse:responseDictionary decisionHandler:decisionHandler];
                  }];
    });
}

- (NSDictionary *)mapToDictionaryWithResponse:(NSArray *)response {

    if (response.count != 2)
        return nil;

    return @{
        @"PaRes" : response[0],
        @"MD" : [response[1] stringByReplacingOccurrencesOfString:@" " withString:@"+"]
    };
}

- (void)handleACSFormWithResponse:(NSDictionary *)response
                  decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {

    [self.transaction threeDSecureWithParameters:response
                                       receiptId:self.receiptId
                                      completion:^(JPResponse *response, NSError *error) {
                                          if (error) {
                                              decisionHandler(WKNavigationActionPolicyCancel);
                                          } else {
                                              decisionHandler(WKNavigationActionPolicyAllow);
                                              [self dismissViewControllerAnimated:YES completion:nil];
                                          }
                                          self.completionBlock(response, error);
                                      }];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    self.completionBlock(nil, error);
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    self.completionBlock(nil, error);
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSMutableString *scriptContent = [NSMutableString stringWithString:@"const meta = document.createElement('meta');"];
    [scriptContent appendString:@"meta.name='viewport';"];
    [scriptContent appendString:@"meta.content='width=device-width';"];
    [scriptContent appendString:@"const head = document.getElementsByTagName('head')[0];"];
    [scriptContent appendString:@"head.appendChild(meta);"];
    [scriptContent appendString:@"meta.name"];

    [self.webView evaluateJavaScript:scriptContent
                   completionHandler:^(id response, NSError *error) {
                       dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                           NSString *metaSizingContent = @"meta.content = 'width=' + document.documentElement.scrollWidth + ', maximum-scale=1.0'";
                           [self->_webView evaluateJavaScript:metaSizingContent completionHandler:nil];
                       });
                   }];

    NSMutableString *removePaResFieldScript = [NSMutableString stringWithString:@"const paResField = document.getElementById('pnPaRESPanel');"];
    [removePaResFieldScript appendString:@"paResField.parentElement.removeChild(paResField);"];
    [removePaResFieldScript appendString:@"paResField.name"];

    [self.webView evaluateJavaScript:removePaResFieldScript completionHandler:nil];
}

- (WKWebView *)webView {
    if (!_webView) {
        _webView = [[WKWebView alloc] initWithFrame:CGRectZero];
        _webView.translatesAutoresizingMaskIntoConstraints = NO;
        _webView.backgroundColor = UIColor.whiteColor;
        _webView.navigationDelegate = self;
    }
    return _webView;
}

@end
