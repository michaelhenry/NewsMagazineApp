//
//  AboutViewController.h
//  NewsMagazine
//
//  Created by Michael henry Pantaleon on 7/28/13.
//  Copyright (c) 2013 Michael Henry Pantaleon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHUtilsViewController.h"
@interface AboutViewController : MHUtilsViewController
- (IBAction)dismiss:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
