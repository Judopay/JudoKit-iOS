#import "NSArray+Additions.h"
#import "NSObject+Additions.h"
#import <objc/runtime.h>

@implementation NSObject (Additions)

- (NSDictionary *)toDictionary {
    NSMutableDictionary *dictionary = [NSMutableDictionary new];
    [self appendFieldsOfClass:self.class toDictionary:dictionary serializeNils:NO];
    return [NSDictionary dictionaryWithDictionary:dictionary];
}

- (void)appendFieldsOfClass:(Class)aClass
               toDictionary:(NSMutableDictionary *)dictionary
              serializeNils:(BOOL)serializeNils {

    if (aClass != NSObject.class) {
        unsigned int count = 0;
        objc_property_t *_Nullable properties = class_copyPropertyList(aClass, &count);

        for (int i = 0; i < count; i++) {
            NSString *_Nullable key = [NSString stringWithUTF8String:property_getName(properties[i])];
            id value = [self valueForKey:key];

            if (value == nil) {
                if (serializeNils) {
                    dictionary[key] = NSNull.null;
                }
            } else if ([value isKindOfClass:NSNumber.class] || [value isKindOfClass:NSString.class] || [value isKindOfClass:NSDictionary.class]) {
                dictionary[key] = value;
            } else if ([value isKindOfClass:NSArray.class]) {
                NSArray *array = value;
                if (array.count > 0) {
                    dictionary[key] = [array toArrayOfDictionaries];
                }
            } else if ([value isKindOfClass:NSObject.class]) {
                dictionary[key] = [value toDictionary];
            }
        }

        free(properties);

        [self appendFieldsOfClass:aClass.superclass toDictionary:dictionary serializeNils:serializeNils];
    }
}

- (nullable NSData *)toJSONObjectData {
    id toSerialize = nil;
    NSError *error = nil;

    if ([self isKindOfClass:NSArray.class]) {
        toSerialize = [(NSArray *)self toArrayOfDictionaries];
    } else if ([self isKindOfClass:NSDictionary.class]) {
        toSerialize = self;
    } else {
        toSerialize = [self toDictionary];
    }

    NSData *data = [NSJSONSerialization dataWithJSONObject:toSerialize options:NSJSONWritingPrettyPrinted error:&error];

    if (!error) {
        return data;
    }

    return nil;
}

@end
