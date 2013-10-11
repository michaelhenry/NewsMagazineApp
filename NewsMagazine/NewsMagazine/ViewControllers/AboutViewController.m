//
//  AboutViewController.m
//  NewsMagazine
//
//  Created by Michael henry Pantaleon on 7/28/13.
//  Copyright (c) 2013 Michael Henry Pantaleon. All rights reserved.
//

#import "AboutViewController.h"
#import "FlipBoardNavigationController.h"
#import "WebBrowserViewController.h"
#import "MHNatGeoViewControllerTransition.h"
#import "SIAlertView.h"
@interface AboutViewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSArray * _aboutTitles;
    NSArray * _shareTitles;
    NSArray * _contactTitles;
}

@end

@implementation AboutViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _aboutTitles = @[@"About this Application",@"Credits",@"Version"];
    _shareTitles = @[@"Share via Facebook",@"Share via Twitter",@"Share via Email"];
    _contactTitles = @[@"Contact Us",@"Rate this Application"];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)dismiss:(UIButton *)sender {
    [self.flipboardNavigationController popViewController];
}

#pragma mark - UITableView Delegate and Datasource
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section==0){
        return [_aboutTitles count];
    } else if(section==1) {
        return [_shareTitles count];
    } else if(section==2) {
        return [_contactTitles count];
    }
    return 0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 25.0f;
}

- (UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"header_cell"];
    UILabel * label = (UILabel*)[cell viewWithTag:1];
    if(section==0){
        [label setText:@"ABOUT"];
    }else if(section==1) {
        [label setText:@"SHARE"];
    }else if(section==2) {
        [label setText:@"CONTACT"];
    }
    return cell;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"menu_cell"];
    UILabel * label = (UILabel*)[cell viewWithTag:1];
    UILabel * detail = (UILabel*)[cell viewWithTag:2];
    NSString * title;
    if(indexPath.section == 0) {
        title = [_aboutTitles objectAtIndex:indexPath.row];
    }else if(indexPath.section ==1) {
        title = [_shareTitles objectAtIndex:indexPath.row];
    }else if(indexPath.section ==2) {
        title = [_contactTitles objectAtIndex:indexPath.row];
    }
    [label setText:title];
    if([title isEqualToString:@"Version"]) {
        NSString *appVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
//        [[NSUserDefaults standardUserDefaults] setObject:appVersion forKey:@"currentVersionKey"];
        [detail setText:appVersion];
    }else {
        [detail setText:@""];
    }
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0) {
        if(indexPath.row == 0) {
            // About this App
             [self viewOnWeb:[NSURL URLWithString:[[NSBundle mainBundle]objectForInfoDictionaryKey:@"AboutLink"]]];
        }else if(indexPath.row == 1) {
            // Credits
            [self viewOnWeb:[NSURL URLWithString:[[NSBundle mainBundle]objectForInfoDictionaryKey:@"CreditsLink"]]];
        }
    } else if(indexPath.section == 1) {
        __weak NSURL * appStoreURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://itunes.apple.com/app/id%@",[[NSBundle mainBundle]objectForInfoDictionaryKey:@"AppStoreID"]]];
        if(indexPath.row == 0) {
            // Share via Facebook
            [self postToFacebook:@"" url:appStoreURL image:nil completion:^(BOOL success, NSString *message) {
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
        }else if(indexPath.row == 1) {
            // Share via Twitter
            [self postToTwitter:@"" url:appStoreURL image:nil completion:^(BOOL success, NSString *message) {
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
        }else if(indexPath.row == 2) {
            // Share via Email
            [self composeEmail:@"Contact Us" body:[NSString stringWithFormat:@"\n\n%@",appStoreURL.absoluteString] isHTML:NO recipients:nil completion:nil];
        }
    }else if(indexPath.section == 2) {
        if(indexPath.row ==0) {
            // Contact Us
            [self composeEmail:@"Contact Us" body:@"" isHTML:NO recipients:@[[[NSBundle mainBundle]objectForInfoDictionaryKey:@"ContactUsEmail"]]  completion:nil];
        } else if(indexPath.row == 1)  {
            // Rate this App
            [self showAppInAppStoreWithId:[[NSBundle mainBundle]objectForInfoDictionaryKey:@"AppStoreID"]];
        }
    }
}

- (void) viewOnWeb:(NSURL*) url{
    WebBrowserViewController * webBrowserVC = [self.storyboard instantiateViewControllerWithIdentifier:@"web_vc"];
    webBrowserVC.url = url;
    [self.flipboardNavigationController presentNatGeoViewController:webBrowserVC];
    webBrowserVC = nil;
}

@end
