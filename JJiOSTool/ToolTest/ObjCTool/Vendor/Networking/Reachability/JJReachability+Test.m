//
//  JJReachability+Test.m
//  JJObjCTool
//
//  Created by JJ on 5/22/15.
//  Copyright (c) 2015 gongjian. All rights reserved.
//

#import "JJReachability+Test.h"

#import "JJReachability.h"

void jjReachabilityTest()
{
    JJReachability *curReach = [JJReachability reachabilityForInternetConnection];
    NetworkStatus status = [curReach currentReachabilityStatus];
    
    switch (status)
    {
        case NotReachable:
            break;
            
        case ReachableViaWiFi:
        case ReachableViaWWAN:
            break;
    }
    
    if (status == JJReachableVia2G)
    {
        NSLog(@"2G");
    }
    else if (status == JJReachableVia3G)
    {
        NSLog(@"3G");
    }
    else if (status == JJReachableVia4G)
    {
        NSLog(@"4G");
    }
}
