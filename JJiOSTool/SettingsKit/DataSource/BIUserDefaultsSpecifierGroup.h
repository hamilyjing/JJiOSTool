//
//  BIUserDefaultsSpecifierGroup.h
//  SettingsKit
//
//  Created by HuGuanqin on 10/14/14.
//  Copyright (c) 2014 HuGuanqin. All rights reserved.
//

#import "BIUserDefaultsSpecifier.h"

@interface BIUserDefaultsSpecifierGroup : NSObject {
    BIUserDefaultsSpecifier *_sectionSpecifier;
    //NSMutableArray *_rowSpecifiers;
}

- (instancetype)initWithSpecifierGroup:(BIUserDefaultsSpecifierGroup *)group;

- (instancetype)initWithSectionSpecifier:(BIUserDefaultsSpecifier *)specifier;

- (void)appendRowSpecifier:(BIUserDefaultsSpecifier *)specifier;

- (void)removeRowSpecifier:(BIUserDefaultsSpecifier *)specifier;

- (void)insertRowSpecifier:(BIUserDefaultsSpecifier *)specifier atIndex:(NSUInteger)index;

- (void)removeRowSpecifierAtIndex:(NSUInteger)index;

- (BIUserDefaultsSpecifier *)rowSpecifierAtIndex:(NSUInteger)index;

- (BIUserDefaultsSpecifier *)sectionSpecifier;

- (NSArray *)rowSpecifiers;

- (NSUInteger)numberOfRows;

@end
