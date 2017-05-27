//
//  BIUserDefaultsUpdateOperation.h
//  SettingsKit
//
//  Created by HuGuanqin on 10/14/14.
//  Copyright (c) 2014 HuGuanqin. All rights reserved.
//

#import "BIUserDefaultsSpecifier.h"

typedef NS_ENUM(NSInteger, BIUserDefaultsUpdateOperationType) {
    BIUserDefaultsUpdateOperationTypeReload,
    BIUserDefaultsUpdateOperationTypeRemove,
    BIUserDefaultsUpdateOperationTypeInsert,
    BIUserDefaultsUpdateOperationTypeMove, // Not Support
};

@interface BIUserDefaultsUpdateOperation : NSObject

@property (nonatomic, readonly) BIUserDefaultsUpdateOperationType type;
@property (nonatomic, strong) BIUserDefaultsSpecifier *specifier;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) NSIndexPath *toIndexPath;

+ (instancetype)moveOperationWithSpecifier:(BIUserDefaultsSpecifier *)specifier fromIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath;
+ (instancetype)reloadOperationWithSpecifier:(BIUserDefaultsSpecifier *)specifier atIndexPath:(NSIndexPath *)indexPath;
+ (instancetype)removeOperationWithSpecifier:(BIUserDefaultsSpecifier *)specifier atIndexPath:(NSIndexPath *)indexPath;
+ (instancetype)insertOperationWithSpecifier:(BIUserDefaultsSpecifier *)specifier atIndexPath:(NSIndexPath *)indexPath;

- (instancetype)initWithType:(BIUserDefaultsUpdateOperationType)type specifier:(BIUserDefaultsSpecifier *)specifier fromIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath;
- (instancetype)initWithType:(BIUserDefaultsUpdateOperationType)type specifier:(BIUserDefaultsSpecifier *)specifier indexPath:(NSIndexPath *)indexPath;

@end
