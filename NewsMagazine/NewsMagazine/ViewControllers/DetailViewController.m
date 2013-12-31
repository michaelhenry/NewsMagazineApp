//
//  DetailViewController.m
//  NewsMagazine
//
//  Created by Michael henry Pantaleon on 4/30/13.
//  Copyright (c) 2013 Michael Henry Pantaleon. All rights reserved.
//

#import "DetailViewController.h"
#import "MPFlipTransition.h"
#import "UIImageView+AFNetworking.h"
#import "ViewController.h"
#import "NSString+HTML.h"
#import "MHFacebookImageViewer.h"
#import "MHHelper.h"
#import "WebBrowserViewController.h"
#import "MHNatGeoViewControllerTransition.h"
#import "FlipBoardNavigationController.h"
#import "SIAlertView.h"
#import "IOSMacroFunctionHelper.h"
#import "DRNRealTimeBlurView.h"
@interface DetailViewController () {
    BOOL isMenuAnimating;
    CGFloat navHeight;
}
- (void) relayoutViews;



@end

@implementation DetailViewController
@synthesize article;
@synthesize navTitle;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")){
        navHeight = 64.0f;
    }else {
        navHeight = 44.0f;
    }
    [self.menuContainer removeFromSuperview];
    [self.navTitleLabel setText:self.navTitle];
    self.shareTwitterButton.frame = [self hideFrameOfMenuButton:self.shareTwitterButton];
    self.shareFacebookButton.frame = [self hideFrameOfMenuButton:self.shareFacebookButton];
    self.shareEmailButton.frame = [self hideFrameOfMenuButton:self.shareEmailButton];
    self.readItLaterButton.frame = [self hideFrameOfMenuButton:self.readItLaterButton];
    self.viewOnWebButton.frame = [self hideFrameOfMenuButton:self.viewOnWebButton];
//    self.menuBarContainer.tintColor = [UIColor whiteColor];
    self.menuContainer.tintColor = [UIColor whiteColor];
    
    [self relayoutViews];
	// Do any additional setup after loading the view.
}

- (CGRect) hideFrameOfMenuButton:(UIButton*)button {
    CGRect newFrame = button.frame;
    newFrame.origin.x = newFrame.origin.x + button.frame.size.width;
    return newFrame;
}

- (void) relayoutViews {
    NSDictionary * source = [self.article objectForKey:@"source"];
    [self.sourceImage setImageWithURL:[NSURL URLWithString:[source objectForKey:@"thumbnail"]]];
    [self.sourceLabel setText:[source objectForKey:@"name"]];
    [self.pubdateLabel setText:[MHHelper getRelativeTimeWithUnixTime:[[self.article objectForKey:@"pubdate"]doubleValue] ]];
    [self.contentTitle setText:[[[self.article objectForKey:@"title"]stringByDecodingHTMLEntities]stringByDecodingHTMLEntities]];
    [self.contentAuthor setText:[[self.article objectForKey:@"author"]stringByDecodingHTMLEntities]];
    [self.body setText:[[[[self.article objectForKey:@"body"]stringByDecodingHTMLEntities]stringByReplacingOccurrencesOfString:@"\n" withString:@"\n\n"]stringByDecodingHTMLEntities]];
    [self layoutNow];
}
- (void) layoutNow {
    
    CGFloat totalY = navHeight;
    
    if([[self.article objectForKey:@"images"]count]>0) {
        NSDictionary * image = [[self.article objectForKey:@"images"]objectAtIndex:0];
        NSDictionary * iphoneSize = [[image objectForKey:@"sizes"]objectForKey:@"iphone"];
        self.contentImage.frame = CGRectMake(0,totalY, [[iphoneSize objectForKey:@"w"]floatValue], [[iphoneSize objectForKey:@"h"]floatValue]);
        
        totalY = totalY + [[iphoneSize objectForKey:@"h"]floatValue];
  
        [self.contentImage setImageWithURL:[NSURL URLWithString:[iphoneSize objectForKey:@"url"]]];
        
        self.contentImage.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentImage setupImageViewer];
        self.contentImage.clipsToBounds = YES;
    }else {
        [self.contentImage removeFromSuperview];
    }
    
    totalY = totalY + 10.0f;
    self.contentTitle.frame = CGRectMake(10.0f, totalY, 300, 0);
    [self.contentTitle sizeToFit];
    totalY = totalY + self.contentTitle.frame.size.height;
    
    self.contentAuthor.frame = CGRectMake(10.0f, totalY, 300, 0);
    [self.contentAuthor sizeToFit];
    totalY = totalY + self.contentAuthor.frame.size.height + 5.0f;
    
    self.body.frame = CGRectMake(10.0f, totalY, 300, 0);
    [self.body sizeToFit];
    totalY = totalY + self.body.frame.size.height + 10.0f;
    if(totalY < (self.view.frame.size.height - 125.0f)) {
        totalY = self.view.frame.size.height - 125.0f;
    }
    self.viewOnWebMainButton.frame = CGRectMake(35.0f, totalY, 250.0f, 45.0f);
    totalY = totalY + self.viewOnWebMainButton.frame.size.height + 10.0f;
    self.sourceContainer.frame = CGRectMake(0.0f, totalY, 320.0f, 60.0f);
    [self.articleScroll setContentSize:CGSizeMake(300.0f, totalY+60.0f)];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setContentImage:nil];
    [self setContentTitle:nil];
    [self setContentAuthor:nil];
    [self setBody:nil];
    
    [self setSourceImage:nil];
    [self setSourceLabel:nil];
    [self setSourceContainer:nil];
    [self setArticleScroll:nil];
    [self setMenuContainer:nil];
    [self setShareTwitterButton:nil];
    [self setShareFacebookButton:nil];
    [self setShareEmailButton:nil];
    [self setReadItLaterButton:nil];
    [self setViewOnWebButton:nil];
    [self setViewOnWebMainButton:nil];
    [self setSourceContainer:nil];
    [self setPubdateLabel:nil];
    [self setNavTitleLabel:nil];
    [super viewDidUnload];
}

- (void) didClose:(UIButton *)sender {
    [self.flipboardNavigationController popViewControllerWithCompletion:^{
        NSLog(@"POP SUCCESS");
    }];
}

- (IBAction)didTapMenu:(UIButton *)sender {
    if(self.menuContainer.superview) {
        [self animateMenu:NO completion:^(BOOL finished) {
            
        }];
    } else {
        [self animateMenu:YES completion:nil];
    }
}

#pragma mark - Menu Animation
- (void) animateMenu:(BOOL)open completion:(void(^)(BOOL finished)) completion {
    CGFloat durationPerButton = 0.15f;
    if(isMenuAnimating) return;
    isMenuAnimating = YES;
    if(!open) {
        CGSize buttonSize = self.shareTwitterButton.frame.size;
        CGFloat originX = 200.0f;
        
        [UIView animateWithDuration:durationPerButton animations:^{
            self.viewOnWebButton.frame = CGRectMake(originX, 176.0f, buttonSize.width, buttonSize.height);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:durationPerButton animations:^{
                self.readItLaterButton.frame = CGRectMake(originX,132.0f, buttonSize.width, buttonSize.height);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:durationPerButton animations:^{
                    self.shareEmailButton.frame = CGRectMake(originX, 88.0f, buttonSize.width, buttonSize.height);
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:durationPerButton animations:^{
                        self.shareFacebookButton.frame = CGRectMake(originX,44.0f , buttonSize.width, buttonSize.height);
                    } completion:^(BOOL finished) {
                        [UIView animateWithDuration:durationPerButton animations:^{
                            self.shareTwitterButton.frame = CGRectMake(originX,0.0f , buttonSize.width, buttonSize.height);
                        } completion:^(BOOL finished) {
                            isMenuAnimating = NO;
                            [self.menuContainer removeFromSuperview];
                            if(completion)
                                completion(YES);
                        }];
                    }];
                }];
            }];
        }];
        
        
    } else {
        [self.view addSubview:self.menuContainer];
        CGSize buttonSize = self.shareTwitterButton.frame.size;
        
        [UIView animateWithDuration:durationPerButton animations:^{
            self.shareTwitterButton.frame = CGRectMake(0, 0, buttonSize.width, buttonSize.height);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:durationPerButton animations:^{
                self.shareFacebookButton.frame = CGRectMake(0,44.0f, buttonSize.width, buttonSize.height);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:durationPerButton animations:^{
                    self.shareEmailButton.frame = CGRectMake(0, 88.0f, buttonSize.width, buttonSize.height);
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:durationPerButton animations:^{
                        self.readItLaterButton.frame = CGRectMake(0, 132.0f, buttonSize.width, buttonSize.height);
                    } completion:^(BOOL finished) {
                        [UIView animateWithDuration:durationPerButton animations:^{
                            self.viewOnWebButton.frame = CGRectMake(0, 176.0f, buttonSize.width, buttonSize.height);
                        } completion:^(BOOL finished) {
                            isMenuAnimating = NO;
                            if(completion)
                                completion(YES);
                        }];
                    }];
                }];
            }];
        }];
    }
}

- (IBAction)didMenuSelected:(UIButton *)sender {
    if(!self.menuContainer.superview) return;
    [self animateMenu:NO completion:^(BOOL finished) {
        [self.menuContainer removeFromSuperview];
        UIImage * image = self.contentImage.image;
        NSString * text = [self.article objectForKey:@"title"];
        NSURL * url = [NSURL URLWithString:[self.article objectForKey:@"link"]];
        if(sender.tag == 1) {
            [self postToTwitter:text url:url image:image completion:^(BOOL success, NSString *message) {
                if(!success) {
                    SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"Share via Twitter" andMessage:message];
                    [alertView addButtonWithTitle:@"Close"
                                             type:SIAlertViewButtonTypeDestructive
                                          handler:^(SIAlertView *alert) {
                                              NSLog(@"Button2 Clicked");
                                          }];
                    alertView.transitionStyle = SIAlertViewTransitionStyleBounce;
                    [alertView show];
                    alertView = nil;
                    
                }
            }];
        } else if(sender.tag == 2) {
            [self postToFacebook:text url:url image:image completion:^(BOOL success, NSString *message) {
                if(!success) {
                    SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"Share via Facebook" andMessage:message];
                    [alertView addButtonWithTitle:@"Close"
                                             type:SIAlertViewButtonTypeDestructive
                                          handler:^(SIAlertView *alert) {
                                              NSLog(@"Button2 Clicked");
                                          }];
                    alertView.transitionStyle = SIAlertViewTransitionStyleBounce;
                    [alertView show];
                    alertView = nil;
                    
                }
            }];
        }else if(sender.tag==3) {
            [self composeEmail:text body:url.absoluteString isHTML:NO recipients:nil completion:^(BOOL success, MFMailComposeResult result, NSError *error) {
                if(!success) {
                    SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"Share via Email" andMessage:@"Please add your email account to your phone setting. Thank you!"];
                    [alertView addButtonWithTitle:@"Close"
                                             type:SIAlertViewButtonTypeDestructive
                                          handler:^(SIAlertView *alert) {
                                              NSLog(@"Button2 Clicked");
                                          }];
                    alertView.transitionStyle = SIAlertViewTransitionStyleBounce;
                    [alertView show];
                    alertView = nil;
                }
            }];
        }else if(sender.tag==4){
            [self readItLater];
        } else if(sender.tag == 5)  {
            [self didViewOnBrowser:sender];
        }
    }];
}

#pragma mark - View on Browser
- (IBAction)didViewOnBrowser:(UIButton *)sender {
    WebBrowserViewController * webBrowserVC = [self.storyboard instantiateViewControllerWithIdentifier:@"web_vc"];
    webBrowserVC.url = [NSURL URLWithString:[self.article objectForKey:@"link"]];
    [self.flipboardNavigationController presentNatGeoViewController:webBrowserVC];
    webBrowserVC = nil;
}

- (void) readItLater {
    SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"Read it later." andMessage:@"Sorry, this feature is not available yet. Thank you!"];
    
    [alertView addButtonWithTitle:@"Close"
                             type:SIAlertViewButtonTypeDestructive
                          handler:^(SIAlertView *alert) {
                              NSLog(@"Button2 Clicked");
                          }];
    alertView.transitionStyle = SIAlertViewTransitionStyleBounce;
    [alertView show];
    alertView = nil;
}



@end
