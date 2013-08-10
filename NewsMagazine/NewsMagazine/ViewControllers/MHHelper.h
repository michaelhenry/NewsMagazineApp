//
//  MHHelper.h
//  NewsMagazine
//
//  Created by Michael henry Pantaleon on 5/27/13.
//  Copyright (c) 2013 Michael Henry Pantaleon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MHHelper : NSObject
+ (NSString*) getRelativeTimeWithUnixTime:(NSTimeInterval)unixTime;
+ (BOOL) hasInternetConnection;
+ (NSData*) retrieveDataFromCache:(NSString*)key expiration:(NSInteger) expiration;
+ (void) saveDataToCache:(NSString*) key value:(NSData*)value;
@end
