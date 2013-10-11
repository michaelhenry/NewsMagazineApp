//
//  DoubleContentViewController.h
//  NewsMagazine
//
//  Created by Michael henry Pantaleon on 4/29/13.
//  Copyright (c) 2013 Michael Henry Pantaleon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseContentViewController.h"

@interface DoubleContentViewController : BaseContentViewController

@property (nonatomic,strong) NSArray * articles;
@property (weak, nonatomic) IBOutlet UILabel *firstTitle;
@property (weak, nonatomic) IBOutlet UILabel *firstBody;
@property (weak, nonatomic) IBOutlet UILabel *secondTitle;
@property (weak, nonatomic) IBOutlet UILabel *secondBody;
@property (strong, nonatomic) IBOutlet UILabel *firstSourceLabel;
@property (strong, nonatomic) IBOutlet UIImageView *firstSourceImage;
@property (strong, nonatomic) IBOutlet UIImageView *secondSourceImage;
@property (strong, nonatomic) IBOutlet UILabel *secondSourceLabel;
@property (strong, nonatomic) IBOutlet UIView *firstSourceContainer;
@property (strong, nonatomic) IBOutlet UIView *secondSourceContainer;
@property (strong, nonatomic) IBOutlet UIView *container1;
@property (strong, nonatomic) IBOutlet UIView *container2;

@property (weak, nonatomic) IBOutlet UILabel *pubdateLabel1;
@property (weak, nonatomic) IBOutlet UILabel *pubdateLabel2;

@end
