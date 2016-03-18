//
//  BIUserDefaultsBackingStore.h
//  SettingsKit
//
//  Created by HuGuanqin on 9/27/14.
//  Copyright (c) 2014 HuGuanqin. All rights reserved.
//

#import "BIUserDefaultsStoring.h"

extern NSString *const BIUserDefaultsDidChangeNotification;

@interface BIUserDefaultsBackingStore : NSObject <BIUserDefaultsStoring>

+ (instancetype)sharedInstance;

- (void)setBackingStore:(id<BIUserDefaultsStoring>)store;

@end
