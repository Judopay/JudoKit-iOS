//
//  ResultTests.m
//  ObjectiveCExampleAppTests
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

#import <XCTest/XCTest.h>
#import <JudoKit_iOS/JudoKit_iOS.h>
#import "Result.h"
#import "ResultItem.h"

@interface ResultTests : XCTestCase

@end

@implementation ResultTests

- (void)test_GivenValidJPResponse_ParseObjectCorrectly {
    JPResponse *mockedResponse = [self mockedResponse];
    Result *result = [Result resultFromObject:mockedResponse];
    
    XCTAssertTrue([result.title isEqualToString:@"JPResponse"]);
    
    for (ResultItem *item in result.items) {
        
        // Judo ID should resolve to NSString and should not have subresults
        if ([item.title isEqualToString:@"judoId"]) {
            XCTAssertTrue([item.value isEqualToString:@"123456"]);
            XCTAssertNil(item.subResult);
        }
        
        // Consumer should resolve to a JPConsumer and should have subresults
        if ([item.title isEqualToString:@"consumer"]) {
            XCTAssertTrue([item.value isEqualToString:@"JPConsumer"]);
            XCTAssertNotNil(item.subResult);
            
            XCTAssertTrue([item.subResult.title isEqualToString:@"JPConsumer"]);
            XCTAssertEqual(item.subResult.items.count, 2);
        }
    }
}

- (JPResponse *)mockedResponse {
    NSError *error;
    
    NSString* path = [[NSBundle bundleForClass:ResultTests.class] pathForResource:@"JPResponseStub"
                                                                           ofType:@"json"];
    
    NSString* contents = [NSString stringWithContentsOfFile:path
                                                   encoding:NSUTF8StringEncoding
                                                      error:&error];
    
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[contents dataUsingEncoding:NSUTF8StringEncoding]
                                                               options:kNilOptions
                                                                 error:&error];
    
    return [[JPResponse alloc] initWithDictionary:dictionary];
}

@end
