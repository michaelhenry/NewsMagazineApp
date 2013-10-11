//
//  ContentViewController.h
//  NewsMagazine
//
//  Created by Michael henry Pantaleon on 4/27/13.
//  Copyright (c) 2013 Michael Henry Pantaleon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseContentViewController.h"

@interface ContentViewController : BaseContentViewController
@property (nonatomic,weak) NSDictionary * article;
@property (weak, nonatomic) IBOutlet UIImageView *contentImage;
@property (weak, nonatomic) IBOutlet UILabel *contentTitle;
@property (strong, nonatomic) IBOutlet UILabel *contentAuthor;
@property (strong, nonatomic) IBOutlet UILabel *body;
@property (strong, nonatomic) IBOutlet UIImageView *sourceImage;
@property (strong, nonatomic) IBOutlet UILabel *sourceLabel;
@property (strong, nonatomic) IBOutlet UIView *sourceContainer;
@property (strong, nonatomic) IBOutlet UILabel *pubdateLabel;



@end
