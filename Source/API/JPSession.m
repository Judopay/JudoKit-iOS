//
//  JPSession.m
//  JudoKitObjC
//
//  Created by ben.riazy on 11/02/2016.
//  Copyright © 2016 Judo Payments. All rights reserved.
//

#import "JPSession.h"
#import "JPPagination.h"
#import "JPResponse.h"
#import "NSError+Judo.h"

static NSInteger const kMinimumJudoIDLength = 6;
static NSInteger const kMaximumJudoIDLength = 10;

typedef void (^JudoCompletionBlock)(JPResponse *, NSError *);

@interface JPSession ()

@property (nonatomic, strong, readwrite) NSString *endpoint;
@property (nonatomic, strong, readwrite) NSString *authorizationHeader;

@end

@implementation JPSession

#pragma mark - REST API

- (void)apiCall:(NSString *)HTTPMethod path:(NSString *)path parameters:(NSDictionary *)parameters completion:(JudoCompletionBlock)completion {
    NSMutableURLRequest *request = [self judoRequest:[NSString stringWithFormat:@"%@%@", self.endpoint, path]];
    
    request.HTTPMethod = HTTPMethod;
    
    if (parameters) {
        NSError *error = nil;
        request.HTTPBody = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:&error];
        
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(nil, error);
            });
            return; // BAIL
        }
    }
    
    NSURLSessionDataTask *task = [self task:request completion:completion];
    
    [task resume];
}

- (void)POST:(NSString *)path parameters:(NSDictionary *)parameters completion:(JudoCompletionBlock)completion {
    [self apiCall:@"POST" path:path parameters:parameters completion:completion];
}

- (void)PUT:(NSString *)path parameters:(NSDictionary *)parameters completion:(JudoCompletionBlock)completion {
    [self apiCall:@"PUT" path:path parameters:parameters completion:completion];
}

- (void)GET:(NSString *)path parameters:(NSDictionary *)parameters completion:(JudoCompletionBlock)completion {
    [self apiCall:@"GET" path:path parameters:parameters completion:completion];
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
        
        // check if an error occurred
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) {
                    completion(nil, error);
                }
            });
            return; // BAIL
        }
        
        // check if response data is available
        if (!data) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) {
                    completion(nil, [NSError judoRequestFailedError]);
                }
            });
            return; // BAIL
        }
        
        // serialize json
        __block NSError *jsonError = nil;
        
        NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
        
        if (jsonError || !responseJSON) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) {
                    if (!jsonError) {
                        jsonError = [NSError judoJSONSerializationError];
                    }
                    completion(nil, jsonError);
                }
            });
            return; // BAIL
        }
        
        // check if API Error was returned
        NSNumber *errorCode = responseJSON[@"code"];
        
        if (errorCode) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) {
                    completion(nil, [NSError judoErrorFromErrorCode:errorCode.integerValue]);
                }
            });
            return; // BAIL
        }
        
        // check if 3DS was requested
        if (responseJSON[@"acsUrl"] && responseJSON[@"paReq"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) {
                    completion(nil, [NSError judo3DSRequestWithPayload:responseJSON]);
                }
            });
            return; // BAIL
        }
        
        JPPagination *pagination = nil;
        
        if (responseJSON[@"offset"] && responseJSON[@"pageSize"] && responseJSON[@"sort"]) {
            pagination = [JPPagination paginationWithOffset:responseJSON[@"offset"]
                                                   pageSize:responseJSON[@"pageSize"]
                                                       sort:responseJSON[@"sort"]];
        }
        
        JPResponse *result = [JPResponse responseWithPagination:pagination];
        
        if (responseJSON[@"results"]) {
            result.items = responseJSON[@"results"];
        } else {
            result.items = @[responseJSON];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) {
                completion(result, nil);
            }
        });
        
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
