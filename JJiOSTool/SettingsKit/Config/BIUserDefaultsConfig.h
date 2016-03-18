//
//  BIUserDefaultsConfig.h
//  SettingsKit
//
//  Created by HuGuanqin on 9/24/14.
//  Copyright (c) 2014 HuGuanqin. All rights reserved.
//

#import "BIUserDefaultsStoring.h"

@interface BIUserDefaultsConfig : NSObject

+ (NSString *)defaultBundle;

+ (void)setDefaultBundle:(NSString *)bundleName;

+ (void)setUserDefaultsFile:(NSString *)filePath;

+ (void)setUserDefaultsStroing:(id<BIUserDefaultsStoring>)store;

+ (BOOL)debugEnable;

+ (void)setDebugEnable:(BOOL)enable;

@end
