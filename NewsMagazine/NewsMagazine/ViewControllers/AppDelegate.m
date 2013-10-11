//
//  AppDelegate.m
//  NewsMagazine
//
//  Created by Michael henry Pantaleon on 4/27/13.
//  Copyright (c) 2013 Michael Henry Pantaleon. All rights reserved.
//

#import "AppDelegate.h"
#import "SDURLCache.h"


@implementation AppDelegate
@synthesize flipBoardNVC;
@synthesize mainVC;
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [MagicalRecord setupCoreDataStackWithStoreNamed:@"NewsMagazine.sqlite"];
    
    SDURLCache *urlCache = [[SDURLCache alloc] initWithMemoryCapacity:1024*1024*4   // 1MB mem cache
        diskCapacity:1024*1024*32 // 5MB disk cache
        diskPath:[SDURLCache defaultCachePath]];
    
    [NSURLCache setSharedURLCache:urlCache];

    UIStoryboard * storyboard=[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    self.mainVC = [storyboard instantiateViewControllerWithIdentifier:@"main_vc"];
   
    self.flipBoardNVC = [[FlipBoardNavigationController alloc]initWithRootViewController:self.mainVC];
    self.window.rootViewController = self.flipBoardNVC;
   
    
    [self.window makeKeyAndVisible];
    storyboard = nil;
    self.flipBoardNVC = nil;
    // Override point for customization after application launch.
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
     [MagicalRecord cleanUp];
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (NSString *)storyboardName
{
	return @"MainStoryboard";
	
}

@end
