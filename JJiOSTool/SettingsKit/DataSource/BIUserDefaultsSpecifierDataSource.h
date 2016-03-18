//
//  BIUserDefaultsSpecifierDataSource.h
//  SettingsKit
//
//  Created by HuGuanqin on 9/24/14.
//  Copyright (c) 2014 HuGuanqin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BIUserDefaultsSpecifier;
@class BIUserDefaultsUpdates;

@interface BIUserDefaultsSpecifierDataSource : NSObject

@property (nonatomic, weak) id target;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong, readonly) NSBundle *bundle;
@property (nonatomic, strong, readonly) NSString *stringsTable;

- (instancetype)initWithBundle:(NSBundle *)bundle;
- (instancetype)initWithPlist:(NSString *)fileName inBundle:(NSBundle *)bundle;
- (instancetype)initWithPlist:(NSString *)fileName inBundle:(NSBundle *)bundle stringsTable:(NSString *)tableName;
- (instancetype)initWithSpecifiers:(NSArray *)specifiers;

#pragma mark - TableView Helper

- (NSUInteger)numberOfSections;
- (NSUInteger)numberOfRowsInSection:(NSUInteger)section;
- (BIUserDefaultsSpecifier *)specifierForSection:(NSInteger)section;
- (BIUserDefaultsSpecifier *)specifierForRowAtIndexPath:(NSIndexPath *)indexPath;
- (BIUserDefaultsSpecifier *)specifierForID:(NSString *)ID;
- (NSIndexPath *)indexPathForSpecifier:(BIUserDefaultsSpecifier *)specifier;
- (NSString *)localizedStringForKey:(NSString *)key;

- (BIUserDefaultsUpdates *)updatesWithChangedKeys:(NSArray *)keys;

@end
