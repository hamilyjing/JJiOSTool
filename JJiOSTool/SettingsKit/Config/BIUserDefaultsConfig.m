//
//  BIUserDefaultsConfig.m
//  SettingsKit
//
//  Created by HuGuanqin on 9/24/14.
//  Copyright (c) 2014 HuGuanqin. All rights reserved.
//

#import "BIUserDefaultsConfig.h"
#import "BIUserDefaultsBackingStore.h"
#import "BIUserDefaultsFileStore.h"

@interface BIUserDefaultsConfig ()
@property (nonatomic, assign) BOOL debugEnable;
@property (nonatomic, strong) NSString *defaultBundleName;
@end

@implementation BIUserDefaultsConfig

+ (instancetype)sharedInstance {
    static BIUserDefaultsConfig *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[BIUserDefaultsConfig alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.defaultBundleName = @"UserDefaults";
    }
    return self;
}

+ (NSString *)defaultBundle {
    return [BIUserDefaultsConfig sharedInstance].defaultBundleName;
}

+ (void)setDefaultBundle:(NSString *)bundleName {
    [BIUserDefaultsConfig sharedInstance].defaultBundleName = bundleName;
}

+ (BOOL)debugEnable {
    return [BIUserDefaultsConfig sharedInstance].debugEnable;
}

+ (void)setDebugEnable:(BOOL)enable {
    [BIUserDefaultsConfig sharedInstance].debugEnable = enable;
}

+ (void)setUserDefaultsFile:(NSString *)filePath {
    id<BIUserDefaultsStoring> store = [[BIUserDefaultsFileStore alloc] init];
    [[BIUserDefaultsBackingStore sharedInstance] setBackingStore:store];
}

+ (void)setUserDefaultsStroing:(id<BIUserDefaultsStoring>)store {
    [[BIUserDefaultsBackingStore sharedInstance] setBackingStore:store];
}

@end
