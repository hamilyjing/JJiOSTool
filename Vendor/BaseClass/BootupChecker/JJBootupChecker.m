//
//  JJBootupChecker.m
//
//
//  Created by gongjian on 9/22/14.
//  All rights reserved.
//

#import "JJBootupChecker.h"

static NSString *currentVersion() {
    NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]; // CFBundleVersion
    return version;
}

static NSString *currentBundleIdentifier() {
    NSString *identifier = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"];
    return identifier;
}

static NSString *keyForVersion(NSString *prefix, NSString *version) {
    NSString *key = [NSString stringWithFormat:@"JJ_%@_%@_%@", prefix, version, currentBundleIdentifier()];
    return key;
}

@implementation JJBootupChecker

+ (void)initialize {
    [self timesBootedOfVersion:currentVersion()];
}

+ (NSString *)currentVersion {
    return currentVersion();
}

+ (NSUInteger)timesBootedOfVersion:(NSString *)version {
    __block NSInteger times = 0;
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *key = keyForVersion(kJJPrefixStringTimesVersionHasBooted, version);
    times = [userDefault integerForKey:key];
    
    NSString *curVersion = currentVersion();
    if ([curVersion isEqualToString:version]) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            times++;
            [userDefault setInteger:times forKey:key];
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [userDefault synchronize];
            });
        });
    }
    
    return times;
}

+ (NSUInteger)timesBootedOfCurrentVersion {
    NSUInteger times = [self timesBootedOfVersion:currentVersion()];
    return times;
}

+ (BOOL)isFirstBootOfCurrentVersion {
    NSUInteger times = [self timesBootedOfVersion:currentVersion()];
    BOOL isFirstBoot = times == 1;
    return isFirstBoot;
}

+ (BOOL)isSecondBootOfCurrentVersion {
    NSUInteger times = [self timesBootedOfVersion:currentVersion()];
    BOOL isSecondBoot = times == 2;
    return isSecondBoot;
}

+ (BOOL)hasBootedForVersion:(NSString *)version {
    NSUInteger times = [self timesBootedOfVersion:version];
    NSString *curVersion = currentVersion();
    BOOL hasBooted;
    if ([curVersion isEqualToString:version]) {
        hasBooted = times > 1;
    } else {
        hasBooted = times > 0;
    }
    return hasBooted;
}

@end
