//
//  BIUserDefaultsUpdateOperation.m
//  SettingsKit
//
//  Created by HuGuanqin on 10/14/14.
//  Copyright (c) 2014 HuGuanqin. All rights reserved.
//

#import "BIUserDefaultsSpecifier+Private.h"
#import "BIUserDefaultsUpdateOperation.h"
#import "BIUserDefaultsDefines.h"

@implementation BIUserDefaultsUpdateOperation

+ (instancetype)moveOperationWithSpecifier:(BIUserDefaultsSpecifier *)specifier fromIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    return [[BIUserDefaultsUpdateOperation alloc] initWithType:BIUserDefaultsUpdateOperationTypeMove specifier:specifier fromIndexPath:fromIndexPath toIndexPath:toIndexPath];
}

+ (instancetype)reloadOperationWithSpecifier:(BIUserDefaultsSpecifier *)specifier atIndexPath:(NSIndexPath *)indexPath {
    return [[BIUserDefaultsUpdateOperation alloc] initWithType:BIUserDefaultsUpdateOperationTypeReload specifier:specifier indexPath:indexPath];
}

+ (instancetype)removeOperationWithSpecifier:(BIUserDefaultsSpecifier *)specifier atIndexPath:(NSIndexPath *)indexPath {
    return [[BIUserDefaultsUpdateOperation alloc] initWithType:BIUserDefaultsUpdateOperationTypeRemove specifier:specifier indexPath:indexPath];
}

+ (instancetype)insertOperationWithSpecifier:(BIUserDefaultsSpecifier *)specifier atIndexPath:(NSIndexPath *)indexPath {
    return [[BIUserDefaultsUpdateOperation alloc] initWithType:BIUserDefaultsUpdateOperationTypeInsert specifier:specifier indexPath:indexPath];
}

- (instancetype)initWithType:(BIUserDefaultsUpdateOperationType)type specifier:(BIUserDefaultsSpecifier *)specifier fromIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    self = [super init];
    if (self) {
        _type = type;
        self.specifier = specifier;
        self.indexPath = fromIndexPath;
        self.toIndexPath = toIndexPath;
    }
    return self;
}

- (instancetype)initWithType:(BIUserDefaultsUpdateOperationType)type specifier:(BIUserDefaultsSpecifier *)specifier indexPath:(NSIndexPath *)indexPath {
    return [self initWithType:type specifier:specifier fromIndexPath:indexPath toIndexPath:nil];
}


@end
