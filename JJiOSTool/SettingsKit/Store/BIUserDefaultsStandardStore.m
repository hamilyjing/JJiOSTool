//
//  BIUserDefaultsStandardStore.m
//  SettingsKit
//
//  Created by HuGuanqin on 9/27/14.
//  Copyright (c) 2014 HuGuanqin. All rights reserved.
//

#import "BIUserDefaultsStandardStore.h"

@implementation BIUserDefaultsStandardStore

- (void)removeObjectForKey:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
}

- (id)objectForKey:(NSString *)key {
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

- (NSString *)stringForKey:(NSString *)key {
    return [[NSUserDefaults standardUserDefaults] stringForKey:key];
}

- (NSArray *)arrayForKey:(NSString *)key {
    return [[NSUserDefaults standardUserDefaults] arrayForKey:key];
}

- (NSDictionary *)dictionaryForKey:(NSString *)key {
    return [[NSUserDefaults standardUserDefaults] dictionaryForKey:key];
}

- (NSData *)dataForKey:(NSString *)key {
    return [[NSUserDefaults standardUserDefaults] dataForKey:key];
}

- (NSArray *)stringArrayForKey:(NSString *)key {
    return [[NSUserDefaults standardUserDefaults] stringArrayForKey:key];
}

- (NSInteger)integerForKey:(NSString *)key {
    return [[NSUserDefaults standardUserDefaults] integerForKey:key];
}

- (float)floatForKey:(NSString *)key {
    return [[NSUserDefaults standardUserDefaults] floatForKey:key];
}

- (double)doubleForKey:(NSString *)key {
    return [[NSUserDefaults standardUserDefaults] doubleForKey:key];
}

- (BOOL)boolForKey:(NSString *)key {
    return [[NSUserDefaults standardUserDefaults] boolForKey:key];
}

- (void)setObject:(id)value forKey:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
}

- (void)setInteger:(NSInteger)value forKey:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] setInteger:value forKey:key];
}

- (void)setFloat:(float)value forKey:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] setFloat:value forKey:key];
}

- (void)setDouble:(double)value forKey:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] setDouble:value forKey:key];
}

- (void)setBool:(BOOL)value forKey:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] setBool:value forKey:key];
}

- (BOOL)synchronize {
    return [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
