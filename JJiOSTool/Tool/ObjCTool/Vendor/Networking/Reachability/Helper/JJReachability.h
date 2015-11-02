//
//  JJReachability.h
//  JJObjCTool
//
//  Created by JJ on 5/22/15.
//  Copyright (c) 2015 gongjian. All rights reserved.
//

#import "Reachability.h"

extern const NSInteger JJReachableVia2G;
extern const NSInteger JJReachableVia3G;
extern const NSInteger JJReachableVia4G;

@interface JJReachability : Reachability

- (NSString*)currentReachabilityString;

- (BOOL)isReachable;
- (BOOL)isReachableViaWWAN;
- (BOOL)isReachableViaWiFi;

@end
