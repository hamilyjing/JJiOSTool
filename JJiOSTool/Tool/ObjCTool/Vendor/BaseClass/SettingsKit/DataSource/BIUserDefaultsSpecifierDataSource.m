//
//  BIUserDefaultsSpecifierDataSource.m
//  SettingsKit
//
//  Created by HuGuanqin on 9/24/14.
//  Copyright (c) 2014 HuGuanqin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BIUserDefaultsSpecifierDataSource.h"
#import "BIUserDefaultsSpecifier+Private.h"
#import "BIUserDefaultsSpecifierGroup.h"
#import "BIUserDefaultsUpdates.h"
#import "BIUserDefaultsConfig.h"


@interface BIUserDefaultsSpecifierDataSource ()
@property (nonatomic, strong) NSBundle *bundle;
@property (nonatomic, strong) NSString *stringsTable;
@property (nonatomic, strong) NSArray *specifiers;
@property (nonatomic, strong) NSArray *dependences;
@property (nonatomic, strong) NSMutableArray *specifierGroups;
@end

@implementation BIUserDefaultsSpecifierDataSource

- (instancetype)init {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:[BIUserDefaultsConfig defaultBundle] ofType:@"bundle"];
    NSBundle *bundle = [NSBundle bundleWithPath:filePath];
    return [self initWithBundle:bundle];
}

- (instancetype)initWithBundle:(NSBundle *)bundle {
    return [self initWithPlist:BIUserDefaultsRootFile inBundle:bundle];
}

- (instancetype)initWithPlist:(NSString *)fileName inBundle:(NSBundle *)bundle {
    return [self initWithPlist:fileName inBundle:bundle stringsTable:nil];
}

- (instancetype)initWithPlist:(NSString *)fileName inBundle:(NSBundle *)bundle stringsTable:(NSString *)tableName {
    NSString *filePath = [bundle pathForResource:fileName ofType:@"plist"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSLog(@"initWithPlist File %@ Not Existed!!!", fileName);
        return nil;
    }
    
    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:filePath];
    if (dictionary == nil) {
        NSLog(@"initWithPlist File %@ Fomat Not Supported!!!", fileName);
        return nil;
    }
    
    NSArray *specifiers = [dictionary objectForKey:BIUserDefaultsSpecifiers];
    if (specifiers == nil) {
        NSLog(@"initWithPlist File %@ Fomat Not Supported - No Specifiers!!!", fileName);
        return nil;
    }
    
    NSString *stringsTable = [dictionary objectForKey:BIUserDefaultsStringsTable];
    if (stringsTable == nil) {
        stringsTable = tableName;
    }
    
    if ([stringsTable length] <= 0) {
        NSString *tablePath = [bundle pathForResource:fileName ofType:@"strings"];
        if ([[NSFileManager defaultManager] fileExistsAtPath:tablePath]) {
            stringsTable = fileName;
        } else {
            tablePath = [bundle pathForResource:BIUserDefaultsRootFile ofType:@"strings"];
            if ([[NSFileManager defaultManager] fileExistsAtPath:tablePath]) {
                stringsTable = BIUserDefaultsRootFile;
            }
        }
    }
    
    self.title = [dictionary objectForKey:BIUserDefaultsTitle];
    self.bundle = bundle;
    self.stringsTable = stringsTable;
    
    if ([stringsTable length] > 0) {
        self.title = [bundle localizedStringForKey:self.title value:nil table:stringsTable];
        
        NSMutableArray *array = [NSMutableArray array];
        [specifiers enumerateObjectsUsingBlock:^(NSDictionary *specifier, NSUInteger idx, BOOL *stop) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:specifier];
            [specifier enumerateKeysAndObjectsUsingBlock:^(NSString *key, id value, BOOL *stop) {
                if ([BISpecifierTitle isEqualToString:key] || [BISpecifierFooterText isEqualToString:key] || [BISpecifierDetailText isEqualToString:key]) {
                    if ([value isKindOfClass:[NSString class]]) {
                        NSString *localizedString = [bundle localizedStringForKey:value value:nil table:stringsTable];
                        [dict setObject:localizedString forKey:key];
                    }
                } else if ([BISpecifierTitles isEqualToString:key]) {
                    if ([value isKindOfClass:[NSArray class]]) {
                        NSMutableArray *titles = [NSMutableArray arrayWithCapacity:[value count]];
                        [value enumerateObjectsUsingBlock:^(NSString *title, NSUInteger idx, BOOL *stop) {
                            NSString *localizedString = [bundle localizedStringForKey:title value:nil table:stringsTable];
                            [titles addObject:localizedString];
                        }];
                        [dict setObject:titles forKey:key];
                    }
                } else if ([BISpecifierAlertController isEqualToString:key]) {
                    if ([value isKindOfClass:[NSDictionary class]]) {
                        NSMutableDictionary *alertController = [NSMutableDictionary dictionaryWithDictionary:value];
                        [value enumerateKeysAndObjectsUsingBlock:^(NSString *alertKey, id alertValue, BOOL *stop) {
                            if ([BISpecifierMessage isEqualToString:alertKey] || [BISpecifierConfirmActionTitle isEqualToString:alertKey] || [BISpecifierCancelActionTitle isEqualToString:alertKey]) {
                                NSString *localizedString = [bundle localizedStringForKey:alertValue value:nil table:stringsTable];
                                [alertController setObject:localizedString forKey:alertKey];
                            }
                        }];
                        [dict setObject:alertController forKey:key];
                    }
                }
            }];
            [array addObject:dict];
        }];
        specifiers = array;
    }

    return [self initWithSpecifiers:specifiers];
}

- (instancetype)initWithSpecifiers:(NSArray *)specifierDictionaries {
    self = [super init];
    if (self) {
        NSMutableArray *dependences = [NSMutableArray arrayWithCapacity:4];
        NSMutableArray *specifiers = [NSMutableArray arrayWithCapacity:8];
        [specifierDictionaries enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL *stop) {
            BIUserDefaultsSpecifier *item = [BIUserDefaultsSpecifier specifierWithDictionary:dict];
            [specifiers addObject:item];
            item.dataSource = self;
            
            if ([item propertyForKey:BISpecifierDependences]) {
                [dependences addObject:item];
            }
        }];
        self.specifiers = specifiers;
        self.specifierGroups = [NSMutableArray arrayWithCapacity:4];
        self.dependences = dependences;
        
        [self loadSpecifiers];
    }
    return self;
}


- (NSString *)description {
    return [_specifierGroups description];
}

- (void)clearAllSpecifiers {
    [_specifierGroups removeAllObjects];
}

- (void)loadSpecifiers {
    BIUserDefaultsSpecifierGroup *lastGroup = nil;
    for (BIUserDefaultsSpecifier *specifier in _specifiers) {
        if ([specifier isGroupSpecifier]) {
            if ([specifier isVisible]) {
                lastGroup = [[BIUserDefaultsSpecifierGroup alloc] initWithSectionSpecifier:specifier];
                [_specifierGroups addObject:lastGroup];
            } else {
                lastGroup = nil;
            }
        } else {
            if (lastGroup && [specifier isVisible]) {
                [lastGroup appendRowSpecifier:specifier];
            }
        }
    }
}

- (void)reloadSpecifiers {
    [self clearAllSpecifiers];
    [self loadSpecifiers];
}

- (NSUInteger)numberOfSections {
    return [_specifierGroups count];
}

- (NSUInteger)numberOfRowsInSection:(NSUInteger)section {
    return [[self specifierGroupAtIndex:section] numberOfRows];
}

- (BIUserDefaultsSpecifier *)specifierForSection:(NSInteger)section {
    return [self specifierGroupAtIndex:section].sectionSpecifier;
}

- (BIUserDefaultsSpecifier *)specifierForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [[self specifierGroupAtIndex:indexPath.section] rowSpecifierAtIndex:indexPath.row];
}

- (BIUserDefaultsSpecifier *)specifierForID:(NSString *)ID {
    for (BIUserDefaultsSpecifier *item in self.specifiers) {
        if ([item.identifier isEqualToString:ID]) {
            return item;
        }
    }
    return nil;
}

- (NSArray *)specifierRowsInSection:(NSUInteger)section {
    return [[self specifierGroupAtIndex:section] rowSpecifiers];
}

- (BIUserDefaultsSpecifierGroup *)specifierGroupAtIndex:(NSUInteger)index {
    if (index < [_specifierGroups count]) {
        return [_specifierGroups objectAtIndex:index];
    }
    return nil;
}

- (NSSet *)allKeys {
    NSMutableSet *keys = [NSMutableSet setWithCapacity:8];
    for (BIUserDefaultsSpecifier *specifier in _specifiers) {
        if (specifier.key && ![keys containsObject:specifier.key]) {
            [keys addObject:specifier.key];
        }
        
        NSArray *dependences = [specifier propertyForKey:BISpecifierDependences];
        for (NSDictionary *dependence in dependences) {
            NSString *key = [dependence objectForKey:BISpecifierDependenceKey];
            if (key && ![keys containsObject:key]) {
                [keys addObject:key];
            }
        }
    }
    return keys;
}


- (NSIndexPath *)indexPathForSpecifier:(BIUserDefaultsSpecifier *)specifier {
    __block NSIndexPath *indexPath = nil;
    [self.specifierGroups enumerateObjectsUsingBlock:^(BIUserDefaultsSpecifierGroup *group, NSUInteger section, BOOL *stop) {
        if ([group sectionSpecifier] == specifier) {
            indexPath = [NSIndexPath indexPathForRow:0 inSection:section];
        } else {
            [[group rowSpecifiers] enumerateObjectsUsingBlock:^(BIUserDefaultsSpecifier *item, NSUInteger row, BOOL *stop) {
                if (item == specifier) {
                    indexPath = [NSIndexPath indexPathForRow:row inSection:section];
                }
            }];
        }
        
        if (indexPath != nil) {
            *stop = YES;
        }
    }];
    return indexPath;
}

- (NSString *)localizedStringForKey:(NSString *)key {
    return [self.bundle localizedStringForKey:key value:nil table:self.stringsTable];
}

#pragma mark - Update

- (BIUserDefaultsUpdates *)updatesWithChangedKeys:(NSArray *)keys {
    BIUserDefaultsUpdates *updates = [[BIUserDefaultsUpdates alloc] initWithOriginalGroups:self.specifierGroups];
    
    NSMutableArray *dependenceKeys = [NSMutableArray arrayWithCapacity:[keys count]];
    if ([self.dependences count] > 0) {
        [self.dependences enumerateObjectsUsingBlock:^(BIUserDefaultsSpecifier *item, NSUInteger idx, BOOL *stop) {
            [item.dependences enumerateObjectsUsingBlock:^(NSDictionary *dependence, NSUInteger idx, BOOL *stop) {
                NSString *dependenceKey = [dependence dependenceKey];
                if ([keys containsObject:dependenceKey]) {
                    [dependenceKeys addObject:dependenceKey];
                }
            }];
        }];
    }
    
    if ([dependenceKeys count] > 0) {
        [self updates:updates removeOperationsWithChangedKeys:dependenceKeys];
        [self updates:updates reloadOperationsWithChangedKeys:keys];
        [self updates:updates insertOperationsWithChangedKeys:dependenceKeys];
    } else {
        [self updates:updates reloadOperationsWithChangedKeys:keys];
    }
    
    return [updates.updates count] > 0 ? updates : nil;
}

- (void)updates:(BIUserDefaultsUpdates *)updates removeOperationsWithChangedKeys:(NSArray *)keys {
    [self.specifierGroups enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(BIUserDefaultsSpecifierGroup *group, NSUInteger section, BOOL *stop) {
        BIUserDefaultsSpecifier *specifier = [group sectionSpecifier];
        if (![specifier isVisible]) {
            [updates removeSectionAtIndex:section];
        } else {
            [[group rowSpecifiers] enumerateObjectsUsingBlock:^(BIUserDefaultsSpecifier *specifier, NSUInteger row, BOOL *stop) {
                if (![specifier isVisible]) {
                    [updates removeSpecifierAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];
                }
            }];
        }
    }];
}

- (void)updates:(BIUserDefaultsUpdates *)updates reloadOperationsWithChangedKeys:(NSArray *)keys {
    [updates.originalGroups enumerateObjectsUsingBlock:^(BIUserDefaultsSpecifierGroup *group, NSUInteger section, BOOL *stop) {
        BOOL reloadSection = NO;
        
        NSArray *reloadDependences = [group.sectionSpecifier reloadDependences];
        for (NSDictionary *dependence in reloadDependences) {
            if ([keys containsObject:[dependence dependenceKey]]) {
                [updates reloadSectionAtIndex:section];
                reloadSection = YES;
                break;
            }
        }
        
        if (!reloadSection) {
            [[group rowSpecifiers] enumerateObjectsUsingBlock:^(BIUserDefaultsSpecifier *specifier, NSUInteger row, BOOL *stop) {
                BOOL reloadRow = [keys containsObject:[specifier key]];
                if (!reloadRow) {
                    NSArray *reloadDependences = [specifier reloadDependences];
                    for (NSDictionary *dependence in reloadDependences) {
                        if ([keys containsObject:[dependence dependenceKey]]) {
                            reloadRow = YES;
                            break;
                        }
                    }
                }
                
                if (reloadRow) {
                    [updates reloadSpecifier:specifier atIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];
                }
            }];
        }
    }];
}

- (void)updates:(BIUserDefaultsUpdates *)updates insertOperationsWithChangedKeys:(NSArray *)keys {
    NSUInteger row = 0;
    NSUInteger section = 0;
    for (NSInteger i = 0; i < [_specifiers count]; i++) {
        BIUserDefaultsSpecifier *specifier = [_specifiers objectAtIndex:i];
        if ([specifier isGroupSpecifier]) {
            // 跳过不显示的Section
            if (![specifier isVisible]) {
                while ((++i) < [_specifiers count]) {
                    specifier = [_specifiers objectAtIndex:i];
                    if ([specifier isGroupSpecifier] && [specifier isVisible]) {
                        break;
                    }
                }
            }
            
            if ([specifier isGroupSpecifier] && [specifier isVisible]) {
                BOOL found = NO;
                if ([updates.currentGroups count] > section) {
                    BIUserDefaultsSpecifierGroup *group = [updates.currentGroups objectAtIndex:section];
                    if ([group sectionSpecifier] == specifier) {
                        found = YES;
                    }
                }
                
                // 不存在，插入Section
                if (!found) {
                    BIUserDefaultsSpecifierGroup *group = [[BIUserDefaultsSpecifierGroup alloc] initWithSectionSpecifier:specifier];
                    [updates insertSection:group atIndex:section];
                }

                section++;
                row = 0;
            }
        } else {
            if ([specifier isVisible]) {
                NSUInteger sectionIndex = section - 1;
                if ([updates.currentGroups count] > sectionIndex) {
                    BIUserDefaultsSpecifierGroup *group = [updates.currentGroups objectAtIndex:sectionIndex];
                    
                    BOOL found = NO;
                    if ([[group rowSpecifiers] count] > row) {
                        BIUserDefaultsSpecifier *item = [[group rowSpecifiers] objectAtIndex:row];
                        if (item == specifier) {
                            found = YES;
                        }
                    }
                    
                    // 不存在，插入Row
                    if (!found) {
                        [updates insertSpecifier:specifier atIndexPath:[NSIndexPath indexPathForRow:row inSection:sectionIndex]];
                    }
                }
                row++;
            }
        }
    }
}

@end
