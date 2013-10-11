//
//  BaseContentViewController.m
//  NewsMagazine
//
//  Created by Michael henry Pantaleon on 7/21/13.
//  Copyright (c) 2013 Michael Henry Pantaleon. All rights reserved.
//

#import "BaseContentViewController.h"

@interface BaseContentViewController ()

@end

@implementation BaseContentViewController
@synthesize delegate;
@synthesize navTitle = _navTitle;
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
    [self.navTitleLabel setText:[_navTitle uppercaseString]];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)didTapMenu:(UIButton *)sender {
    if(self.delegate)
        [self.delegate didTapMenu];
}

- (IBAction)didTapSearch:(UIButton *)sender {
    if(self.delegate)
        [self.delegate didTapSearch];
}

- (void) viewDidUnload {
    [self setNavTitleLabel:nil];
    [super viewDidUnload];
}

- (void) setNavTitle:(NSString *)navTitle {
    _navTitle = navTitle;
    if(self.navTitleLabel) {
        [self.navTitleLabel setText: [navTitle uppercaseString]];
    }
}
@end
