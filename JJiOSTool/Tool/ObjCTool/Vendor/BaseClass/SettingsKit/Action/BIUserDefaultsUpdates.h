//
//  BIUserDefaultsUpdates.h
//  SettingsKit
//
//  Created by HuGuanqin on 10/14/14.
//  Copyright (c) 2014 HuGuanqin. All rights reserved.
//

#import "BIUserDefaultsSpecifierGroup.h"
#import "BIUserDefaultsSpecifier.h"

@class BIUserDefaultsSpecifierDataSource;

@interface BIUserDefaultsUpdates : NSObject

@property (nonatomic, strong, readonly) NSArray *updates;
@property (nonatomic, strong, readonly) NSArray *currentGroups;
@property (nonatomic, strong, readonly) NSArray *originalGroups;

- (instancetype)initWithOriginalGroups:(NSArray *)groups;

- (void)removeSection:(BIUserDefaultsSpecifier *)specifier;

- (void)removeSectionAtIndex:(NSUInteger)index;

- (void)reloadSectionAtIndex:(NSUInteger)index;

- (void)insertSection:(BIUserDefaultsSpecifierGroup *)group atIndex:(NSUInteger)index;

- (void)removeSpecifierAtIndexPath:(NSIndexPath *)indexPath;

- (void)reloadSpecifier:(BIUserDefaultsSpecifier *)specifier atIndexPath:(NSIndexPath *)indexPath;

- (void)insertSpecifier:(BIUserDefaultsSpecifier *)specifier atIndexPath:(NSIndexPath *)indexPath;

- (void)applyToDataSource:(BIUserDefaultsSpecifierDataSource *)dataSource;

- (void)applyToTableView:(UITableView *)tableView;

@end
