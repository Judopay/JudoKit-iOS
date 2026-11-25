#import <Foundation/Foundation.h>
@import InAppSettingsKit;

@interface IASKAppSettingsViewController (Additions)
- (void)updateHiddenKeys;
- (void)didChangedSettingsWithKeys:(NSArray<NSString *> *)keys;
@end