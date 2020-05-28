//
//  PBBATableViewCell.m
//  ObjectiveCExampleApp
//
//  Created by Alexei Jovmir on 5/28/20.
//  Copyright © 2020 Judopay. All rights reserved.
//

#import "PBBATableViewCell.h"

@interface PBBATableViewCell ()
@property (strong, nonatomic) IBOutlet JPPBBAButton *pbbaButton;
@end

@implementation PBBATableViewCell

-(void)layoutSubviews {
    [super layoutSubviews];
    self.pbbaButton.delegate = self.delegate;
}

@end
