//
//  DoubleContentViewController.m
//  NewsMagazine
//
//  Created by Michael henry Pantaleon on 4/29/13.
//  Copyright (c) 2013 Michael Henry Pantaleon. All rights reserved.
//

#import "DoubleContentViewController.h"
#import "NSString+HTML.h"
#import "UIImageView+AFNetworking.h"
#import "MHHelper.h"
#import "IOSMacroFunctionHelper.h"

@interface DoubleContentViewController (){
    CGFloat navHeight;
}
- (void) layotLabels;
@end

@implementation DoubleContentViewController
@synthesize articles;
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
    NSDictionary * article1 = [self.articles objectAtIndex:0];
    NSDictionary * source1 = [article1 objectForKey:@"source"];
    [self.pubdateLabel1 setText:[MHHelper getRelativeTimeWithUnixTime:[[article1 objectForKey:@"pubdate"]doubleValue] ]];
    [self.firstSourceImage setImageWithURL:[NSURL URLWithString:[source1 objectForKey:@"thumbnail"]]];
    [self.firstSourceLabel setText:[source1 objectForKey:@"name"]];
    [self.firstTitle setText:[[[article1 objectForKey:@"title"]stringByDecodingHTMLEntities]stringByDecodingHTMLEntities]];
    [self.firstBody setText:[[[[article1 objectForKey:@"body"]stringByDecodingHTMLEntities]stringByDecodingHTMLEntities]stringByReplacingOccurrencesOfString:@"\n" withString:@"\n\n"]];
    NSDictionary * article2 = [self.articles objectAtIndex:1];
     NSDictionary * source2 = [article2 objectForKey:@"source"];
    [self.pubdateLabel2 setText:[MHHelper getRelativeTimeWithUnixTime:[[article2 objectForKey:@"pubdate"]doubleValue] ]];
    [self.secondSourceImage setImageWithURL:[NSURL URLWithString:[source2 objectForKey:@"thumbnail"]]];
    [self.secondSourceLabel setText:[source2 objectForKey:@"name"]];
    [self.secondTitle setText:[[[article2 objectForKey:@"title"]stringByDecodingHTMLEntities]stringByDecodingHTMLEntities]];
    [self.secondBody setText:[[[[article2 objectForKey:@"body"]stringByDecodingHTMLEntities]stringByDecodingHTMLEntities]stringByReplacingOccurrencesOfString:@"\n" withString:@"\n\n"]];
    [self layotLabels];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setFirstTitle:nil];
    [self setFirstBody:nil];
    [self setSecondTitle:nil];
    [self setSecondBody:nil];
    [self setFirstSourceImage:nil];
    [self setFirstSourceLabel:nil];
    [self setSecondSourceImage:nil];
    [self setSecondSourceLabel:nil];
    [self setFirstSourceContainer:nil];
    [self setSecondSourceContainer:nil];
    [self setContainer1:nil];
    [self setContainer2:nil];
    [super viewDidUnload];
}

- (void) layotLabels {
    CGFloat totalContainer = (self.view.frame.size.height - navHeight)/2 ;
    CGFloat totalY = 5.0f;
    CGFloat footerHeight = 60.0f;
    self.container1.frame = CGRectMake(0, navHeight, 320.0f, totalContainer);
    self.firstTitle.frame = CGRectMake(10.0f, totalY, 300, 0);
    [self.firstTitle sizeToFit];
    totalY = totalY + self.firstTitle.frame.size.height;
    self.firstBody.frame = CGRectMake(10.0f, totalY, 300, totalContainer-self.firstTitle.frame.size.height-footerHeight);
    totalY = totalY + self.firstBody.frame.size.height;
    totalY = 5.0f;
    self.container2.frame = CGRectMake(0, navHeight + totalContainer, 320.0f, totalContainer);
    self.secondTitle.frame = CGRectMake(10.0f, totalY, 300, 0);
    [self.secondTitle sizeToFit];
    totalY = totalY + self.secondTitle.frame.size.height ;
    self.secondBody.frame = CGRectMake(10.0f, totalY, 300,totalContainer-self.secondTitle.frame.size.height-footerHeight);
    totalY = totalY + self.secondBody.frame.size.height;
    
}

- (IBAction)didTapArticle:(UIButton *)sender {
    if(self.delegate)
        [self.delegate didTapArticle:[self.articles objectAtIndex:sender.tag]];
}



@end
