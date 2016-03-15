//
//  DetailViewController.h
//  JudoKitObjCExampleApp
//
//  Created by Hamon Riazy on 15/03/2016.
//  Copyright © 2016 Judo Payments. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end

