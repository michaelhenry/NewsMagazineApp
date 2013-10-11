//
//  AppDelegate.h
//  NewsMagazine
//
//  Created by Michael henry Pantaleon on 4/27/13.
//  Copyright (c) 2013 Michael Henry Pantaleon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlipBoardNavigationController.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) FlipBoardNavigationController * flipBoardNVC;
@property (strong, nonatomic) UIViewController * mainVC;
- (NSString *)storyboardName;
@end
