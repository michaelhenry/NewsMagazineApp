//
//  DetailViewController.h
//  NewsMagazine
//
//  Created by Michael henry Pantaleon on 4/30/13.
//  Copyright (c) 2013 Michael Henry Pantaleon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHUtilsViewController.h"
@class DRNRealTimeBlurView;
@interface DetailViewController : MHUtilsViewController

- (IBAction)didClose:(UIButton*)sender;

@property (weak, nonatomic) IBOutlet UIImageView *contentImage;
@property (weak, nonatomic) IBOutlet UILabel *contentTitle;
@property (nonatomic,strong) NSDictionary * article;
@property (weak, nonatomic) IBOutlet UILabel *contentAuthor;
@property (weak, nonatomic) IBOutlet UILabel *body;
@property (weak, nonatomic) IBOutlet UIImageView *sourceImage;
@property (weak, nonatomic) IBOutlet UILabel *sourceLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *articleScroll;

#pragma mark - Menu
@property (weak, nonatomic) IBOutlet UIButton *viewOnWebMainButton;
@property (weak, nonatomic) IBOutlet UIView *sourceContainer;
@property (weak, nonatomic) IBOutlet UILabel *pubdateLabel;
@property (weak, nonatomic) IBOutlet UILabel *navTitleLabel;

@property (strong, nonatomic) IBOutlet UIView *menuContainer;
@property (strong, nonatomic) IBOutlet UIButton *shareTwitterButton;
@property (strong, nonatomic) IBOutlet UIButton *shareFacebookButton;
@property (strong, nonatomic) IBOutlet UIButton *shareEmailButton;
@property (strong, nonatomic) IBOutlet UIButton *readItLaterButton;
@property (strong, nonatomic) IBOutlet UIButton *viewOnWebButton;
@property (weak, nonatomic) IBOutlet DRNRealTimeBlurView *menuBarContainer;

@property(nonatomic,strong) NSString * navTitle;

- (IBAction)didTapMenu:(UIButton *)sender;
- (IBAction)didMenuSelected:(UIButton *)sender;
- (IBAction)didViewOnBrowser:(UIButton *)sender;
@end
