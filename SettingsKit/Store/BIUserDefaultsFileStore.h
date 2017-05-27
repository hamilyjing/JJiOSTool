//
//  BIUserDefaultsFileStore.h
//  SettingsKit
//
//  Created by HuGuanqin on 9/27/14.
//  Copyright (c) 2014 HuGuanqin. All rights reserved.
//

#import "BIUserDefaultsStoring.h"

@interface BIUserDefaultsFileStore : NSObject <BIUserDefaultsStoring>

- (id)initWithContentsOfFile:(NSString *)path;

@end
