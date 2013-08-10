//
//  MenuViewController.h
//  NewsMagazine
//
//  Created by Michael henry Pantaleon on 7/10/13.
//  Copyright (c) 2013 Michael Henry Pantaleon. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MenuViewControllerDelegate <NSObject>
@required
- (void) didSelectMenuItem:(NSDictionary*)menuItem valueType:(NSString*)valueType;

@end

@interface MenuViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,assign) id<MenuViewControllerDelegate> delegate;
- (IBAction)didClose:(UIButton *)sender;
- (IBAction)didShowAbout:(UIButton *)sender;
@end
