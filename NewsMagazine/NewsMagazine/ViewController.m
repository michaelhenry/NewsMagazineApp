//
//  ViewController.m
//  NewsMagazine
//
//  Created by Michael henry Pantaleon on 4/27/13.
//  Copyright (c) 2013 Michael Henry Pantaleon. All rights reserved.
//

#import "ViewController.h"
#import "AFJSONRequestOperation.h"
#import "UIImageView+AFNetworking.h"
#import "MPFlipViewController.h"
#import "MPFlipTransition.h"
#import "DetailViewController.h"
#import "MenuViewController.h"
#import "ContentViewController.h"
#import "DoubleContentViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "FlipBoardNavigationController.h"
#import "AFHTTPClient.h"
#import "MHProgressView.h"
#import "ContentLoaderViewController.h"
#import "NotificationViewController.h"
#import "IOSMacroFunctionHelper.h"
@interface ViewController ()<MPFlipViewControllerDataSource,MPFlipViewControllerDelegate,ContentViewControllerDelegate,UITextFieldDelegate,MenuViewControllerDelegate>{
    NSInteger _currentPageBatch;
    NSInteger _maxArticleId;
    
    BOOL _isUpdating;
    BOOL _hasNextpage;
    CGFloat navHeight;
    BOOL _isSearchIsVisible;
    
    NSDictionary * _extraParams;
    NSString * _navTitle;
 
    ContentLoaderViewController * _contentLoaderViewController;
    NotificationViewController * _notificationViewController;
    
}
@property (strong, nonatomic) MPFlipViewController *flipViewController;
@property (nonatomic,strong) NSMutableArray * rawList;
@property (nonatomic,strong) NSMutableArray * list;
@property (assign, nonatomic) BOOL observerAdded;

@property (assign, nonatomic) int previousIndex;
@property (assign, nonatomic) int tentativeIndex;

- (void) manageRawList:(NSMutableArray*) results;
- (NSDictionary*) dataWithType:(NSString*)type data:(id)data;
@end

@implementation ViewController
@synthesize flipViewController;
@synthesize list;
@synthesize rawList = _rawList;


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.blackMask removeFromSuperview];
    [self setupSearch];
    
    _navTitle = @"LATEST";
    self.previousIndex = 0;
    _currentPageBatch = 1;
    
    if(!self.flipViewController && !self.flipViewController.view.superview){
        self.flipViewController = [[MPFlipViewController alloc] initWithOrientation:[self flipViewController:nil orientationForInterfaceOrientation:[UIApplication sharedApplication].statusBarOrientation]];
        
        self.flipViewController.delegate = self;
        self.flipViewController.dataSource = self;
        self.flipViewController.view.backgroundColor = [UIColor blackColor];
        self.flipViewController.view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
//        [self.pageContainer addSubview:self.flipViewController.view];
        [self addChildViewController:self.flipViewController];
        [self.flipViewController didMoveToParentViewController:self];
        [self.flipViewController reloadInputViews];
        
        self.flipViewController.view.frame = CGRectMake(0.0f, 0.0f, self.pageContainer.frame.size.width, self.pageContainer.frame.size.height);
        [self addObserver];
    }
    
    _contentLoaderViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"content_loader_vc"];
    _contentLoaderViewController.navTitle = _navTitle;
    _contentLoaderViewController.view.frame = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
    _contentLoaderViewController.delegate = self;
    [self.pageContainer addSubview:_contentLoaderViewController.view];
    
    [self fetchArticles:ArticleFetchTypeNormal];
    
    _notificationViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"notification_vc"];
    _notificationViewController.delegate =self;
    _notificationViewController.view.frame = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
    // Configure the page view controller and add it as a child view controller.
    
    
}

#pragma mark - Fetch the Required Articles
- (void) fetchArticles:(ArticleFetchType)type {
    NSLog(@"FETCH ARTICLE %i",_isUpdating);
    if(_isUpdating)return;
    _isUpdating = YES;
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSURL *url = [NSURL URLWithString:@"http://newsmagazineapp.com/api.json"];
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:url];
    NSMutableDictionary * parameters = [[NSMutableDictionary alloc]init];
    [parameters addEntriesFromDictionary:@{@"page":[NSString stringWithFormat:@"%i",_currentPageBatch]}];
    if(_maxArticleId) {
        [parameters addEntriesFromDictionary:@{@"max_id":[NSString stringWithFormat:@"%i",_maxArticleId]}];
    }
    if(_extraParams) {
        [parameters addEntriesFromDictionary:_extraParams];
    }
    if(type == ArticleFetchTypeSearch) {
        [parameters addEntriesFromDictionary:@{@"searchkey":self.searchTextField.text }];
    }
    
    if(type== ArticleFetchTypeUpdate && _maxArticleId > 0) {
        [parameters addEntriesFromDictionary:@{@"since":[NSString stringWithFormat:@"%i",_maxArticleId]}];
    }
    
    [parameters addEntriesFromDictionary:@{@"limit":@"30"}];
    NSURLRequest *request = [client requestWithMethod:@"GET" path:nil parameters:parameters];
    
    AFJSONRequestOperation * _operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        _hasNextpage = [[JSON objectForKey:@"has_next_page"]boolValue];
        _maxArticleId =  [[JSON objectForKey:@"max_id"]intValue];
        _rawList = [NSMutableArray arrayWithArray:[JSON objectForKey:@"results"]];
        if(JSON && _rawList){
            [self manageRawList:_rawList];
            if(!self.flipViewController.view.superview){
                [self.pageContainer addSubview:self.flipViewController.view];
            }
            [self.flipViewController setViewController:[self contentViewWithIndex:self.tentativeIndex] direction:MPFlipViewControllerDirectionForward animated:NO completion:nil];
        }        
        if(_contentLoaderViewController.view.superview){
            [_contentLoaderViewController.view removeFromSuperview];
        }
        _isUpdating = NO;
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"FAILED %@",request.URL.absoluteString);
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        if(!_notificationViewController.view.superview) {
             _notificationViewController.navTitle = _navTitle;
            [self.pageContainer addSubview:_notificationViewController.view];
           
        }
        if(_contentLoaderViewController.view.superview)[_contentLoaderViewController.view removeFromSuperview];
        _isUpdating = NO;
        if(self.list.count == 0) {
            [self.flipViewController.viewController.view removeFromSuperview];
        }
    }];
    
    __weak AFHTTPRequestOperation *_operationInsideBlock = _operation;
    __weak ContentLoaderViewController * _contentLoaderViewControllerInsideBlock = _contentLoaderViewController;
    [_operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        NSHTTPURLResponse *response = (NSHTTPURLResponse*)_operationInsideBlock.response;
        NSString *contentLength = [[response allHeaderFields] objectForKey:@"Content-Length"];
        if (contentLength != nil){
            totalBytesExpectedToRead = [contentLength doubleValue];
        }
        
        CGFloat downloadProgress =(float) totalBytesRead/totalBytesExpectedToRead;
        [_contentLoaderViewControllerInsideBlock setProgress: downloadProgress];
        
    }];
    [_operation start];
    _operation = nil;
    
    
}

- (void)viewDidUnload
{
	[self removeObserver];
    [self setFlipViewController:nil];
    [self setSearchTextField:nil];
    [self setSearchContainer:nil];
    [self setBlackMask:nil];
    [self setPageContainer:nil];
    [super viewDidUnload];
    
	
    // Release any retained subviews of the main view.
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - MPFlipViewControllerDelegate
- (void) flipViewController:(MPFlipViewController *)flipViewController didFinishAnimating:(BOOL)finished previousViewController:(UIViewController *)previousViewController transitionCompleted:(BOOL)completed {
    if (completed)
	{
		self.previousIndex = self.tentativeIndex;
	}
    
}

- (MPFlipViewControllerOrientation)flipViewController:(MPFlipViewController *)flipViewController orientationForInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    return MPFlipViewControllerOrientationHorizontal;
}

#pragma mark - MPFlipViewControllerDataSource protocol

- (UIViewController *)flipViewController:(MPFlipViewController *)flipViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    if(!self.list || self.list.count == 0)return nil ;
    int index = self.previousIndex;
	index--;
	if (index < 0) {
        NSLog(@"FIRST LOAD");
        return nil;
    }
    // reached beginning, don't wrap
	self.tentativeIndex = index;
	return [self contentViewWithIndex:index];
}

- (UIViewController *)flipViewController:(MPFlipViewController *)flipViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    if(!self.list || self.list.count == 0)return nil ;
    int index = self.previousIndex;
    NSLog(@"PAGE: %i- %i",index,self.list.count-1);
    if(index >= self.list.count - 1) {
        NSLog(@"HASNEXTPAGE %i - ISUPDATING %i",_hasNextpage,_isUpdating);
        if(!_isUpdating){
            
            if(_hasNextpage){
                _currentPageBatch++;
                [self fetchArticles:ArticleFetchTypeNormal];
                _isUpdating = YES;
            }
            
        }
        return nil;
    }
	index++;
	self.tentativeIndex = index;
	return [self contentViewWithIndex:index];
}

#pragma mark - Notifications

- (void)flipViewControllerDidFinishAnimatingNotification:(NSNotification *)notification
{
	NSLog(@"Notification received: %@", notification);
}


- (void)addObserver
{
	if (![self observerAdded])
	{
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(flipViewControllerDidFinishAnimatingNotification:) name:MPFlipViewControllerDidFinishAnimatingNotification object:nil];
		[self setObserverAdded:YES];
	}
}

- (void)removeObserver
{
	if ([self observerAdded])
	{
		[[NSNotificationCenter defaultCenter] removeObserver:self name:MPFlipViewControllerDidFinishAnimatingNotification object:nil];
		[self setObserverAdded:NO];
	}
}

- (UIViewController *)contentViewWithIndex:(int)index
{
    NSLog(@"CONTENT IS %i",index);
    NSDictionary * row = [self.list objectAtIndex:index];
    if([[row objectForKey:@"type"]isEqualToString:@"single"]){
        ContentViewController *page = [self.storyboard instantiateViewControllerWithIdentifier:@"content_vc"];
        page.article = [row objectForKey:@"data"];
        page.delegate = self;
        page.navTitle = _navTitle;
        page.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        return page;
    } else if([[row objectForKey:@"type"]isEqualToString:@"double"]){
        DoubleContentViewController *page = [self.storyboard instantiateViewControllerWithIdentifier:@"double_vc"];
        page.delegate =self;
        page.navTitle = _navTitle;
        page.articles = [row objectForKey:@"data"];
        
        page.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        return page;
        
    }
	return [[UIViewController alloc]init];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	if ([self flipViewController])
		return [[self flipViewController] shouldAutorotateToInterfaceOrientation:interfaceOrientation];
	else
		return YES;
}

#pragma mark =  Manage What view is needed
- (void) manageRawList:(NSMutableArray*) results{
    if(!self.list)
        self.list = [[NSMutableArray alloc]init];
    while ([results count]>0) {
        NSInteger randomType = arc4random() % 2;
        if(randomType==0){
            NSDictionary * article = [results objectAtIndex:0];
            [_rawList removeObject:article];
            [self.list addObject:[self dataWithType:@"single" data:article]];
            [results removeObject:article];
        }else if(randomType==1) {
            if([results count]>1){
                NSMutableArray * tempArticles = [[NSMutableArray alloc]initWithCapacity:2];
                NSDictionary * article1 = [results objectAtIndex:0];
                if([[article1 objectForKey:@"images"]count]==0) {
                    [_rawList removeObject:article1];
                    [tempArticles addObject:article1];
                    
                    NSDictionary * article2 = [results objectAtIndex:0];
                    if([[article2 objectForKey:@"images"]count]==0) {
                        [_rawList removeObject:article2];
                        [tempArticles addObject:article2];
                    }
                    
                    if([tempArticles count]==2) {
                        [self.list addObject:[self dataWithType:@"double" data:tempArticles]];
                    }else {
                        [_rawList removeObject:article1];
                        [self.list addObject:[self dataWithType:@"single" data:article1]];
                        [results removeObject:article1];
                    }
                    tempArticles = nil;
                } else {
                    NSDictionary * article = [results objectAtIndex:0];
                    [_rawList removeObject:article];
                    [self.list addObject:[self dataWithType:@"single" data:article]];
                    [results removeObject:article];
                }
                
            }
        }
    }
}

- (NSDictionary*) dataWithType:(NSString*)type data:(id)data {
    return [NSDictionary dictionaryWithObjectsAndKeys:type,@"type",data,@"data", nil];
}

- (void) didTapArticle:(NSDictionary *)article {
    DetailViewController *page = [self.storyboard instantiateViewControllerWithIdentifier:@"detail_vc"];
    page.article = article;
    page.navTitle = [_navTitle uppercaseString];
    [self.flipboardNavigationController pushViewController:page];
}

- (void) didTapMenu {
    MenuViewController * menuVC = [self.storyboard instantiateViewControllerWithIdentifier:@"menu_vc"];
    menuVC.delegate = self;
    [self.flipboardNavigationController pushViewController:menuVC];
    menuVC = nil;
}

- (void) dealloc {
    _rawList = nil;
}

#pragma mark - Setup Search Function
- (void) setupSearch {
    CGRect searchFrame = self.searchContainer.frame;
    if ( SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        navHeight = 64.0f;
    }else  {
        navHeight = 44.0f;
    }
    
    searchFrame.origin.y = searchFrame.origin.y - navHeight;
    self.searchContainer.frame = searchFrame;
    [self.searchContainer removeFromSuperview];
    self.searchTextField.returnKeyType = UIReturnKeySearch;
    
    [self.searchTextField setBorderStyle:UITextBorderStyleNone];
    self.searchTextField.layer.cornerRadius = 5.0;
    self.searchTextField.layer.borderWidth = 1.0f;
    self.searchTextField.layer.borderColor = [[UIColor lightGrayColor]colorWithAlphaComponent:0.5].CGColor;
    self.searchTextField.layer.masksToBounds = YES;
    
    UIImageView * searchImageViewForTextField = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_search_text"]];
    searchImageViewForTextField.alpha = 0.5;
    self.searchTextField.leftView = searchImageViewForTextField;
    self.searchTextField.leftViewMode = UITextFieldViewModeAlways;
    UIView * rightView = [[UIView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 30.0f, 21.0f)];
    
    UIButton * clearTextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [clearTextButton addTarget:self action:@selector(didClearSearchText:) forControlEvents:UIControlEventTouchUpInside];
    [clearTextButton setImage:[UIImage imageNamed:@"icon_search_clear_button"] forState:UIControlStateNormal];
    [clearTextButton setImage:[UIImage imageNamed:@"icon_search_clear_button_selected"] forState:UIControlStateHighlighted];
    clearTextButton.frame = CGRectMake(5.0f, 0.0f, 20.0f, 20.0f);
    clearTextButton.layer.cornerRadius = 10.0f;
    clearTextButton.layer.masksToBounds = YES;
    [rightView addSubview:clearTextButton];
    self.searchTextField.rightView = rightView;
    self.searchTextField.rightViewMode = UITextFieldViewModeNever;
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(textChanged:)
     name:UITextFieldTextDidChangeNotification
     object:self.searchTextField];

}

- (void) textChanged:(NSNotification *)notification {
    UITextField * textField = (UITextField*)notification.object;
    if (textField.text.length == 0) {
        textField.rightViewMode = UITextFieldViewModeNever;
    }else{
        textField.rightViewMode = UITextFieldViewModeAlways;
    }
}

- (void) didClearSearchText:(id)sender {
     self.searchTextField.rightViewMode = UITextFieldViewModeNever;
    [self.searchTextField setText:@""];
}

- (void)didTapSearchWithCompletion:(void(^)(void))completion {
    if(self.searchContainer.superview) {
        [self.searchTextField resignFirstResponder];
        [UIView animateWithDuration:0.2f animations:^{
            self.searchContainer.frame = CGRectMake(0.0f, -navHeight, 320.0f, navHeight);
            self.blackMask.alpha = 0.0f;
        } completion:^(BOOL finished) {
            [self.searchContainer removeFromSuperview];
            [self.blackMask removeFromSuperview];
            _isSearchIsVisible = NO;
            if(completion)
                completion();
        }];
    }else {
        [self.view addSubview:self.blackMask];
        [self.view addSubview:self.searchContainer];
        self.blackMask.alpha = 0.0f;
        [self.searchTextField becomeFirstResponder];
        
        [UIView animateWithDuration:0.2f animations:^{
            self.searchContainer.frame = CGRectMake(0.0f, 0.0f, 320.0f, navHeight);
            self.blackMask.alpha = 0.7f;
        } completion:^(BOOL finished) {
            _isSearchIsVisible = YES;
        }];
    }
}

- (void)didTapSearch{
    [self didTapSearchWithCompletion:nil];
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [self didTapSearchWithCompletion:^{
        self.previousIndex = 0;
        _maxArticleId = 0;
        _navTitle = [self.searchTextField.text uppercaseString];
        _isUpdating = NO;
        
        if(self.flipViewController.viewController.view.superview) [self.flipViewController.view removeFromSuperview];
        
        if(_notificationViewController.view.superview) [_notificationViewController.view removeFromSuperview];
        
        _contentLoaderViewController.navTitle = _navTitle;
        [_contentLoaderViewController reset];
        [self.pageContainer addSubview:_contentLoaderViewController.view];
    
        [self.list removeAllObjects];
        [self.flipViewController reloadInputViews];
        _currentPageBatch = 1;
        self.tentativeIndex = 0;
        [self fetchArticles:ArticleFetchTypeSearch];
    }];
    return YES;
}

- (IBAction)cancelSearch:(UIButton *)sender {
    [self didTapSearch];
}

#pragma mark - Menu Handling
- (void) didSelectMenuItem:(NSDictionary *)menuItem valueType:(NSString *)valueType {
    _extraParams = @{valueType: [menuItem objectForKey:@"value"]};
    self.previousIndex = 0;
    _maxArticleId = 0;
    _navTitle = [menuItem objectForKey:@"text"];
    _isUpdating = NO;
    self.tentativeIndex = 0;
   
    if(self.flipViewController.viewController.view.superview) [self.flipViewController.view removeFromSuperview];
    
    if(_notificationViewController.view.superview) [_notificationViewController.view removeFromSuperview];
    
    if(!_contentLoaderViewController.view.superview){
        _contentLoaderViewController.navTitle = _navTitle;
        [_contentLoaderViewController reset];
        [self.pageContainer addSubview:_contentLoaderViewController.view];
    }
    
    [self.list removeAllObjects];
    _currentPageBatch = 1;
    [self fetchArticles:ArticleFetchTypeNormal];
}


@end
