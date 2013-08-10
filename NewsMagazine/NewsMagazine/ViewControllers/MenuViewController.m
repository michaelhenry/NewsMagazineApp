//
//  MenuViewController.m
//  NewsMagazine
//
//  Created by Michael henry Pantaleon on 7/10/13.
//  Copyright (c) 2013 Michael Henry Pantaleon. All rights reserved.
//

#import "MenuViewController.h"
#import "FlipBoardNavigationController.h"
#import "AFNetworking.h"
#import "MHHelper.h"

@interface MenuViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) NSArray * list;
@end

@implementation MenuViewController
@synthesize list = _list;
@synthesize delegate = _delegate;
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
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:[[NSBundle mainBundle]objectForInfoDictionaryKey:@"MenuAPI"]]];
    NSData * menuData = [MHHelper retrieveDataFromCache:request.URL.absoluteString expiration:60*60*24*1];
    if(menuData) {
        _list = [NSJSONSerialization JSONObjectWithData:menuData options:NSJSONReadingAllowFragments error:nil];
        return;
    }
    AFJSONRequestOperation * operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        _list = JSON;
        [self.tableView reloadData];
        NSData * listData = [NSJSONSerialization dataWithJSONObject:JSON options:NSJSONWritingPrettyPrinted error:nil];
        [MHHelper saveDataToCache:request.URL.absoluteString value:listData];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
       
    }];
    [operation start];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTableView:nil];
  
    [super viewDidUnload];
}

#pragma mark - UITableView Delegate and Datasource
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return [_list count];
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[_list objectAtIndex:section]objectForKey:@"list"]count];
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 25.0f;
}

- (UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"header_cell"];
    UILabel * label = (UILabel*)[cell viewWithTag:1];
    [label setText:[[[_list objectAtIndex:section]objectForKey:@"text"]uppercaseString]];
    return cell;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"menu_cell"];
    UILabel * label = (UILabel*)[cell viewWithTag:1];
    NSDictionary * row = [[[_list objectAtIndex:indexPath.section]objectForKey:@"list"]objectAtIndex:indexPath.row];
    [label setText:[[row objectForKey:@"text"]uppercaseString]];
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.flipboardNavigationController popViewControllerWithCompletion:^{
        if(_delegate) {
            NSDictionary * row = [_list objectAtIndex:indexPath.section];
            [_delegate didSelectMenuItem:[[row objectForKey:@"list"]objectAtIndex:indexPath.row] valueType:[row objectForKey:@"value"]];
     
        }
    }];
}
- (IBAction)didClose:(UIButton *)sender {
    [self.flipboardNavigationController popViewController];
}

- (IBAction)didShowAbout:(UIButton *)sender {
    UIViewController * aboutVC = [self.storyboard instantiateViewControllerWithIdentifier:@"about_vc"];
    [self.flipboardNavigationController pushViewController:aboutVC];
    aboutVC = nil;
}

@end
