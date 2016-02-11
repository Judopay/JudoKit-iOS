//
//  JPSession.m
//  JudoKitObjC
//
//  Created by ben.riazy on 11/02/2016.
//  Copyright © 2016 Judo Payments. All rights reserved.
//

#import "JPSession.h"

static NSInteger const kMinimumJudoIDLength = 6;
static NSInteger const kMaximumJudoIDLength = 10;

typedef void (^JudoCompletionBlock)(NSDictionary *, NSError *);

@interface JPSession ()

@property (nonatomic, strong, readwrite) NSString *endpoint;
@property (nonatomic, strong, readwrite) NSString *authorizationHeader;

@end

@implementation JPSession

#pragma mark - REST API

- (void)POST:(NSString *)path parameters:(NSDictionary *)parameters completion:(JudoCompletionBlock)completion {
    
}

- (void)PUT:(NSString *)path parameters:(NSDictionary *)parameters completion:(JudoCompletionBlock)completion {
    
}

- (void)GET:(NSString *)path parameters:(NSDictionary *)parameters completion:(JudoCompletionBlock)completion {
    NSMutableURLRequest *request = [self judoRequest:[NSString stringWithFormat:@"%@%@", self.endpoint, path]];
    
    request.HTTPMethod = @"GET";
    
    NSError *error = nil;
    
    NSData *requestBody = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:&error];
    
    if (error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(nil, error);
        });
        return; // BAIL
    }
    
    NSURLSessionDataTask *task = [self task:request completion:completion];
    
    [task resume];
}

- (NSMutableURLRequest *)judoRequest:(NSString *)url {
    // create request and configure headers
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request addValue:@"5.0.0" forHTTPHeaderField:@"API-Version"];
    
    // Adds the version and lang of the SDK to the header
    NSBundle *currentBundle = [NSBundle bundleWithIdentifier:@"com.judopay.JudoKitObjC"];
    NSString *version = currentBundle.infoDictionary[@"CFBundleShortVersionString"];
    
    if (version) {
        [request addValue:@"iOS-Version/\(version) lang/(ObjC)" forHTTPHeaderField:@"User-Agent"];
        [request addValue:@"iOSObjC-\(version)" forHTTPHeaderField:@"Sdk-Version"];
    }
    
    // Check if token and secret have been set
    NSAssert(self.authorizationHeader, @"token and secret not set");
    
    // Set auth header
    [request addValue:self.authorizationHeader forHTTPHeaderField:@"Authorization"];

    return request;
}

- (NSURLSessionDataTask *)task:(NSURLRequest *)request completion:(JudoCompletionBlock)completion {
    return [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (!data) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) {
                    completion(nil, error);
                }
            });
        }
        
        
        
        // TODO: parse response
    }];
}

#pragma mark - getters and setters

- (BOOL)sandboxed {
    return [self.endpoint isEqualToString:@"https://gw1.judopay-sandbox.com/"];
}

- (void)setSandboxed:(BOOL)sandboxed {
    if (sandboxed) {
        self.endpoint = @"https://gw1.judopay-sandbox.com/";
    } else {
        self.endpoint = @"https://gw1.judopay.com/";
    }
}

@end
