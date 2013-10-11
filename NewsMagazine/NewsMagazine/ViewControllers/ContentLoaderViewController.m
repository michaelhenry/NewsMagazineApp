//
//  ContentLoaderViewController.m
//  NewsMagazine
//
//  Created by Michael henry Pantaleon on 7/26/13.
//  Copyright (c) 2013 Michael Henry Pantaleon. All rights reserved.
//

#import "ContentLoaderViewController.h"
#import "MHProgressView.h"
#import "IOSMacroFunctionHelper.h"
@interface ContentLoaderViewController ()
{
    CGFloat navHeight;
    MHProgressView * _progressView;
}
@end

@implementation ContentLoaderViewController
@synthesize progress = _progress;
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
    if(!_progressView) {
        _progressView = [[MHProgressView alloc]initWithFrame:CGRectMake(0.0f, navHeight, 320.0f, self.view.frame.size.height-navHeight)];
    }
    [self.view addSubview:_progressView];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setProgress:(CGFloat)progress {
    _progress = progress;
    [_progressView setProgress:progress];
}

- (void) reset {
    [_progressView reset];
}

@end
