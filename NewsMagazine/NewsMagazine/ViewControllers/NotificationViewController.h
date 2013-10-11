//
//  NotificationViewController.h
//  NewsMagazine
//
//  Created by Michael henry Pantaleon on 7/28/13.
//  Copyright (c) 2013 Michael Henry Pantaleon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseContentViewController.h"
@interface NotificationViewController : BaseContentViewController
@property (weak, nonatomic) IBOutlet UILabel *notificationLabel;
@property (nonatomic,strong) NSString * notificationText;
@end
