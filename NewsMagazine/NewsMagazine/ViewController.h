//
//  ViewController.h
//  NewsMagazine
//
//  Created by Michael henry Pantaleon on 4/27/13.
//  Copyright (c) 2013 Michael Henry Pantaleon. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum  {
    ArticleFetchTypeNormal = 0,
    ArticleFetchTypeUpdate = 1,
    ArticleFetchTypeSearch =2
} ArticleFetchType;

@interface ViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *searchTextField;
@property (strong, nonatomic) IBOutlet UIView *searchContainer;
@property (strong, nonatomic) IBOutlet UIView *blackMask;
@property (strong, nonatomic) IBOutlet UIView *pageContainer;
- (IBAction)cancelSearch:(UIButton *)sender;

@end
