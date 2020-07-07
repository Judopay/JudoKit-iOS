//
//  JP3DSService.m
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

#import "JP3DSService.h"
#import "JP3DSConfiguration.h"
#import "JP3DSViewController.h"
#import "JPApiService.h"
#import "UIApplication+Additions.h"

@interface JP3DSService ()
@property (strong, nonatomic) JPApiService *apiService;
@end

@implementation JP3DSService

- (nonnull instancetype)initWithApiService:(nonnull JPApiService *)apiService {
    if (self = [super init]) {
        _apiService = apiService;
    }
    return self;
}

- (void)invoke3DSecureWithConfiguration:(JP3DSConfiguration *)configuration completion:(JPCompletionBlock)completion {

    JP3DSViewController *controller = [[JP3DSViewController alloc] initWithConfiguration:configuration
                                                                              completion:completion];
    controller.apiService = self.apiService;

    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
    navController.modalPresentationStyle = UIModalPresentationFullScreen;

    [UIApplication.topMostViewController presentViewController:navController
                                                      animated:YES
                                                    completion:nil];
}

@end
