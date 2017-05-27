//
//  JJBootupChecker.h
//
//
//  Created by gongjian on 9/22/14.
//  All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define kJJPrefixStringTimesVersionHasBooted          @"timesHasBootedForVersion"

@interface JJBootupChecker : NSObject

+ (NSString *)currentVersion;

+ (BOOL)isFirstBootOfCurrentVersion;
+ (BOOL)isSecondBootOfCurrentVersion;
+ (NSUInteger)timesBootedOfCurrentVersion;

+ (NSUInteger)timesBootedOfVersion:(NSString *)version;
+ (BOOL)hasBootedForVersion:(NSString *)version;

@end
