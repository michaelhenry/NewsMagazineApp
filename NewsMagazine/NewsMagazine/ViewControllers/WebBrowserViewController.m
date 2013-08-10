//
//  WebBrowserViewController.m
//  NewsMagazine
//
//  Created by Michael henry Pantaleon on 7/12/13.
//  Copyright (c) 2013 Michael Henry Pantaleon. All rights reserved.
//

#import "WebBrowserViewController.h"
#import "MHNatGeoViewControllerTransition.h"
@interface WebBrowserViewController ()<UIWebViewDelegate,MFMailComposeViewControllerDelegate>
{
    BOOL isMenuAnimating;
}

@end

@implementation WebBrowserViewController
@synthesize url = _url;
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
    
    [self.menuContainer removeFromSuperview];
    self.tweetLinkButton.frame = [self hideFrameOfMenuButton:self.tweetLinkButton];
    self.cop.frame = [self hideFrameOfMenuButton:self.cop];
    self.emailLinkButton.frame = [self hideFrameOfMenuButton:self.emailLinkButton];
    self.openLinkButton.frame = [self hideFrameOfMenuButton:self.openLinkButton];
    [self.urlLabel setText:_url.absoluteString];
    [self.webView loadRequest:[NSURLRequest requestWithURL:_url]];
	// Do any additional setup after loading the view.
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    NSString* title = [webView stringByEvaluatingJavaScriptFromString: @"document.title"];
    if([[title lowercaseString]isEqualToString:@"redirecting"])return;
    [self.navTitle setText:title];
}

- (void) webViewDidStartLoad:(UIWebView *)webView  {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didClose:(UIButton *)sender {
    [self dismissNatGeoViewController];
}


- (CGRect) hideFrameOfMenuButton:(UIButton*)button {
    CGRect newFrame = button.frame;
    newFrame.origin.x = newFrame.origin.x + button.frame.size.width;
    return newFrame;
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
        CGSize buttonSize = self.tweetLinkButton.frame.size;
        CGFloat originX = 200.0f;
        [UIView animateWithDuration:durationPerButton animations:^{
            self.openLinkButton.frame = CGRectMake(originX,132.0f, buttonSize.width, buttonSize.height);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:durationPerButton animations:^{
                self.emailLinkButton.frame = CGRectMake(originX, 88.0f, buttonSize.width, buttonSize.height);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:durationPerButton animations:^{
                    self.cop.frame = CGRectMake(originX,44.0f , buttonSize.width, buttonSize.height);
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:durationPerButton animations:^{
                        self.tweetLinkButton.frame = CGRectMake(originX,0.0f , buttonSize.width, buttonSize.height);
                    } completion:^(BOOL finished) {
                        [self.menuContainer removeFromSuperview];
                        isMenuAnimating = NO;
                        if(completion)
                            completion(YES);
                        
                    }];
                }];
            }];
        }];
        
        
        
    } else {
        
        [self.view addSubview:self.menuContainer];
        CGSize buttonSize = self.tweetLinkButton.frame.size;
        
        [UIView animateWithDuration:durationPerButton animations:^{
            self.tweetLinkButton.frame = CGRectMake(0, 0, buttonSize.width, buttonSize.height);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:durationPerButton animations:^{
                self.cop.frame = CGRectMake(0,44.0f, buttonSize.width, buttonSize.height);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:durationPerButton animations:^{
                    self.emailLinkButton.frame = CGRectMake(0, 88.0f, buttonSize.width, buttonSize.height);
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:durationPerButton animations:^{
                        self.openLinkButton.frame = CGRectMake(0, 132.0f, buttonSize.width, buttonSize.height);
                    } completion:^(BOOL finished) {
                        isMenuAnimating = NO;
                        if(completion)
                            completion(YES);
                    }];
                }];
            }];
        }];
    }
}

- (IBAction)didMenuSelected:(UIButton *)sender {
    
    if(!self.menuContainer.superview) return;
    [self animateMenu:NO completion:^(BOOL finished) {
        
        NSString * text = self.navTitle.text;
        NSURL * url = [NSURL URLWithString:self.urlLabel.text];
   
        if(sender.tag==1) {
            // Tweet Link
            [self postToTwitter:text url:url image:nil completion:nil];
        }else if(sender.tag==2) {
            // Copy Link
            [self copyToClipboardWithText:url.absoluteString completion:nil];
        }else if(sender.tag==3) {
            // Email Link
            [self composeEmail:text body:[NSString stringWithFormat:@"\n%@ via %@",url.absoluteString,@""] isHTML:NO recipients:nil completion:nil];
        }else if(sender.tag==4) {
            // Open in safari
            [self openInSafari: [NSURL URLWithString:self.urlLabel.text]];
        }
    }];
}




- (void)viewDidUnload {
    [self setWebView:nil];
    [self setMenuContainer:nil];
    [self setTweetLinkButton:nil];
    [self setCop:nil];
    [self setEmailLinkButton:nil];
    [self setOpenLinkButton:nil];
    [self setUrlLabel:nil];
    [self setNavTitle:nil];
    [super viewDidUnload];
}

@end
