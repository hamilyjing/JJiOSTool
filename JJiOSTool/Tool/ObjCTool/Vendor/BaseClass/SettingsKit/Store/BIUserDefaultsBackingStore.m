//
//  BIUserDefaultsBackingStore.m
//  SettingsKit
//
//  Created by HuGuanqin on 9/27/14.
//  Copyright (c) 2014 HuGuanqin. All rights reserved.
//

#import "BIUserDefaultsBackingStore.h"
#import "BIUserDefaultsStandardStore.h"

NSString *const BIUserDefaultsDidChangeNotification = @"BIUserDefaultsDidChangeNotification";

@interface BIUserDefaultsBackingStore ()
@property (nonatomic, strong) id<BIUserDefaultsStoring> storeProxy;
@end

@implementation BIUserDefaultsBackingStore

+ (instancetype)sharedInstance {
    static BIUserDefaultsBackingStore *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[BIUserDefaultsBackingStore alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _storeProxy = [[BIUserDefaultsStandardStore alloc] init];
    }
    return self;
}


- (void)setBackingStore:(id<BIUserDefaultsStoring>)store {
    self.storeProxy = store;
    
    //默认使用标准UserDefaults-[NSUserDefaults standardUserDefaults]
    if (store == nil) {
        _storeProxy = [[BIUserDefaultsStandardStore alloc] init];
    }
}

- (id)objectForKey:(NSString *)key {
    return [_storeProxy objectForKey:key];
}

- (NSString *)stringForKey:(NSString *)key {
    return [_storeProxy stringForKey:key];
}

- (NSArray *)arrayForKey:(NSString *)key {
    return [_storeProxy arrayForKey:key];
}

- (NSDictionary *)dictionaryForKey:(NSString *)key {
    return [_storeProxy dictionaryForKey:key];
}

- (NSData *)dataForKey:(NSString *)key {
    return [_storeProxy dataForKey:key];
}

- (NSArray *)stringArrayForKey:(NSString *)key {
    return [_storeProxy stringArrayForKey:key];
}

- (NSInteger)integerForKey:(NSString *)key {
    return [_storeProxy integerForKey:key];
}

- (float)floatForKey:(NSString *)key {
    return [_storeProxy floatForKey:key];
}

- (double)doubleForKey:(NSString *)key {
    return [_storeProxy doubleForKey:key];
}

- (BOOL)boolForKey:(NSString *)key {
    return [_storeProxy boolForKey:key];
}

- (void)setObject:(id)value forKey:(NSString *)key {
    // 确认变化再保存
    if ([_storeProxy objectForKey:key] == nil || ![[_storeProxy objectForKey:key] isEqual:value]) {
        [_storeProxy setObject:value forKey:key];
        
        // [NSUserDefaults standardUserDefaults]系统会发通知
        if (![_storeProxy isKindOfClass:[BIUserDefaultsStandardStore class]]) {
            [self sendChangedNotificationWithKey:key value:value];
        }
    }
}

- (void)setInteger:(NSInteger)value forKey:(NSString *)key {
    // 确认变化再保存
    if ([_storeProxy objectForKey:key] == nil || [_storeProxy integerForKey:key] != value) {
        [_storeProxy setInteger:value forKey:key];
        
        // [NSUserDefaults standardUserDefaults]系统会发通知
        if (![_storeProxy isKindOfClass:[BIUserDefaultsStandardStore class]]) {
            [self sendChangedNotificationWithKey:key value:[NSNumber numberWithInteger:value]];
        }
    }
}

- (void)setFloat:(float)value forKey:(NSString *)key {
    // 确认变化再保存
    if ([_storeProxy objectForKey:key] == nil || [_storeProxy floatForKey:key] != value) {
        [_storeProxy setFloat:value forKey:key];
        
        // [NSUserDefaults standardUserDefaults]系统会发通知
        if (![_storeProxy isKindOfClass:[BIUserDefaultsStandardStore class]]) {
            [self sendChangedNotificationWithKey:key value:[NSNumber numberWithFloat:value]];
        }
    }
}

- (void)setDouble:(double)value forKey:(NSString *)key {
    // 确认变化再保存
    if ([_storeProxy objectForKey:key] == nil || [_storeProxy doubleForKey:key] != value) {
        [_storeProxy setDouble:value forKey:key];
        
        // [NSUserDefaults standardUserDefaults]系统会发通知
        if (![_storeProxy isKindOfClass:[BIUserDefaultsStandardStore class]]) {
            [self sendChangedNotificationWithKey:key value:[NSNumber numberWithDouble:value]];
        }
    }
}

- (void)setBool:(BOOL)value forKey:(NSString *)key {
    // 确认变化再保存
    if ([_storeProxy objectForKey:key] == nil || [_storeProxy boolForKey:key] != value) {
        [_storeProxy setBool:value forKey:key];
        
        // [NSUserDefaults standardUserDefaults]系统会发通知
        if (![_storeProxy isKindOfClass:[BIUserDefaultsStandardStore class]]) {
            [self sendChangedNotificationWithKey:key value:[NSNumber numberWithBool:value]];
        }
    }
}

- (void)removeObjectForKey:(NSString *)key {
    // 确认变化再保存
    if ([_storeProxy objectForKey:key]) {
        [_storeProxy removeObjectForKey:key];
        
        // [NSUserDefaults standardUserDefaults]系统会发通知
        if (![_storeProxy isKindOfClass:[BIUserDefaultsStandardStore class]]) {
            [self sendChangedNotificationWithKey:key value:nil];
        }
    }
}


- (BOOL)synchronize {
    return [_storeProxy synchronize];
}

#pragma mark - Private

- (void)sendChangedNotificationWithKey:(NSString *)key value:(id)value {
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithCapacity:1];
    if (value != nil) {
        [userInfo setObject:value forKey:key];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:BIUserDefaultsDidChangeNotification
                                                        object:key
                                                      userInfo:userInfo];
}

@end
