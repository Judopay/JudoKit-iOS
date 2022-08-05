#import "IASKAppSettingsViewController+Additions.h"
#import "Settings.h"

@implementation IASKAppSettingsViewController (Additions)

- (void)updateHiddenKeys {
    NSSet *hiddenKeys = [self computeHiddenKeysWithPriority:@[
        kIsPaymentSessionOnKey,
        kIsTokenAndSecretOnKey,
        kIsAddressOnKey,
        kIsPrimaryAccountDetailsOnKey
    ]];
    [self setHiddenKeys:hiddenKeys];
}

- (void)didChangedSettingsWithKeys:(NSArray<NSString *> *)keys {

    NSSet *hiddenKeys;

    if ([keys containsObject:kIsPaymentSessionOnKey]) {
        hiddenKeys = [self computeHiddenKeysWithPriority:@[ kIsPaymentSessionOnKey, kIsAddressOnKey, kIsPrimaryAccountDetailsOnKey ]];
    } else if ([keys containsObject:kIsTokenAndSecretOnKey]) {
        hiddenKeys = [self computeHiddenKeysWithPriority:@[ kIsTokenAndSecretOnKey, kIsAddressOnKey, kIsPrimaryAccountDetailsOnKey ]];
    } else if ([keys containsObject:kIsAddressOnKey] || [keys containsObject:kIsPrimaryAccountDetailsOnKey]) {
        hiddenKeys = [self computeHiddenKeysWithPriority:@[ kIsAddressOnKey, kIsPrimaryAccountDetailsOnKey ]];
    }

    if (hiddenKeys.count > 0) {
        [self setHiddenKeys:hiddenKeys animated:YES];
    }
}

- (NSSet *)computeHiddenKeysWithPriority:(NSArray *)keys {
    NSMutableArray *hiddenKeys = [NSMutableArray arrayWithArray:@[
        kTokenKey,
        kSecretKey,

        kSessionTokenKey,
        kPaymentSessionKey,

        kAddressLine1Key,
        kAddressLine2Key,
        kAddressLine3Key,
        kAddressTownKey,
        kAddressPostCodeKey,
        kAddressCountryCodeKey,
        kAddressPhoneCountryCodeKey,
        kAddressMobileNumberKey,
        kAddressEmailAddressKey,

        kPrimaryAccountNameKey,
        kPrimaryAccountAccountNumberKey,
        kPrimaryAccountDateOfBirthKey,
        kPrimaryAccountPostCodeKey
    ]];

    if ([keys containsObject:kIsPaymentSessionOnKey] && Settings.defaultSettings.isPaymentSessionAuthorizationOn) {
        [hiddenKeys removeObjectsInArray:@[ kSessionTokenKey, kPaymentSessionKey ]];
        [NSUserDefaults.standardUserDefaults setBool:NO forKey:kIsTokenAndSecretOnKey];
    }

    if ([keys containsObject:kIsTokenAndSecretOnKey] && Settings.defaultSettings.isTokenAndSecretAuthorizationOn) {
        [hiddenKeys removeObjectsInArray:@[ kTokenKey, kSecretKey ]];
        [NSUserDefaults.standardUserDefaults setBool:NO forKey:kIsPaymentSessionOnKey];
    }

    if ([keys containsObject:kIsAddressOnKey] && Settings.defaultSettings.isAddressOn) {
        [hiddenKeys removeObjectsInArray:@[
            kAddressLine1Key,
            kAddressLine2Key,
            kAddressLine3Key,
            kAddressTownKey,
            kAddressPostCodeKey,
            kAddressCountryCodeKey,
            kAddressPhoneCountryCodeKey,
            kAddressMobileNumberKey,
            kAddressEmailAddressKey,
        ]];
    }

    if ([keys containsObject:kIsPrimaryAccountDetailsOnKey] && Settings.defaultSettings.isPrimaryAccountDetailsOn) {
        [hiddenKeys removeObjectsInArray:@[
            kPrimaryAccountNameKey,
            kPrimaryAccountAccountNumberKey,
            kPrimaryAccountDateOfBirthKey,
            kPrimaryAccountPostCodeKey
        ]];
    }

    return [NSSet setWithArray:hiddenKeys];
}

@end
