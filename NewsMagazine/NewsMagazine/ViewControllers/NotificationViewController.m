//
//  NotificationViewController.m
//  NewsMagazine
//
//  Created by Michael henry Pantaleon on 7/28/13.
//  Copyright (c) 2013 Michael Henry Pantaleon. All rights reserved.
//

#import "NotificationViewController.h"

@interface NotificationViewController ()

@end

@implementation NotificationViewController
@synthesize notificationText = _notificationText;
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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setNotificationLabel:nil];
    [super viewDidUnload];
}

- (void) setNotificationText:(NSString *)notificationText {
    _notificationText = notificationText;
    if(self.notificationLabel) {
        [self.notificationLabel setText:notificationText];
    }
}
@end
