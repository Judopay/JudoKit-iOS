#import <Foundation/Foundation.h>
#import <InAppSettingsKit/IASKAppSettingsViewController.h>

@interface IASKAppSettingsViewController (Additions)
- (void)updateHiddenKeys;
- (void)didChangedSettingsWithKeys:(NSArray<NSString *> *)keys;
@end