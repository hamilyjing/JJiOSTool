//
//  JJReachability.m
//  JJObjCTool
//
//  Created by JJ on 5/22/15.
//  Copyright (c) 2015 gongjian. All rights reserved.
//

#import "JJReachability.h"

#import <UIKit/UIKit.h>
#import<CoreTelephony/CTTelephonyNetworkInfo.h>

const NSInteger JJReachableVia2G = 1000;
const NSInteger JJReachableVia3G = 1001;
const NSInteger JJReachableVia4G = 1002;

@implementation JJReachability

- (NetworkStatus)networkStatusForFlags:(SCNetworkReachabilityFlags)flags
{
    if ((flags & kSCNetworkReachabilityFlagsReachable) == 0)
    {
        // The target host is not reachable.
        return NotReachable;
    }
    
    NetworkStatus returnValue = NotReachable;
    
    if ((flags & kSCNetworkReachabilityFlagsConnectionRequired) == 0)
    {
        /*
         If the target host is reachable and no connection is required then we'll assume (for now) that you're on Wi-Fi...
         */
        returnValue = ReachableViaWiFi;
    }
    
    if ((((flags & kSCNetworkReachabilityFlagsConnectionOnDemand ) != 0) ||
         (flags & kSCNetworkReachabilityFlagsConnectionOnTraffic) != 0))
    {
        /*
         ... and the connection is on-demand (or on-traffic) if the calling application is using the CFSocketStream or higher APIs...
         */
        
        if ((flags & kSCNetworkReachabilityFlagsInterventionRequired) == 0)
        {
            /*
             ... and no [user] intervention is needed...
             */
            returnValue = ReachableViaWiFi;
        }
    }
    
    if ((flags & kSCNetworkReachabilityFlagsIsWWAN) == kSCNetworkReachabilityFlagsIsWWAN)
    {
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
        {
            
            CTTelephonyNetworkInfo * info = [[CTTelephonyNetworkInfo alloc] init];
            NSString *currentRadioAccessTechnology = info.currentRadioAccessTechnology;
            if (currentRadioAccessTechnology)
            {
                if ([currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyLTE])
                {
                    returnValue =  JJReachableVia4G;
                }
                else if ([currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyEdge] || [currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyGPRS])
                {
                    returnValue =  JJReachableVia2G;
                }
                else
                {
                    returnValue =  JJReachableVia3G;
                }
                return returnValue;
                
            }
        }
        
        if ((flags & kSCNetworkReachabilityFlagsTransientConnection) == kSCNetworkReachabilityFlagsTransientConnection)
        {
            if((flags & kSCNetworkReachabilityFlagsConnectionRequired) == kSCNetworkReachabilityFlagsConnectionRequired)
            {
                returnValue =  JJReachableVia2G;
                return returnValue;
            }
            returnValue =  JJReachableVia3G;
            return returnValue;
        }
        
        /*
         ... but WWAN connections are OK if the calling application is using the CFNetwork APIs.
         */
        returnValue = ReachableViaWWAN;
    }
    
    return returnValue;
}

- (BOOL)isReachable
{
    NetworkStatus temp = [self currentReachabilityStatus];
    return NotReachable == temp;
}

- (BOOL)isReachableViaWWAN
{
    NetworkStatus temp = [self currentReachabilityStatus];
    return ReachableViaWWAN == temp;
}

- (BOOL)isReachableViaWiFi
{
    NetworkStatus temp = [self currentReachabilityStatus];
    return ReachableViaWiFi == temp;
}

- (NSString*)currentReachabilityString
{
    NetworkStatus temp = [self currentReachabilityStatus];
    
    if(temp == ReachableViaWWAN)
    {
        // Updated for the fact that we have CDMA phones now!
        return NSLocalizedString(@"Cellular", @"");
    }
    
    if (temp == ReachableViaWiFi)
    {
        return NSLocalizedString(@"WiFi", @"");
    }
    
    if (temp == JJReachableVia2G)
    {
        return NSLocalizedString(@"2G", @"");
    }
    
    if (temp == JJReachableVia3G)
    {
        return NSLocalizedString(@"3G", @"");
    }
    
    if (temp == JJReachableVia4G)
    {
        return NSLocalizedString(@"4G", @"");
    }
    
    return NSLocalizedString(@"No Connection", @"");
}

@end
