//
//  ContentLoaderViewController.h
//  NewsMagazine
//
//  Created by Michael henry Pantaleon on 7/26/13.
//  Copyright (c) 2013 Michael Henry Pantaleon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseContentViewController.h"

@interface ContentLoaderViewController : BaseContentViewController

@property(nonatomic,assign) CGFloat progress;
-(void) reset;
@end
