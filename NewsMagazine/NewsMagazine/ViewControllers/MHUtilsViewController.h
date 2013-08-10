//
//  MHUtilsViewController.h
//  NewsMagazine
//
//  A collection of basic functionalities for every viewControllers
//
//  Created by Michael henry Pantaleon on 8/1/13.
//  Copyright (c) 2013 Michael Henry Pantaleon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

typedef void (^SharingCompletionBlock)(BOOL success,NSString * message);
typedef void (^EmailCompletionBlock)(BOOL success,MFMailComposeResult result,NSError * error );
@interface MHUtilsViewController : UIViewController


- (void)postToTwitter:(NSString*) text url:(NSURL*)url image:(UIImage*)image completion:(SharingCompletionBlock)completion;
- (void)postToFacebook:(NSString*) text url:(NSURL*)url image:(UIImage*)image completion:(SharingCompletionBlock)completion;
- (void) composeEmail:(NSString*)subject body:(NSString*)body isHTML:(BOOL)isHTML recipients:(NSArray*)recipients completion:(EmailCompletionBlock)completion;

- (void) copyToClipboardWithText:(NSString*)text completion:(void (^)(void))completion;

- (void) showAppInAppStoreWithId:(NSString*)appId;

- (void) openInSafari:(NSURL*)url;
@end
