//
//  JPUITestData.m
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

#import "JPUITestData.h"

@implementation JPUITestData

#pragma mark - Initializers

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        self.tags = dictionary[@"tags"];
        
        NSArray *cards = dictionary[@"cards"];
        NSMutableArray *mappedCards = [NSMutableArray new];
        
        for (NSDictionary *cardDictionary in cards) {
            JPUITestCard *card = [[JPUITestCard alloc] initWithDictionary:cardDictionary];
            [mappedCards addObject:card];
        }
        
        self.cards = mappedCards;
        
        NSArray *avs = dictionary[@"avs"];
        NSMutableArray *mappedAVS = [NSMutableArray new];
        
        for (NSDictionary *avsDictionary in avs) {
            JPUITestAddress *address = [[JPUITestAddress alloc] initWithDictionary:avsDictionary];
            [mappedAVS addObject:address];
        }
        
        self.avs = mappedAVS;
    }
    return self;
}

#pragma mark - Public methods

- (JPUITestCard *)fetchCardForTag:(NSString *)tag
                      andCardType:(NSString *)cardType {
    
    if (![self.tags containsObject:tag]) {
        return nil;
    }
        
    for (JPUITestCard *card in self.cards) {
        if ([card.cardType isEqualToString:cardType]) {
            return card;
        }
    }
    return nil;
}

- (NSString *)fetchPostCodeForTag:(NSString *)tag
                           andCountry:(NSString *)country {
    
    if (![self.tags containsObject:tag]) {
        return nil;
    }
        
    for (JPUITestAddress *address in self.avs) {
        if ([address.country isEqualToString:country]) {
            return address.postCode;
        }
    }
    return nil;
}

@end
