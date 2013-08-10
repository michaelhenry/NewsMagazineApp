//
//  MHHelper.m
//  NewsMagazine
//
//  Created by Michael henry Pantaleon on 5/27/13.
//  Copyright (c) 2013 Michael Henry Pantaleon. All rights reserved.
//

#import "MHHelper.h"
#import "Reachability.h"
@implementation MHHelper

+ (NSString*) getRelativeTimeWithUnixTime:(NSTimeInterval)unixTime {

    NSDate *date = [NSDate dateWithTimeIntervalSince1970:unixTime];
    NSInteger iDate = abs([date timeIntervalSinceNow]);
    
    const int SECOND = 1;
    const int MINUTE = 60 * SECOND;
    const int HOUR = 60 * MINUTE;
    const int DAY = 24 * HOUR;
   
    if (iDate <= 0)
    {
        return @"";
    }
    else if (iDate == 1) {
        return @"1s ago";
    }
    else if (iDate < 1 * MINUTE)
    {
        return [NSString stringWithFormat:@"%is ago",iDate];
    }
    if (iDate < 2 * MINUTE)
    {
        return @"1m ago";
    }
    if (iDate < 1 * HOUR)
    {
        return  [NSString stringWithFormat:@"%im ago",iDate/MINUTE ];
    }
    if (iDate < 2 * HOUR)
    {
        return @"1h ago";
    }
    if (iDate < 24 * HOUR)
    {
        return [NSString stringWithFormat:@"%ih ago",iDate/HOUR ];
    }
    if (iDate < 48 * HOUR)
    {
        return @"1d ago";
    }
    if (iDate < 30 * DAY)
    {
        return [NSString stringWithFormat:@"%id ago",iDate/DAY ];
    }
    else {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MMM dd, yyyy"];
        return [formatter stringFromDate:date];
    }
    
    return @"Error parsing date";
}


+ (BOOL) hasInternetConnection{
    Reachability * reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus remoteHostStatus = [reachability currentReachabilityStatus];
    if(!remoteHostStatus == NotReachable) {
        return  YES;
    }
    return NO;
}

#pragma mark - Cache handling
+ (NSData*) retrieveDataFromCache:(NSString*)key expiration:(NSInteger) expiration {
    @try {
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        NSDictionary * cacheData = [defaults objectForKey:[NSString stringWithFormat:@"Cache_%@",key]];
        NSLog(@"CACHE KEY IS %@",key);
        if(cacheData) {
            if(expiration <= 0) {
                return [cacheData objectForKey:@"data"];
            }
            
            if([MHHelper hasInternetConnection]){
                if(![cacheData objectForKey:@"date"] || [[cacheData objectForKey:@"date" ] timeIntervalSinceNow] < -expiration){
                    return nil;
                }else {
                    return [cacheData objectForKey:@"data"];
                }
            }else {
                return [cacheData objectForKey:@"data"];
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"ERROR AT DATA CACHE %@",exception);
    }
    
    return nil;
}

+ (void) saveDataToCache:(NSString*) key value:(NSData*)value {
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSDictionary dictionaryWithObjectsAndKeys:value,@"data",[NSDate date],@"date", nil] forKey:[NSString stringWithFormat:@"Cache_%@",key]];
    [defaults synchronize];
}
@end
