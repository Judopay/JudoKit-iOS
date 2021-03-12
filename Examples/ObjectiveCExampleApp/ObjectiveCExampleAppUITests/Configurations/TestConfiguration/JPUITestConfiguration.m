//
//  JPUITestConfiguration.m
//  ObjectiveCExampleAppUITests
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

#import "JPUITestConfiguration.h"
#import "JPUITestCard.h"

@implementation JPUITestConfiguration

#pragma mark - Initializers

+ (instancetype)defaultConfiguration {
    NSString *path = @"/JudoKit-Automation-Scenarios/test-input-data.json";
    return [[JPUITestConfiguration alloc] initWithRelativePath:path];
}

- (instancetype)initWithRelativePath:(NSString *)relativePath {
    
    
    NSString *configPathInput = [SRC_ROOT stringByAppendingString:@"/JudoKit-Automation-Scenarios/"];
    NSError * error;
    
    NSArray * directoryContentsInput = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:configPathInput  error:&error];
    
    NSLog(@"directoryContentsInput = %@ \n\n error = %@", directoryContentsInput, error);
    
    NSString *configPathFeatures = [SRC_ROOT stringByAppendingString:@"/JudoKit-Automation-Scenarios/features/"];
    NSArray * directoryContentsFeatures = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:configPathFeatures  error:&error];
    
    NSLog(@"directoryContentsFeatures = %@ \n\n error = %@", directoryContentsFeatures, error);
    
    
    NSString *configPath = [SRC_ROOT stringByAppendingString:relativePath];
    NSURL *url = [NSURL fileURLWithPath:configPath];
    return [self initWithContentsOfURL:url];
}

- (instancetype)initWithContentsOfURL:(NSURL *)url {
    NSData *data = [NSData dataWithContentsOfURL:url];
    return [self initWithData:data];
}

- (instancetype)initWithData:(NSData *)data {
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data
                                                               options:NSJSONReadingAllowFragments
                                                                 error:nil];
    return [self initWithDictionary:dictionary];
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        self.token = dictionary[@"token"];
        self.secret = dictionary[@"secret"];
        
        self.threeDSToken = dictionary[@"threeDSToken"];
        self.threeDSSecret = dictionary[@"threeDSSecret"];
        
        self.judoID = dictionary[@"judoId"];
        
        NSNumber *sandboxValue = dictionary[@"sandbox"];
        self.isSandboxed = sandboxValue.boolValue;

        self.testsToInclude = dictionary[@"testsToInclude"];
        self.testsToSkip = dictionary[@"testsToSkip"];
        
        self.defaultCards = [self getMappedCardsFromDictionary:dictionary];
        self.testData = [self getMappedTestDataFromDictionary:dictionary];
    }

    return self;
}

#pragma mark - Public methods

- (NSString *)fetchFieldForTag:(NSString *)tag
                    identifier:(NSString *)identifier
                       andType:(NSString *)type {
    
    NSArray *cardTypes = @[
        @"VISA", @"MASTERCARD", @"AMEX", @"DISCOVER", @"JCB"
    ];
    
    NSArray *avsTypes = @[
        @"UK", @"USA", @"Canada", @"Other"
    ];
    
    if ([cardTypes containsObject:type]) {
        return [self fetchCardInputForTag:tag
                               identifier:identifier
                                  andType:type];
    }
    
    if ([avsTypes containsObject:type]) {
        return [self fetchPostCodeForTag:tag andCountry:type];
    }
    
    return nil;
}

#pragma mark - Helper methods

- (NSArray *)getMappedCardsFromDictionary:(NSDictionary *)dictionary {
    NSArray *defaultCards = dictionary[@"defaultCards"];
    NSMutableArray *mappedCards = [NSMutableArray new];
    
    if (!defaultCards) { return mappedCards; }
    
    for (NSDictionary *cardDictionary in defaultCards) {
        JPUITestCard *card = [[JPUITestCard alloc] initWithDictionary:cardDictionary];
        [mappedCards addObject:card];
    }
    
    return mappedCards;
}

- (NSArray *)getMappedTestDataFromDictionary:(NSDictionary *)dictionary {
    NSArray *testData = dictionary[@"testData"];
    NSMutableArray *mappedTestData = [NSMutableArray new];
    
    if (!testData) { return mappedTestData; }
    
    for (NSDictionary *dataEntry in testData) {
       JPUITestData *data = [[JPUITestData alloc] initWithDictionary:dataEntry];
        [mappedTestData addObject:data];
    }
    
    return mappedTestData;
}

- (NSString *)fetchCardInputForTag:(NSString *)tag
                        identifier:(NSString *)identifier
                           andType:(NSString *)type {
    
    JPUITestCard *defaultCard = [self fetchDefaultCardForType:type];
    JPUITestCard *taggedCard = [self fetchCardForTag:tag withCardType:type];
    
    NSString *defaultCardField;
    NSString *taggedCardField;
    
    if (defaultCard) {
        defaultCardField = [defaultCard valueForField:identifier];
    }
    
    if (taggedCard) {
        taggedCardField = [taggedCard valueForField:identifier];
    }
        
    return taggedCardField ? taggedCardField : defaultCardField;
}

- (JPUITestCard *)fetchDefaultCardForType:(NSString *)cardType {
    
    for (JPUITestCard *card in self.defaultCards) {
        if ([card.cardType isEqualToString:cardType]) {
            return card;
        }
    }
    return nil;
}

- (JPUITestCard *)fetchCardForTag:(NSString *)tag
                     withCardType:(NSString *)cardType {
        
    for (JPUITestData *dataEntry in self.testData) {
        JPUITestCard *card = [dataEntry fetchCardForTag:tag andCardType:cardType];
        if (card) { return card; }
    }
    return nil;
}

- (NSString *)fetchPostCodeForTag:(NSString *)tag
                       andCountry:(NSString *)country {
    
    for (JPUITestData *dataEntry in self.testData) {
        NSString *postCode = [dataEntry fetchPostCodeForTag:tag andCountry:country];
        if (postCode) { return postCode; }
    }
    return nil;
}

@end
