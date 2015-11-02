//
//  BIUserDefaultsFileStore.m
//  SettingsKit
//
//  Created by HuGuanqin on 9/27/14.
//  Copyright (c) 2014 HuGuanqin. All rights reserved.
//

#import "BIUserDefaultsFileStore.h"

@implementation BIUserDefaultsFileStore {
    BOOL                 _modified;
    NSString            *_filePath;
    NSRecursiveLock     *_accessLock;
    NSMutableDictionary *_dictionary;
}

- (id)initWithContentsOfFile:(NSString *)path {
    self = [super init];
    if (self) {
        _accessLock = [[NSRecursiveLock alloc] init];
        _filePath   = [[NSString alloc] initWithString:path];
        _dictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
        if (!_dictionary) {
            _dictionary = [[NSMutableDictionary alloc] initWithCapacity:32];
            
        }
    }
    return self;
}


#pragma mark - Public

- (id)objectForKey:(NSString *)key {
    id object = nil;
    
    [_accessLock lock];
    @try {
        object = [_dictionary objectForKey:key];
    } @catch (NSException *exception) {
        NSLog(@"Exception: %@", exception);
    } @finally {
        [_accessLock unlock];
    }
    return object;
}

- (NSData *)dataForKey:(NSString *)key {
    id	obj = [self objectForKey:key];
    if (obj && [obj isKindOfClass:[NSData class]]) {
        return obj;
    }
    return nil;
}

- (NSString *)stringForKey:(NSString *)key {
    id obj = [self objectForKey:key];
    if (obj && [obj isKindOfClass:[NSString class]]) {
        return obj;
    }
    return nil;
}

- (NSArray *)arrayForKey:(NSString *)key {
    id obj = [self objectForKey:key];
    if (obj && [obj isKindOfClass:[NSArray class]]) {
        return obj;
    }
    return nil;
}

- (NSDictionary *)dictionaryForKey:(NSString *)key {
    id obj = [self objectForKey:key];
    if (obj && [obj isKindOfClass:[NSDictionary class]]) {
        return obj;
    }
    return nil;
}

- (NSArray *)stringArrayForKey:(NSString *)key {
    NSArray *array = [self arrayForKey:key];
    if (array) {
        for (id obj in array) {
            if (![obj isKindOfClass:[NSString class]]) {
                return nil;
            }
        }
        return array;
    }
    return nil;
}

- (BOOL)boolForKey:(NSString *)key {
    id obj = [self objectForKey:key];
    if (obj && ([obj isKindOfClass:[NSString class]] || [obj isKindOfClass:[NSNumber class]])) {
        return [obj boolValue];
    }
    return NO;
}

- (double)doubleForKey:(NSString *)key {
    id obj = [self objectForKey:key];
    if (obj && ([obj isKindOfClass:[NSString class]] || [obj isKindOfClass:[NSNumber class]])) {
        return [obj doubleValue];
    }
    return 0.0;
}

- (float)floatForKey:(NSString *)key {
    id obj = [self objectForKey:key];
    if (obj && ([obj isKindOfClass:[NSString class]] || [obj isKindOfClass:[NSNumber class]])) {
        return [obj floatValue];
    }
    return 0.0;
}

- (NSInteger)integerForKey:(NSString *)key {
    id obj = [self objectForKey:key];
    if (obj && ([obj isKindOfClass:[NSString class]] || [obj isKindOfClass:[NSNumber class]])) {
        return [obj integerValue];
    }
    return 0;
}


- (void)removeObjectForKey:(NSString *)key {
    [_accessLock lock];
    @try {
        id obj = [_dictionary objectForKey:key];
        if (nil != obj) {
            _modified = YES;
            [_dictionary removeObjectForKey:key];
        }
    } @catch (NSException *exception) {
        NSLog(@"Exception: %@", exception);
    } @finally {
        [_accessLock unlock];
    }
}

- (void)setObject:(id)value forKey:(NSString *)key {
    if ([key isKindOfClass:[NSString class]] == NO || [key length] == 0) {
        return;
    }
    
    if (!value) {
        return [self removeObjectForKey:key];
    }
    
    [_accessLock lock];
    @try {
        _modified = YES;
        
        value = [value copy];
        [_dictionary setObject:value forKey:key];
    } @catch (NSException *exception) {
        NSLog(@"Exception: %@", exception);
    } @finally {
        [_accessLock unlock];
    }
}


- (void)setBool:(BOOL)value forKey:(NSString *)key {
    if (value == YES) {
        [self setObject:@"YES" forKey:key];
    } else {
        [self setObject:@"NO" forKey:key];
    }
}

- (void)setDouble:(double)value forKey:(NSString *)key {
    [self setObject:[NSNumber numberWithDouble:value] forKey:key];
}

- (void)setFloat:(float)value forKey:(NSString *)key {
    [self setObject:[NSNumber numberWithFloat:value] forKey:key];
}

- (void)setInteger:(NSInteger)value forKey:(NSString *)key {
    [self setObject:[NSNumber numberWithInteger:value] forKey:key];
}

- (BOOL)synchronize {
    BOOL sync = NO;
    
    [_accessLock lock];
    @try {
        if (_modified) {
            sync = [_dictionary writeToFile:_filePath atomically:YES];
            if (sync) {
                _modified = NO;
            }
        }
    }
    @catch (NSException *exception)
    {
        NSLog(@"Exception: %@", exception);
    }
    @finally
    {
        [_accessLock unlock];
    }
    return sync;
}


@end
