//
//  MHUtilsViewController.m
//  NewsMagazine
//
//  A collection of basic functionalities for every viewControllers
//
//  Created by Michael henry Pantaleon on 8/1/13.
//  Copyright (c) 2013 Michael Henry Pantaleon. All rights reserved.
//
#import "MHUtilsViewController.h"
#import <Social/Social.h>
#import "FlipBoardNavigationController.h"
#import "MHNatGeoViewControllerTransition.h"

@interface MHUtilsViewController ()<MFMailComposeViewControllerDelegate>

@property(nonatomic,assign) SharingCompletionBlock sharingCompletionBlock;
@property(nonatomic,assign) EmailCompletionBlock emailCompletionBlock;

@end

@implementation MHUtilsViewController

@synthesize sharingCompletionBlock = _sharingCompletionBlock;
@synthesize emailCompletionBlock = _emailCompletionBlock;
#pragma mark - Social Sharing Support

- (void)postToTwitter:(NSString*) text url:(NSURL*)url image:(UIImage*)image completion:(SharingCompletionBlock)completion {
    _sharingCompletionBlock = completion;
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *tweetSheet = [SLComposeViewController
                                               composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweetSheet setInitialText:text];
        if(url)[tweetSheet addURL:url];
        if(image)[tweetSheet addImage:image];
        [self presentViewController:tweetSheet animated:YES completion:^{
           if(_sharingCompletionBlock) _sharingCompletionBlock(YES,@"");
        }];
    } else {
        if(_sharingCompletionBlock) _sharingCompletionBlock(NO,@"Please Add your Twitter account to your Phone Setting");
    }
}


- (void)postToFacebook:(NSString*) text url:(NSURL*)url image:(UIImage*)image completion:(SharingCompletionBlock)completion {
    _sharingCompletionBlock = completion;
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        SLComposeViewController *fbSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        [fbSheet setInitialText:text];
        if(url)[fbSheet addURL:url];
        if(image)[fbSheet addImage:image];
        [self presentViewController:fbSheet animated:YES completion:^{
            if(_sharingCompletionBlock) _sharingCompletionBlock(YES,@"");
        }];
    }else {
        if(_sharingCompletionBlock) _sharingCompletionBlock(NO,@"Please Add your Facebook account to your Phone Setting");
    }
}

#pragma mark - Email Sharing Support

- (void) composeEmail:(NSString*)subject body:(NSString*)body isHTML:(BOOL)isHTML recipients:(NSArray*)recipients completion:(EmailCompletionBlock)completion{
    _emailCompletionBlock = completion;
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController * email = [[MFMailComposeViewController alloc]init];
        email.mailComposeDelegate = self;
        [email setToRecipients:recipients];
        [email setSubject:subject];
        [email setMessageBody:body isHTML:isHTML];
        [self.flipboardNavigationController presentNatGeoViewController:email];
        email = nil;
    }else {
        if(_emailCompletionBlock) _emailCompletionBlock(NO,0,nil);
    }
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [controller dismissNatGeoViewControllerWithCompletion:^(BOOL finished) {
        if(_emailCompletionBlock)_emailCompletionBlock(YES,result,error);
    }];
}

#pragma mark - Copy To Clipboard
- (void) copyToClipboardWithText:(NSString*)text completion:(void (^)(void))completion{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = text;
    if(completion)completion();
}

- (void) showAppInAppStoreWithId:(NSString*)appId{
    NSString *urlString = [NSString stringWithFormat:@"http://itunes.apple.com/app/id%@",appId];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
}

- (void) openInSafari:(NSURL*)url{
    [[UIApplication sharedApplication] openURL:url];
}

@end
