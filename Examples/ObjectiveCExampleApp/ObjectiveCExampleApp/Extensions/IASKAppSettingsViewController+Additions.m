#import "IASKAppSettingsViewController+Additions.h"
#import "Settings.h"

@implementation IASKAppSettingsViewController (Additions)

- (void)updateHiddenKeys {
    NSSet *hiddenKeys = [self computeHiddenKeysWithPriority:@[kIsPaymentSessionOnKey, kIsTokenAndSecretOnKey]];
    [self setHiddenKeys:hiddenKeys];
}

- (void)didChangedSettingsWithKeys:(NSArray<NSString *> *)keys {

    NSSet *hiddenKeys;

    if ([keys containsObject:kIsPaymentSessionOnKey]) {
        hiddenKeys = [self computeHiddenKeysWithPriority:@[kIsPaymentSessionOnKey]];
    } else if ([keys containsObject:kIsTokenAndSecretOnKey]) {
        hiddenKeys = [self computeHiddenKeysWithPriority:@[kIsTokenAndSecretOnKey]];
    }
    
    if (hiddenKeys.count > 0) {
        [self setHiddenKeys:hiddenKeys animated:YES];
    }
}

- (NSSet *)computeHiddenKeysWithPriority:(NSArray *)keys {
    NSMutableSet *hiddenKeys = [NSMutableSet setWithArray:@[kTokenKey, kSecretKey, kSessionTokenKey, kPaymentSessionKey]];

    if ([keys containsObject:kIsPaymentSessionOnKey] && Settings.defaultSettings.isPaymentSessionAuthorizationOn) {
        [hiddenKeys removeObject:kSessionTokenKey];
        [hiddenKeys removeObject:kPaymentSessionKey];
        [NSUserDefaults.standardUserDefaults setBool:NO forKey:kIsTokenAndSecretOnKey];
    }

    if ([keys containsObject:kIsTokenAndSecretOnKey] && Settings.defaultSettings.isTokenAndSecretAuthorizationOn) {
        [hiddenKeys removeObject:kTokenKey];
        [hiddenKeys removeObject:kSecretKey];
        [NSUserDefaults.standardUserDefaults setBool:NO forKey:kIsPaymentSessionOnKey];
    }

    return hiddenKeys;
}

@end
