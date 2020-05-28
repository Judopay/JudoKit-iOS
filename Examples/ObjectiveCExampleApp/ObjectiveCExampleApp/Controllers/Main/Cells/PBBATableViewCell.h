//
//  PBBATableViewCell.h
//  ObjectiveCExampleApp
//
//  Created by Alexei Jovmir on 5/28/20.
//  Copyright © 2020 Judopay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JPPBBAButton.h"

@interface PBBATableViewCell : UITableViewCell
@property (nonatomic, strong) id<JPPBBAButtonDelegate> delegate;
@end
