#import "NSArray+Additions.h"
#import "NSObject+Additions.h"
#import <objc/runtime.h>

@implementation NSObject (Additions)

- (NSDictionary *)_jp_toDictionary {
    NSMutableDictionary *dictionary = [NSMutableDictionary new];
    [self appendFieldsOfClass:self.class toDictionary:dictionary serializeNils:NO];
    return [NSDictionary dictionaryWithDictionary:dictionary];
}

- (void)appendFieldsOfClass:(Class)aClass
               toDictionary:(NSMutableDictionary *)dictionary
              serializeNils:(BOOL)serializeNils {

    if (aClass != NSObject.class) {
        unsigned int count = 0;
        objc_property_t *properties = class_copyPropertyList(aClass, &count);

        if (properties) {
            for (int i = 0; i < count; i++) {
                NSString *key = [NSString stringWithUTF8String:property_getName(properties[i])];

                if (key == nil) {
                    continue;
                }

                id value = [self objectForKey:key serializeNils:serializeNils];
                if (value) {
                    dictionary[key] = value;
                }
            }
        }

        free(properties);

        [self appendFieldsOfClass:aClass.superclass toDictionary:dictionary serializeNils:serializeNils];
    }
}

- (id)objectForKey:(NSString *)key serializeNils:(BOOL)serializeNils {
    id value = [self valueForKey:key];

    if (value && ![value isKindOfClass:NSNull.class]) {
        if ([value isKindOfClass:NSNumber.class] || [value isKindOfClass:NSString.class] || [value isKindOfClass:NSDictionary.class]) {
            return value;
        } else if ([value isKindOfClass:NSArray.class]) {
            NSArray *array = value;
            if (array.count > 0) {
                return [array _jp_toArrayOfDictionaries];
            }
        } else if ([value isKindOfClass:NSObject.class]) {
            return [value _jp_toDictionary];
        }
    }

    return serializeNils ? NSNull.null : nil;
}

- (nullable NSData *)_jp_toJSONObjectData {
    id toSerialize = nil;
    NSError *error = nil;

    if ([self isKindOfClass:NSArray.class]) {
        toSerialize = [(NSArray *)self _jp_toArrayOfDictionaries];
    } else if ([self isKindOfClass:NSDictionary.class]) {
        toSerialize = self;
    } else {
        toSerialize = [self _jp_toDictionary];
    }

    NSData *data = [NSJSONSerialization dataWithJSONObject:toSerialize options:NSJSONWritingPrettyPrinted error:&error];

    if (!error) {
        return data;
    }

    return nil;
}

@end
