//
//  WebBrowserViewController.h
//  NewsMagazine
//
//  Created by Michael henry Pantaleon on 7/12/13.
//  Copyright (c) 2013 Michael Henry Pantaleon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHUtilsViewController.h"

@interface WebBrowserViewController : MHUtilsViewController

@property (nonatomic,strong) NSURL * url;

@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet UIView *menuContainer;
@property (strong, nonatomic) IBOutlet UIButton *tweetLinkButton;
@property (strong, nonatomic) IBOutlet UIButton *cop;
@property (strong, nonatomic) IBOutlet UIButton *emailLinkButton;
@property (strong, nonatomic) IBOutlet UIButton *openLinkButton;

- (IBAction)didClose:(UIButton *)sender;
- (IBAction)didMenuSelected:(UIButton *)sender;
- (IBAction)didTapMenu:(UIButton *)sender ;
@property (strong, nonatomic) IBOutlet UILabel *urlLabel;
@property (strong, nonatomic) IBOutlet UILabel *navTitle;
@end
