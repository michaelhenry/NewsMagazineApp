//
//  BaseContentViewController.h
//  NewsMagazine
//
//  Created by Michael henry Pantaleon on 7/21/13.
//  Copyright (c) 2013 Michael Henry Pantaleon. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol ContentViewControllerDelegate <NSObject>
@required
- (void) didTapArticle:(NSDictionary*)article;
- (void) didTapMenu;
- (void) didTapSearch;

@end

@interface BaseContentViewController : UIViewController
@property (nonatomic,weak) id<ContentViewControllerDelegate> delegate;
@property (nonatomic,weak) IBOutlet UILabel * navTitleLabel;
@property (nonatomic,weak) NSString * navTitle;
@property (weak, nonatomic) IBOutlet UIView *menuBarContainer;


- (IBAction)didTapMenu:(UIButton *)sender;
- (IBAction)didTapSearch:(UIButton *)sender;

@end
